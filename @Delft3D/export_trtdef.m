% Tue 17 Mar 17:51:31 +08 2020
function export_trtdef(obj,folder)
	what_    = what('Delft3D');
	
	fid = fopen([folder,filesep,obj.mdf.mdf.dat.Trtdef],'w');
	% 103 : van Rijn roughness predictor, does not use bedforms of bedform module
	% 106 : use roughness from bedform module
	fprintf(fid,'%d %d',[1,106]);
	fclose(fid);
end % export_trtdef

