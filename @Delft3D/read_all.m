% Tue 10 Mar 12:35:54 +08 2020
function read_all(obj,folder)
	if (nargin<2)
		folder = obj.folder;
	end
	base= obj.base;
	obj.mdf.read_mdf([folder,filesep,base,'.mdf']);
	obj.mor.read([folder,filesep,base,'.mor']);
	obj.sed.read([folder,filesep,base,'.sed']);
	% TODO,bct,bnd,crs,obj,bcc,bct
end

