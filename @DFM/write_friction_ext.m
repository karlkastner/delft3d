% Thu  8 Feb 11:15:33 CET 2018
function obj = write_external_forcing(obj)
	a    = what('@DFM');
	path = [a.path];

	file_str = obj.mdu.get('external forcing','ExtForceFile');

	src  = [path,filesep,'template',filesep,file_str];
	dest = [obj.folder_str,filesep,file_str];

	copyfile(src,dest);
end

