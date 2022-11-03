% Tue 10 Mar 12:35:54 +08 2020
function read_all(obj,folder)
	if (nargin<2)
		folder = obj.folder;
	end
	obj.mdf.read_mdf([folder,filesep,obj.runid,'.mdf']);
	obj.mor.read([folder,filesep,obj.runid,'.mor']);
	obj.sed.read([folder,filesep,obj.runid,'.sed']);
	% TODO,bct,bnd,crs,obj,bcc,bct
end

