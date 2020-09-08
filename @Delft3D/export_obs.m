% Fri 20 Dec 12:10:02 +08 2019
function export_obs(obj,file_str)
	obs = obj.obs;
	fid = fopen([file_str],'w');
	if (fid < 1)
		error('');
	end
	for idx=1:length(obs)
		fprintf(fid,'%-22s %6d %6d\n',obs(idx).name,obs(idx).nm(1:2));
	end
	fclose(fid);
end

