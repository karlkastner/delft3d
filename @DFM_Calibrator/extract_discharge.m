% Sun  7 Aug 14:45:40 CEST 2016
% Karl Kastner, Berlin

function [out, Q, A, mesh] = extract_discharge(mapname_C,t0,x0,y0,name_C)
	blocksize = 1000;

	time  = [];
	Q = [];
	A = [];
	e2e = {};

	% for each map file
	for idx=1:length(mapname_C)
		% read blockwise (in case map file size exceeds memory)
		bdx = 1;
		while (true)
			% read file
			%[map = nc_readall(mapname_C{idx});
			map = nc_read_sequential(mapname_C{idx},'time',bdx,blocksize);
			if (isempty(map))
				break;
			end
			%map = mesh.import_delft3d(mapname_C{idx});
	%	X   = map.NetNode_x;
	%	Y   = map.NetNode_y;
		if (1 == idx && 1 == bdx)
			mesh = UnstructuredMesh();
			mesh.import_delft3d(map);
			mesh.edges_from_elements();
			path = {};
			for jdx=1:size(x0,1)
				% get points closest to output points
				[dis, path{jdx}] = mesh.path([x0(jdx,:)',y0(jdx,:)'],false);
			end
		end % if
		% extract time
		time = [time; cvec(map.time)];
		Qi = [];
		Ai = [];
		for jdx=1:length(path)
	if (0)
			[Qi(jdx,:), Ai(jdx,:), qseg, aseg, e2e{jdx}] = mesh.integrate_discharge( ...
							  path{jdx} ...
							, [] ...
							, map.waterdepth ...
							, map.FlowLink ...
							, map.unorm ...
							, []);
	else
			[Qi(jdx,:), Ai(jdx,:), qseg, aseg, e2e{jdx}] = mesh.integrate_discharge( ...
							  path{jdx} ...
							, [] ...
							, map.waterdepth ...
							, [] ...
							, map.ucx ...
							, map.ucy);
	end % if
		end % for jdx
		Q = [Q,Qi];
		A = [A,Ai];
			
		clear map
		bdx = bdx+1
		end % while
	end % for idx
	
	% sort
	[time, sdx] = sort(time);
	Q          = Q(:,sdx);
	A          = A(:,sdx);
	
	% transform time
	if (isstr(t0))
		t0 = datenum(t0);
	end
	time = t0 + time/86400;
	
	Q = Q';
	A = A';
	
	out = struct();
	out.time = time;
	for idx=1:size(x0,1)
		out(idx).Q         = Q(:,idx);
		out(idx).A         = A(:,idx);
		out(idx).placename = name_C{idx};
		out(idx).X = x0(idx,:);
		out(idx).Y = y0(idx,:);
		out(idx).path = path{idx};
		out(idx).elem = e2e{idx};
	end % for idx
	
end % delft3d_extract_discharge

