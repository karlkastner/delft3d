% Mon 23 Jan 10:10:21 CET 2017
% Karl Kastner, Berlin

% assign sign according to up and downstream distance of element centres
function [tau1 tau2 obj] = bed_shear_stress_1d(obj,varargin)
	% TODO interpolate to time if 3 arguments are given
	x0 = varargin{1};
	y0 = varargin{2};

	% TODO no magic numbers
	dmax = 500;
	% shear stresses are defined in element centres
	[id dis] = obj.nearest_FlowElem(x0,y0);

	% note unorm is not the "normed" but velocity normal to the cell interface
	% because in 1d there is only one direction in the element,
	% the velocity has only one component
	% tau = rho u_s|u_s|
	tau1  = obj.map.taus(id,:);

if (0)
	% index of element centres connected by the flow link
	fl     = obj.map.FlowLink(:,id).';
	% velocity at element centres
	ux     = 0.5*(obj.map.ucx(fl(:,1),:) + obj.map.ucx(fl(:,2),:));
	uy     = 0.5*(obj.map.ucy(fl(:,1),:) + obj.map.ucy(fl(:,2),:));
	% direction of the flow link
	dx     = diff(obj.map.FlowElem_xcc(fl),[],2);
	dy     = diff(obj.map.FlowElem_ycc(fl),[],2);
	h      = hypot(dx,dy);
	% normalised direction
	dx     =  dx./h;
	dy     =  dy./h;
	% velocity in direction of link
	u2     =   bsxfun(@times,ux,dx) ...
		 + bsxfun(@times,uy,dy);
end
end % velocity_1d

