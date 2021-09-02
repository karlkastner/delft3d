% Tue 10 Mar 15:36:58 +08 2020
function export_tra(obj,folder)
	what_    = what('Delft3D');
%	srcdir   = what_.path;
%	copyfile([what_.path,'/vr1984.tra'],folder);
	TraFrm = obj.mdf.mdf.dat.TraFrm;
	TraFrm = strtrim(TraFrm); 
	switch (TraFrm)
	case {'#eh.tra#'}
		fid = fopen([folder,filesep,'eh.tra'],'w');
		fprintf(fid,'1          IFORM\n');
		fprintf(fid,'* --------------\n\n');
		fprintf(fid,'#1         Engelund Hansen, do not remove this line!\n');
		fprintf(fid,'1.0    	alpha calibration parameter, scales transport\n');
		fprintf(fid,'0          RKSC Bottom roughness height, only used when flow roughness parameter undefined\n');
		fprintf(fid,'1.0    	fraction of suspended transport (for how it is written)\n');
		fclose(fid);
	case {'#vr1984.tra#'}
		fid = fopen([folder,filesep,'vr1984.tra'],'w');
		fprintf(fid,'7         IFORM\n');
		fprintf(fid,'* --------------\n');
		fprintf(fid,'#7     van rijn 1984, do not remove this line!\n');
		fprintf(fid,'1.0    ACal calibration factor for reference concentration\n');
		fprintf(fid,'0      dummy argument, for backwards compatibility\n');
		fprintf(fid,'%f     Aks : reference level (default), c.f. sec mor calib factors\n',obj.reference_level);
		fprintf(fid,'0      WSettle\n');
		fprintf(fid,'0      BetaM\n');
		fclose(fid);
	case {'#vr1993.tra#','#vr1993#'}
		fid = fopen([folder,filesep,'vr1993.tra'],'w');
		fprintf(fid,'-1        IFORM\n');
		fclose(fid);
	case {'#vr2007.tra#'}
		warning(['not yet implemented ',obj.mdf.mdf.dat.TraFrm]);
	otherwise
		error(['here ',obj.mdf.mdf.dat.TraFrm]);
	end
end % export_tra

