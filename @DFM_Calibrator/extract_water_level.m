% Wed  3 Aug 17:12:31 CEST 2016
% Karl Kastner, Berlin

% STATIC function
% TODO, this extracts depth, not level
function [out, mwl, unorm, mwlt, unormt] = extract_water_level(obj,hisname_C,blocksize)
	x0 = [obj.station.x];
	y0 = [obj.station.y];
	Su = [obj.station.Su];
	placename_C = {obj.station.name};

	if (nargin() < 3)
		% TODO no magic numbers
		blocksize = 1000;
	end
	
%	mwl    = 0;
	unorm2 = 0;
%	mwlt   = [];
%	unormt = [];
%	id     = [];
%	dis    = [];
	
	% for each map/his file file
        [time level dis x0_ y0_] = from_his(hisname_C,x0,y0);
        %[time level dis x y] = from_map(name_C,x0,y0);

	% distance of extracted stations
	fdx = find(dis>obj.dmax);
	if (length(fdx) > 0)
		for idx=rvec(fdx)
			fprintf(1,'Distance of station %s to matched vertex exeeds limit (%f)\n',placename_C{idx},dis(idx));
		end
	end
	
%	mwl   = mwl/length(time);
%	unorm = sqrt(unorm2/length(time));
	
	% sort
	[time, sdx] = unique(time);
	level = level(:,sdx);

	% transform time
	if (0 == obj.tref)
		fprintf('Warning: reference time is zero');
	end
	time     = obj.tref + time/86400;
	
	level    = level';
	
	out      = struct();
	out.time = time;
	for idx=1:length(x0)
		out(idx).level     = level(:,idx);
		out(idx).placename = placename_C{idx};
		out(idx).Su = Su(idx);
		out(idx).X = x0_(idx);
		out(idx).Y = y0_(idx);
		out(idx).dis = dis(idx);
        % check validity
        if (~all(isfinite(out(idx).level)))
                fprintf(1,'Warning Delft3DFM model out put is NaN at station %s\n',out(idx).placename);
        end
	end % for idx
end % extract_water_level

function [time level dis x y] = from_his(hisname_C,x0,y0)
	time = [];
	level = [];
	
	for idx=1:length(hisname_C)
		nc = nc_readall(hisname_C{idx});
		% get closest station
		[fdx dis] = knnsearch([cvec(nc.station_x_coordinate) cvec(nc.station_y_coordinate)],[cvec(x0) cvec(y0)]);	
		x    = cvec(nc.station_x_coordinate(fdx));
		y    = cvec(nc.station_y_coordinate(fdx));
		time = [time; cvec(nc.time)];
		level_   = nc.waterlevel(fdx,:);
		level = [level, level_];
	end
end

function [time level dis X Y] = from_map(mapname_C)
	time   = [];
	level  = [];
	for idx=1:length(mapname_C)
		% read blockwise (in case map file size exceeds memory)
		bdx = 1;
		while (true)
			% read file
			% TODO, this can even be made more efficient by loading only points of interest, not blocks in time
%			try
				level_ = [];
				% [map info] = nc_read_sequential(mapname_C{idx},'time',bdx,blocksize);
				%if (isempty(map))
				%	break;
				%end
				% level_ = map.waterdepth(id,:);
				% time = map.time
				% X = map.NetNode_x;
				% Y = map.NetNode_y;
				[time_ info] = nc_read_sequential(mapname_C{idx},'',1,inf,'time');
				time_ = time_.time;
				X = nc_read_sequential(mapname_C{idx},'',1,inf,'NetNode_x');
				X = X.NetNode_x;
				Y = nc_read_sequential(mapname_C{idx},'',1,inf,'NetNode_y');
				Y = Y.NetNode_y;
%			catch
%				error(['Could not read nc-file',mapname_C{idx}]);
%			end
			if (1 == idx && 1 == bdx)
				% get points closest to output points
				[id dis] = knnsearch([X,Y],[cvec(x0),cvec(y0)]);
				x0_ = X(id);
				y0_ = Y(id);
			else
				% TODO check that mesh ident to previous
			end
			try
				% extract reference date
				vdx   = find(strcmp({info.Variables.Name},'time'));
				adx   = find(strcmp({info.Variables(vdx).Attributes.Name},'units'));
				units = info.Variables(vdx).Attributes(adx).Value;
				tref  = datenum(units(15:end),'yyyy-mm-dd HH:MM:SS');
			catch
				error('Could not extract reference date');
			end
			for jdx=1:length(id)
				l = nc_read_sequential(mapname_C{idx},'nFlowElem',id(jdx),1,'waterdepth');
				[level_(jdx,:)] = l.waterdepth;
				%w = nc_read_sequential(mapname_C{idx},'nNetNode',1,inf,'waterdepth');
			end

			% extract time
			time = [time; cvec(time_)];
			% extract level
			%level = [level, map.waterlevel(id,:)];
			level  = [level, level_];
		%	mwl    = mwl   + sum(map.waterdepth,2);
		%	unorm2 = unorm2 + sum(map.unorm.^2,2);
	%		unorm2 = unorm2 + sum(map.ucx.^2 + map.ucy.^2,2);
	
	%		mwlt = [mwlt,mean(map.waterdepth)];
			%unormt = [unormt,rms(map.unorm)];
	%		unormt = [unormt,sqrt(sum(map.ucx.^2 + map.ucy.^2))];
			clear map;
			bdx = bdx+1;
			break
		end % while
	end % for idx
end % from_map


