% 2020-03-17 15:54:12.933967393 +0800 delft3d_test_folder_name.m
function folder = folder_name(obj,base,param)
	field_C = fieldnames(param);

	folder = base;
	for idx=1:length(field_C)
		val = param.(field_C{idx});
		if (~isstr(val))
			val = num2str(val);
		end
		folder = [folder,'-',field_C{idx},'_',val];
	end
end % folder_name

