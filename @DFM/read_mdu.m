% Fri 16 Jun 14:20:29 CEST 2017
%
function obj = read_configuration(obj,mdufile_str)
	if (nargin()>1)
		path 	       = dirname(mdufile_str);
		obj.folder_str = path;
		obj.mdufile_str = basename(mdufile_str);
		%path = [obj.folder_str,filesep,obj.mdufile_str];
	else
		a    = what('@DFM');
		path = [a.path,filesep,'template'];
	end

	% read mdu
	path_ = [path,filesep,obj.mdufile_str];
	fprintf('Reading %s\n',path_);
	obj.mdu.read(path_);
	obj.mdu.read(path_);

	% read mor
	file_str = obj.mdu.get('sediment','MorFile');
	path_ = [path,filesep,file_str];
	fprintf('Reading %s\n',path_);
	obj.mor.read(path_);
		
	% read sed
	file_str = obj.mdu.get('sediment','SedFile');
	%path        = [obj.folder_str,filesep,sedfile_str];
	path_ = [path,filesep,file_str];
	fprintf('Reading %s\n',path_);
	obj.sed.read(path_);

	% read forcingfile

	file_str = obj.mdu.get('external forcing','ExtForceFile');
	%path        = [obj.folder_str,filesep,sedfile_str];
	path_ = [path,filesep,file_str];
	fprintf('Reading %s\n',path_);
	obj.extforce.read(path_);
end

