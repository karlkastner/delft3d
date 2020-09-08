% Fri 20 Dec 12:10:02 +08 2019
function obj = export_bnd(obj,file_str)
	bnd = obj.bnd;
	fid = fopen(file_str,'w');
	if (fid < 1)
		error('here');
	end
	for idx=1:length(bnd)
		fprintf(fid,'%-20s %1s %1s %5d %5d %5d %5d %1.7e %s\n', ...
			bnd(idx).name, ...
			bnd(idx).type, ...
			'T', ...
			bnd(idx).left(1:2), ...
			bnd(idx).right(1:2), ...
			0.0, ...
			'Uniform');
	end
	fclose(fid);
end % export_bn

