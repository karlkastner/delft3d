% Mon 28 Nov 16:53:08 CET 2016
function export_pli(shp,filename,name)
	fid = fopen(filename,'w');
	% name
	fprintf(fid,'%s\n',name);
	% nrow ncol
	fprintf(fid,'%d %d\n',[2 2]);
	% TODO for loop
	fprintf(fid,'%e %e %s\n',shp.X(1), shp.Y(1), [name,'_0001']);
	fprintf(fid,'%e %e %s\n',shp.X(2), shp.Y(2), [name,'_0002']);
	fclose(fid);
end % export_pli

