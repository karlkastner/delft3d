% Sat 14 Jan 16:37:09 CET 2017
% Karl Kastner, Berlin

function [u1 u2 Dm obj] = velocity_1d(obj,varargin)
	% TODO interpolate to time if 3 arguments are given
	if (length(varargin)>0)
		x0 = varargin{1};
		y0 = varargin{2};

		% TODO no magic numbers
		dmax = 500;
		[id dis] = obj.nearest_FlowLink(x0,y0);
	else
		id = 1:size(obj.map.FlowLink,2);
	end

	% note unorm is not the "normed" but velocity normal to the cell interface
	% because in 1d there is only one direction in the element,
	% the velocity has only one component
	u1     = obj.map.unorm(id,:);
	fl     = obj.map.FlowLink(:,id).';
	% somehow dfm refrences out of mesh links
	n = length(obj.map.FlowElem_xcc);
	fl     = min(fl,n);

	if (nargout() > 1)
		% index of element centres connected by the flow link
		Dm     = 0.5*(obj.map.waterdepth(fl(:,1),:) + obj.map.waterdepth(fl(:,2),:));
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

	% correct the sign, the dfm direction is arbitrary
	% assign sign according to up and downstream distance of element centres
	if (length(varargin)>2)
		x0 = varargin{3};
		y0 = varargin{4};
		s0 = varargin{5};
		id1 = knnsearch([x0,y0],[obj.map.FlowElem_xcc(fl(:,1)),obj.map.FlowElem_ycc(fl(:,1))]);
		id2 = knnsearch([x0,y0],[obj.map.FlowElem_xcc(fl(:,2)),obj.map.FlowElem_ycc(fl(:,2))]);
		s1  = s0(id1);
		s2  = s0(id2);
		fdx = (s1 < s2);
		u1(fdx,:) = -u1(fdx,:);
	if (nargout() > 1)
		u2(fdx,:) = -u2(fdx,:);
	end
	end
end % velocity_1d

