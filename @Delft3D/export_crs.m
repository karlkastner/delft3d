% Fri 20 Dec 12:10:02 +08 2019
function export_crs(obj,file_str)
	crs = obj.crs;
	fid = fopen(file_str,'w');
	if (fid < 1)
		error('export_crs');
	end
	for idx=1:length(crs)
		fprintf(fid,'%-21s %5d %5d %5d %5d\n',crs(idx).name,crs(idx).left(1:2),crs(idx).right(1:2));
	end
	fclose(fid);
end

