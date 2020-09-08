% Wed 14 Feb 09:21:51 CET 2018
function [time,obj] = time(obj)
	time = obj.map.time / 86400;
end

