% Tue 10 Mar 12:35:54 +08 2020
function write_all(obj)

	folder = obj.folder;

	% create output directory
	mkdir(folder);

	runid   = obj.runid;
	if (~isempty(obj.sed.dat.Sediment))
		% sed : sediment transport
		obj.sed.write([folder,filesep,runid,'.sed']);
		% sediment transport relation
		obj.export_tra(folder);
		% morphological factor file
		% note: has to come first, to set morfac filename in mor
		obj.export_morfac(folder,[runid,'.morfac']);
		% must come before inicomp mor!
		obj.export_inicomp(folder,[runid,'.inicomp']);
		% mor : morphodynamics
		obj.mor.write([folder,filesep,runid,'.mor']);
	else
		obj.mdf.mdf.dat.Filsed = '';
		obj.mdf.mdf.dat.Filmor = '';
	end
	% initial conditions
	obj.write_ini([folder,filesep,runid,'.ini']);
	% computational grid
	obj.mesh.export_delft3d_grd([folder,filesep,runid,'.grd']);
	% bed level
	obj.mesh.export_delft3d_dep([folder,filesep,runid,'.dep']);
	% roughness
	obj.mesh.export_delft3d_rgh([folder,filesep,runid,'.rgh'],obj.rgh);
	% thin dams
	obj.export_thin_dams([folder,filesep,runid,'.thd']);
	% boundary locations and types
	obj.export_bnd([folder,filesep,runid,'.bnd']);
	% boundary conditions as time series
	obj.export_bct([folder,filesep,filesep,runid,'.bct'],'w')
	% boundary conditions in harmonic form
	obj.write_bch([folder,filesep,runid,'.bch']);
	% boundary suspended conditions concentrations
	% dummy file, if equilibrium inflow is selected
	obj.export_bcc([folder,filesep,filesep,runid,'.bcc']);
	obj.export_bcc_sal([folder,filesep,filesep,runid,'.bcc']);
	% boundary conditions bed load transport
	obj.export_bcm([folder,filesep,filesep,runid,'.bcm']);
	% measurement cross sections
	obj.export_crs([folder,filesep,runid,'.crs']);
	% observation points
	obj.export_obs([folder,filesep,runid,'.obs']);

	% export trachotype file
	obj.export_trt([folder,filesep,runid]);

	% has to come last, as obs can be delted
	% mdf : model definition file
	obj.mdf.set('Runid',['#',obj.runid,'#']);
	obj.mdf.write_mdf([folder,filesep,runid,'.mdf']);

	obj.export_config_xml();

	% save this d3d matlab object
	save([folder,filesep,runid,'.mat'],'obj');

end % write all

