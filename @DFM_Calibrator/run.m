% Wed 10 Aug 15:28:19 CEST 2016
% Karl Kastner, Berlin
%
% valreach : n_reach x 1     : roughness value for each reach
function f      = run(obj,reachval,np)
	% generate output folder name
	outfolder = [obj.template_str,sprintf('_%1.2f',reachval)];
	%disp(['Starting model run in ', meta.file_s.base]);

	if (~exist(outfolder,'file'))
%	if (~obj.dryflag && ~exist(outfolder,'file'))
		% create output folder, as it does not yet exist
		fprintf(1,['Preparing Delft3d-FM model run in folder ', outfolder,'\n']);

		% copy default Delft3D-FM calibration
		copyfile(obj.template_str,outfolder);

		%reachpoly = obj.reachpoly;

if (0)
		C = num2cell(reachval);
		[reachpoly.Chezy] = C{obj.ub};
		% write roughness values
		% (for later reload, not required for this run)
  		% TODO in combination with bedlevel, index may be screwed

		Shp.write(reachpoly,[outfolder,filesep,'roughness.shp']);
end

		% set model time frame
		dfm = DFM();
		dfm.mdu.read([outfolder,filesep,obj.mdu_str]);
		dfm.TStart(obj.tstart); %obj.mdu.DStart);
		dfm.TStop(obj.tstop); %obj.mdu.DStop);
%		dfm.RestartFile(['FlowFM_',datestr(obj.tstart,'yyyymmdd'),'_000000_rst.nc']);
		%TStart   = 86400*(datenum(obj.mdu.DStart)-datenum(RefDate));
		%mdu.set('time','TStart',[num2str(TStart),' # ',obj.mdu.DStart]);
		%TStop    = 86400*(datenum(obj.mdu.DStop)-datenum(RefDate));
		%mdu.set('time','TStop',[num2str(TStop),' # ',obj.mdu.DStop]);

		mesh_str = dfm.NetFile;

		% load mesh
		mesh = UnstructuredMesh();
		mesh.import_delft3d([outfolder,filesep,mesh_str]);

		cval          = struct();
		cval.Chezy    = mesh.pval.rgh;
		cval.Bedlevel = mesh.point(:,3);

		% for each set of reaches
		for idx=1:length(obj.reachpoly_C)
		   % reach indices
		   rid = [obj.reachpoly_C{idx}.id];
		   % for each calibration parameter
		   for jdx=1:length(obj.parameter_C)
		       % indices into the value vector
		       vid = obj.id(rid,jdx);
		       % check if this parameter is to be calibrated for this set of reaches
		       if (isfield(obj.reachpoly_C{idx},obj.parameter_C{jdx}))
		           % set calibration values depending on the geometry
		           % TODO operator into files (+,=)
		           switch (lower(obj.reachpoly_C{idx}(1).Geometry))
		           case {'polygon'}
			       val = cval.(obj.parameter_C{jdx});
		               val = Geometry.poly_set(obj.reachpoly_C{idx},reachval(vid),mesh.X,mesh.Y,val);
		               %val = polygonset(obj.reachpoly_C{idx},reachval(obj.id(idx).(obj.parameter_C{jdx})),mesh.X,mesh.Y);
		               cval.(obj.parameter_C{jdx}) = val;
		   
		               % TODO parameters should be set in a loop, not necessary to have explicit commands for 
		               % determine roughness
		               %if (isfield(reachpoly_C{idx},'Chezy'))
		               %    rgh = polygonset(reachpoly_C{idx},reachval(obj.id.Chezy),mesh.X,mesh.Y);
		               %end
		   
		               % determine bed-level offset
		               %if (isfield(reachpoly_C{idx},'Bedlevel'))
		               %~isempty(obj.id.bedlevel))
		               %    zoffset   = polygonset(reachpoly_C{idx},reachval(obj.id.bedlevel),mesh.X,mesh.Y);
		               %else
		               %    zoffset = 0;
		               %end
		           case {'point'}
		               % TODO, distinguish 1d and 2d
		               if (1)
		                   %if (isfield(reachpoly_C{idx},'Chezy'))
		                   x0 = cvec([obj.reachpoly_C{idx}.X]);
		                   y0 = cvec([obj.reachpoly_C{idx}.Y]);
		                   %v0 = cvec([reachpoly_C{idx}.(obj.parameter_C{jdx})]);
		                   v0 = reachval(vid); %obj.id(idx).(obj.parameter_C{jdx}));
		                   [val_1d fdx] = mesh.interp_1d(x0,y0,v0);
		                   %rgh = NaN(mesh.np,1)';
		                   %rgh(fdx) = rgh_1d;
		                   cval.(obj.parameter_C{jdx})(fdx) = val_1d;
		                   %rgh(fdx) = rgh_1d;
		                   %end
		               else
		                   % TODO, this are not any more a "reach" values, but point values
		                   X = [reachpoly.X];
		                   Y = [reachpoly.Y];
		       
		                   % determine roughness
		                   C = reachval(obj.id.Chezy);
		                   rgh = mesh.interpolate_point(X,Y,C(obj.ub));
		       
		                   % points can be references at multiple locations to create quasi polygons
		                   if (~isempty(obj.id.bedlevel))
		                               C = reachval(obj.id.bedlevel);
		                       zoffset   = mesh.interpolate_point(X,Y,C(obj.ub));
		                   else
		                       zoffset = 0;
		                   end
		               end
		           otherwise
		               error('unimplement geometry')
		           end % switch
		       end % if isfield
		   end % for jdx
		end % for idx
		% output the roughness file
		% TODO this should be part of UnstructuredMesh
		% write_xyz([outfolder,'/',obj.roughness_str],mesh.X,mesh.Y,rgh);
		mesh.pval.rgh = cval.Chezy;

		% add bed level offset
		mesh.point(:,3) = cval.Bedlevel;
		%mesh.point(:,3) + zoffset;

		% update the MDU file
		dfm.mdu.write();

		% write mesh with calibration bed level and roughness
		mesh.export_delft3d([outfolder,filesep,mesh_str]);
	else
		dfm = DFM();
		% TODO tref should be loaded from his / map
		dfm.mdu.read([outfolder,filesep,obj.mdu_str]);
		obj.tref = dfm.RefDate();
		%datenum(RefDate);
		% load the reference date
		%RefDate  = mdu.get('time','RefDate');
		%RefDate  = [RefDate(1:4),'/',RefDate(5:6),'/',RefDate(7:8)];
	end % if output folder does not yet exist

	% run model, if it was not yet run
	if (isempty(obj.getstate(outfolder)))
	if(obj.dryflag)
		fprintf(1,'Not starting model as dryflag is set\n');
	else
		obj.np = obj.np+1;
		% avoid that too many models are running in parallel
		if (obj.np > obj.npmax && obj.npmax > 1)
			nw = min(1,obj.np-obj.npmax);
			while (~strcmp(obj.getstate(obj.process_C{nw}),'completed'))
				fprintf('Waiting for %s before starting next model\n',obj.process_C{nw});
				% wait
				pause(obj.twait);
			end % while 1
		end
		% append folder of current run to list 
		obj.process_C{obj.np} = outfolder;

	% TODO, this is a duplicate check
	% TODO this is problematic, if the model run was interrupted and is not yet complete
