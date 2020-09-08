% 2018-11-15 14:42:11.349158068 +0100
% TODO, this conflicts with vel_sn2xy
function [u_, v_] = to_earth(obj,u,v)
	%xcor = obj.X; % vs_get(obj.map,'map-const','XCOR');
	%ycor = obj.Y; %vs_get(obj.map,'map-const','YCOR');
	%x    = xcor(1:end-1,1:end-1);
	%y    = ycor(1:end-1,1:end-1);
	
	x = obj.X;
	y = obj.Y;


	switch (ndims(u))
	case {2}
		v = squeeze(v(1:end-1,2:end-1));
		u = squeeze(u(2:end-1,2:end-2));
	case {3}
		v = squeeze(v(1:end-1,2:end-1,:));
		u = squeeze(u(2:end-1,2:end-2,:));
	end

	dx = -diff(mid(x,1),[],2);
	dy = -diff(mid(y,1),[],2);
	% normalize
	ds = hypot(dx,dy);
	dx = dx./ds;
	dy = dy./ds;

	u_ = -u.*mid(dx,2) + mid(mid(v,1).*dy,2);
	v_ = -u.*mid(dy,2) - mid(mid(v,1).*dx,2);
end

