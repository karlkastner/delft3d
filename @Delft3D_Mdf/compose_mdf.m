% Thu 24 May 08:43:05 CEST 2018
function [d3d_A,obj] = compose_mdf(obj,name_C,folder)
	if (nargin() < 3)
		folder = '.';
	end
	for idx=1:length(name_C)
		% strip suffix
		base = regexprep(name_C{idx},'\..*','');
		% copy this object
		d3d_A(idx) = obj.copy();
		d3d_A(idx).mdf.dat.Filcco = [' #',base,'.grd#'];
		d3d_A(idx).mdf.dat.Filgrd = [' #',base,'.enc#'];
		smesh = SMesh();
		smesh.read_grd([folder,filesep,base,'.grd']);
		n = smesh.n();
		d3d_A(idx).mdf.dat.MNKmax = sprintf(' %d %d %d',[n(2)+1, n(1)+1, 1]);
		d3d_A(idx).write_mdf([folder,filesep,base,'.mdf']);
	end
end % compose_mdf

