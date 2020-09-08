% Thu 20 Oct 16:03:48 CEST 2016
% Karl Kastner, Berlin
function export_his(shp,oname)
	if (nargin() < 2)
		oname = 'FlowFM_obs.xyn';
	end
	if (isstr(shp))
		shp = Shp.read(shp);
	end
	fid = fopen(oname,'w');
	if (-1 == fid)
		error('Cannot open file for writing');
	end
	for idx=1:length(shp)
		%fprintf(fid,'        %16f         %16f ''%s''\n', double(shp(idx).X),double(shp(idx).Y),shp(idx).placename);
		%fprintf(fid,'        %5f         %5f ''%s''\n', double(shp(idx).X),double(shp(idx).Y),shp(idx).placename);
		fprintf(fid,'%24.9f %24.9f ''%s''\n', shp(idx).X,shp(idx).Y,shp(idx).placename);
		%fprintf(fid,'%16.8f %16.8f ''%s''\n', shp(idx).X,shp(idx).Y,shp(idx).placename);
	end
	fclose(fid);
end

