% Tue 10 Mar 12:35:54 +08 2020
function write_all(obj)
	folder = obj.folder;
	base   = obj.base;
	% mdf : model definition file
	obj.mdf.write_mdf([folder,filesep,base,'.mdf']);
	% sed : sediment transport
	obj.sed.write([folder,filesep,base,'.sed']);
	% sediment transport relation
	obj.export_tra(folder);
	% mor : morphodynamics
	obj.mor.write([folder,filesep,base,'.mor']);
	% initial conditions
	obj.write_ini([folder,filesep,base,'.ini']);
	% computational grid
	obj.mesh.export_delft3d_grd([folder,filesep,base,'.grd']);
	% bed level
	obj.mesh.export_delft3d_dep([folder,filesep,base,'.dep']);
	% thin dams
	obj.export_thin_dams([folder,filesep,base,'.thd']);
	% boundary locations and types
	obj.export_bnd([folder,filesep,base,'.bnd']);
	% boundary conditions as time series
	obj.export_bct([folder,filesep,filesep,base,'.bct'])
	% boundary conditions in harmonic form
	obj.write_bch([folder,filesep,base,'.bch']);
	% boundary conditions concentrations
	% dummy file, if equilibrium inflow is selected
	obj.export_bcc([folder,filesep,filesep,base,'.bcc']);
	% measurement cross sections
	obj.export_crs([folder,filesep,base,'.crs']);
	% observation points
	obj.export_obs([folder,filesep,base,'.obs']);

	% export trachotype file
	obj.export_trt([folder,filesep,base]);

	% TODO take from template, or put template folder
	w = what(class(obj));
	copyfile([w.path,'/delft3d.xml'],obj.folder);
end % write all

