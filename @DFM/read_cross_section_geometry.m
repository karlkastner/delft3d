% Mon  5 Dec 13:37:35 CET 2016
% Karl Kastner, Berlin

function [mesh Xc Yc W X Y Z obj] = read_cross_section_geometry(name,mesh)
	Xc  = [];
	Yc  = [];
	W   = [];
	TYPE  = [];
	rgh = [];
	flag = false(0);
	
	% read profile type
	% XXXX_profdef.txt
	% PROFNR=%d	TYPE=201 FCCCF=%f
	% TODO test if type is 201
	% TODO TEST for completeness

	line_C = {};
	try
		line_C = textread([name,'_profdef.txt'],'%s', 'delimiter', '\n');
	catch
		fprintf(1,['Cannot open file ', name,'_profdef.txt for reading\n']);
	end
	
	% for each line
	for idx=1:length(line_C)
		C = strsplit(line_C{idx},'\s\s*');
		F_i = NaN;
		T_i = NaN;
		P_i = 0;
		for jdx=1:length(C)
			CC = strsplit(C{jdx},'=');
			switch (length(CC))
			case {1}
				fprintf('Line %d: Skipping parameter %s, has no value\n',idx,CC{1});
			case {2}
				switch (CC{1})
					case {'FRCCF'}
						F_i = str2num(CC{2});
					case {'TYPE'}
						T_i = str2num(CC{2});
					case {'PROFNR'}
						P_i = str2num(CC{2});
					otherwise
						fprintf('Line %d: Skipping parameter %s, unknown\n',idx,CC{1});
				end % switch CC
			otherwise
				fprintf('Line %d: Skipping parameter %s, = is globbered\n',idx,CC{1});
			end % switch (length(CC))
		end % for jdx
		if (P_i > 0)
			flag(P_i,1)  = true;
			rgh(P_i,1)   = F_i;
			TYPE(P_i,1)  = T_i;
		else
			fprintf(1,'Line %d, discarding, as no profile number given\n',idx);
		end % else of P_i > 0
	end % for idx

	if (any(~flag))
		fprintf('Warning: Profiles are not continuously numbered\n');
	end

	% read profile location
	% XXXX_profloc.xyz
	% x, y, id
	try
		[Xc_ Yc_ id] = textread([name,'_profloc.xyz']);
	catch
		Xc_ = [];
		fprintf('Cannot read 1d cross section location from profloc.xyz\n');
	end

	if (~isempty(Xc_))
		n  = max(id);
		Xc = NaN(n,1);
		Yc = NaN(n,1);
		Xc(id) = Xc_;
		Yc(id) = Yc_;
	else
		% without profloc, reading xyz makes no sense
		return;
	end

	if (isempty(rgh))
		rgh = NaN(size(Xc));
	end

	% read actual profile
	% XXX.xyzprof
	try
	        line_C = textread([name,'.xyzprof'],'%s', 'delimiter', '\n');                
	catch
		fprintf('Cannot read 1d cross section profile file (xyzprof)\n'); 
		line_C = {};
	end

	if (~isempty(line_C))
		
		state='nr';
		jd = 0;
		X = NaN(n,2);
		Y = NaN(n,2);
		Z = NaN(n,2);
		for idx=1:length(line_C)
			switch(state)
			case {'nr'}
				[nr count] = sscanf(line_C{idx},'PROFNR=%d');
				if (count > 0)
					jd = jd+1;
					state = 'dim';
				end
			case {'dim'}
				dim   = sscanf(line_C{idx},'%d %d');
				cdx   = 0;
				state = 'coord';
			case {'coord'}
				cdx = cdx+1;
				XYZ = sscanf(line_C{idx},'%f %f %f');
				X(nr,cdx) = XYZ(1);
				Y(nr,cdx) = XYZ(2);
				Z(nr,cdx) = XYZ(3);
				if (dim(1) == cdx)
					state = 'nr';
				end
			end % state
		end % while 1
	
		% compute width of 1d elements
		% TODO this assumes a profile with 2 points across the section only
		W     = hypot(diff(X,[],2), diff(Y,[],2));
		% transversal slope
		dz_dn = (Z(:,2)-Z(:,1))./W;
	
		fprintf('Min  w %f\n',min(W));
		fprintf('Mean w %f\n',mean(W));
		fprintf('Max  w %f\n',max(W));
	
		% match profiles with 1d elements
		if (nargin > 1)
			[elem2 fdx] = mesh.elemN(2);
			if (~isempty(elem2))
				Xe = 0.5*(mesh.X(elem2(:,1))+mesh.X(elem2(:,2)));
				Ye = 0.5*(mesh.Y(elem2(:,1))+mesh.Y(elem2(:,2)));
				id = knnsearch([Xe,Ye],[Xc Yc]);
				pd = elem2(id,:);
				mesh.pval.width = accumarray([pd(:,1); pd(:,2)], [W;W], [mesh.np,1],@mean,NaN);
				mesh.pval.dz_dn = accumarray([pd(:,1); pd(:,2)], [dz_dn;dz_dn], [mesh.np,1],@mean,NaN);
				%rgh_2d = mesh.pval.rgh;
				%fdx = isfinite(rgh_2d);
				rgh_1d   = accumarray([pd(:,1); pd(:,2)], [rgh; rgh], [mesh.np,1],@mean,NaN);
				%mesh.pval.rgh(fdx) = rgh_2d(fdx);
				fdx = isfinite(rgh_1d);
				mesh.pval.rgh(fdx) = rgh_1d(fdx);
				% mesh.width_1d(fdx(id)) = W;
			end
		else
			%mesh = [];
		end
	end % if ~ isempty(~C)
end % read_cross_section_geometry

