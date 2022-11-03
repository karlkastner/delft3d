% Wed 13 Jan 15:39:59 +08 2021
function write_ddb(obj)

	ddb = obj.ddb;
	if (~isempty(ddb))

	%filename = [obj.folder, '/', obj.runid , '.ddb'];
	filename = [obj.folder, '/', obj.runid , '.ddb'];

	fid      = fopen(filename,'w');
	if (fid <= 0)
		error(['Unable to open file "', filename, '" for writing.\n']);
	end
	for idx=1:size(ddb,1)
		for jdx=1:2
			if (isnumeric(ddb(idx,jdx).runid))
				runid{jdx} = [obj.runid,sprintf('%02d',ddb(idx,jdx).runid),'.grd'];
			else
				runid{jdx} = ddb(idx,jdx).runid;
			end
		end % for jdx
	
		fprintf(fid,'%-8s %4d %4d %4d %4d %-8s %4d %4d %4d %4d\n' ...
			, runid{1}  ...
			, ddb(idx,1).ij  ...
			, runid{2}  ...
			, ddb(idx,2).ij ...
			);
	end % idx

	fclose(fid);

	end % ~ isempty(ddb)

	% TODO write an config.xml with the ddb!
end % write_ddb

