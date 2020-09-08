% Fri 27 Jan 12:45:46 CET 2017

function [E Et] = energy_transport_1d(obj,varargin)
	u = obj.velocity_1d(varargin{:});
	q = obj.discharge_1d(varargin{:});
	[zs void2 h] = obj.waterlevel(varargin{:});

	t = obj.map.time/86400;
	[E Et] = energy_transport_1d(t,h,q,u,zs);
end

