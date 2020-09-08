% Sat 10 Feb 15:52:48 CET 2018
function obj = write_mor(obj)
	a    = what('@DFM');
	path = [a.path];

	morfile_str = obj.mdu.get('sediment','MorFile');

	src  = [path,filesep,'template',filesep,morfile_str];
	dest = [obj.folder_str,filesep,morfile_str];

	copyfile(src,dest);
end

