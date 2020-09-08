% Wed 14 Feb 09:21:12 CET 2018
function [mtime, obj] = mtime(obj)
	time   = obj.time();
	if ( isfield(obj.map,'morfac') )
		morfac = obj.map.morfac;
	else
		morfac = 1;
		disp('coulr not read morfac');
	end
	mtime  = cumsum(morfac.*[0;diff(time)]);
end

