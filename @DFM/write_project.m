% Fri 16 Jun 14:22:46 CEST 2017
% Thu  8 Feb 10:42:59 CET 2018
function obj = write_project(obj)

	obj.write_initial_water_level();

	%obj.write_friction_ext();
	% friction.ext

	file_str = obj.mdu.get('external forcing','ExtForceFile');
	obj.extforce.file_str = [obj.folder_str,filesep,file_str];
	obj.extforce.write();

	% export_bc(folder,base,s,t0,dt)
	% obj.write_bc();
		% bc
		% pli 
		% FlowFM_bnd.ext                                                  
	
	% TODO write_crs, CrsFile	FlowFM_crs.pli
	% TODO write_obs, ObsFile	FlowFM_obs.xyn
	% TODO output files and intervals

	morfile_str = obj.mdu.get('sediment','MorFile');
	obj.mor.file_str = [obj.folder_str,filesep,morfile_str];
	obj.mor.write();

	sedfile_str = obj.mdu.get('sediment','SedFile');
	obj.sed.file_str = [obj.folder_str,filesep,sedfile_str];
	obj.sed.write();

	%src  = [path,filesep,'template',filesep,file_str];
	%dest = [obj.folder_str,filesep,file_str];

	% FlowFM.mdu
	obj.mdu.file_str = [obj.folder_str,filesep,obj.mdufile_str];
	obj.mdu.write();
end