%	file_a = dir([outfolder,filesep,'DFM_OUTPUT_FlowFM',filesep,'FlowFM*map*.nc']);
%	if (~isempty(file_a))
%		% TODO
%		fprintf(1,'Not starting model as output files exist');
%	else
		% run Delft3D-FM
		%command = [outfolder,filesep,'run.sh ',num2str(np)];
		if (~isunix())
%			if (~exist(bash,'file'))
%				error('Cygwin is not installed');
%			end
			command = ['PATH=',obj.cygpath,';%PATH%; && bash.exe run.sh ', outfolder, ' ', num2str(np),' && exit &'];
			%command = ['cd ',outfolder,' && PATH=C:\\cygwin64\\bin;%PATH%; && ', bash, ' run.sh ',num2str(np)];
		else
			command = ['LD_LIBRARY_PATH= dfm ' num2str(np) ' &'];
			%command = ['LD_LIBRARY_PATH= dfm &'];
		end
		printf(['Running model: ', command,'\n']);
		oldpwd = pwd();
		cd(outfolder);
		system(command);
		cd(oldpwd);
%	end % else of ~isempty file_a
	end % else of dryflag
	end % if istempty(getstate)
	
	f = NaN;
	% save the model state
	save([outfolder,filesep,'dfm-calibrator.mat']);
end % Delft3dfm::run

function flag = test_model(model)
	flag = true;
	if (isfield(model,'time'))
		t = model.time;
	else
		return;
	end
	% check for completeness
	if (length(t)<2 || (length(t)-1)*(t(2)-t(1)) ~= (t(end)-t(1)))
		return;
		%disp([length(t), (t(end)-t(1))/(t(2)-t(1))]);
%		warning('Incomplete model output data');
%		f = NaN;
%		return;
	end
	flag = false;
end

