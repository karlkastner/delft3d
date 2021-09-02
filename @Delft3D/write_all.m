% Tue 10 Mar 12:35:54 +08 2020
function write_all(obj)

	folder = obj.folder;
	base   = obj.base;
	if (~isempty(obj.sed.dat.Sediment))
		% sed : sediment transport
		obj.sed.write([folder,filesep,base,'.sed']);
		% sediment transport relation
		obj.export_tra(folder);
		% morphological factor file
		% note: has to come first, to set morfac filename in mor
		obj.export_morfac(folder,[base,'.morfac']);
		% must come before inicomp mor!
		obj.export_inicomp(folder,[base,'.inicomp']);
		% mor : morphodynamics
		obj.mor.write([folder,filesep,base,'.mor']);
	else
		obj.mdf.mdf.dat.Filsed = '';
		obj.mdf.mdf.dat.Filmor = '';
	end
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
	obj.export_bct([folder,filesep,filesep,base,'.bct'],'w')
	% boundary conditions in harmonic form
	obj.write_bch([folder,filesep,base,'.bch']);
	% boundary suspended conditions concentrations
	% dummy file, if equilibrium inflow is selected
	obj.export_bcc([folder,filesep,filesep,base,'.bcc']);
	obj.export_bcc_sal([folder,filesep,filesep,base,'.bcc']);
	% boundary conditions bed load transport
	obj.export_bcm([folder,filesep,filesep,base,'.bcm']);
	% measurement cross sections
	obj.export_crs([folder,filesep,base,'.crs']);
	% observation points
	obj.export_obs([folder,filesep,base,'.obs']);

	% export trachotype file
	obj.export_trt([folder,filesep,base]);
	

	% has to come last, as obs can be delted
	% mdf : model definition file
	obj.mdf.write_mdf([folder,filesep,base,'.mdf']);

	obj.export_config_xml();

	% save this d3d matlab object
	save([folder,filesep,base,'.mat'],'obj');
end % write all

