% Thu  3 Jun 20:44:10 CEST 2021
function export_inicomp(obj,folder,icname)
	if (~isempty(obj.inicomp))
		layer = obj.inicomp;
		fid = fopen([folder,filesep,icname],'w');

		% TODO use set to section
		s=struct();
		s.IniComp = icname;
		s.IUnderLyr = '2';
		obj.mor.set(s);
		%	obj.mor.set('IniComp',icname); %,'Underlayer');
		%obj.mor.set('IUnderLyr','2'); %,'Underlayer');
	
		fprintf(fid,'[BedCompositionFileInformation]\n');
		fprintf(fid,'FileCreationDate =\n');
		fprintf(fid,'FileVersion = 01.00\n');
		for idx=1:length(layer)
			fprintf(fid,'[Layer]\n');
			if (isfield(layer{idx},'thick') && ~isempty(layer{idx}.thick))
				error('not yet implemented');
				% [Layer] 
				% Type = mass fraction
				% Thick = layer1.thk
				% Fraction1 = 0.3
				% Fraction2 = 0.7
			elseif(isfield(layer{idx},'SedBed') && ~isempty(layer{idx}.SedBed))
				fprintf(fid,'Type = sediment mass\n');
				SedBed = obj.inicomp{idx}.SedBed(obj.mesh.X,obj.mesh.Y);
				for jdx=1:size(SedBed,3)
					filename = ['layer',num2str(idx),'fraction',num2str(jdx),'.sdb'];
					%obj.export_sdb(filename,layer(idx).SedBed(:,idx));
					obj.mesh.export_delft3d_sdb([folder,filesep,filename],SedBed(:,:,jdx));
					fprintf(fid,['SedBed',num2str(jdx),' = ',filename,'\n']);
				end % for jdx
			else
				error('here');
			end % if
		end % for idx
	end % ~isempty(inicomp)
end % export_inicomp

