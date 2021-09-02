% Fri 20 Dec 12:10:02 +08 2019
function obj = export_bnd(obj,file_str)
	bnd = obj.bnd;
	fid = fopen(file_str,'w');
	if (fid < 1)
		error('here');
	end
	% filetype = T for bct, H for harmonics
	for idx=1:length(bnd)
		switch (obj.bnd(idx).type)
		case {'Z'}
			s = '';
		case {'T'}
			s = 'Logarithmic';
		end

		fprintf(fid,'%-20s %1s %1s %5d %5d %5d %5d %1.7e %s\n', ...
			bnd(idx).name, ...
			bnd(idx).type, ...
			bnd(idx).filetype, ...
			bnd(idx).left(1:2), ...
			bnd(idx).right(1:2), ...
			0.0, ...
			s);
			%'Logarithmic');
			%'Uniform');
	end
	fclose(fid);
end % export_bn

