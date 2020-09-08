% Sat 10 Feb 15:52:48 CET 2018
function obj = write_mor(obj)
	a    = what('@DFM');
	path = [a.path];

	file_str = obj.mdu.get('sediment','SedFile');

	src  = [path,filesep,'template',filesep,file_str];
	dest = [obj.folder_str,filesep,file_str];

	copyfile(src,dest);
end

