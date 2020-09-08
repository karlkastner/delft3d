% Sat 14 Jan 16:33:11 CET 2017
% Karl Kastner, Berlin
function [q dis x y obj] = discharge_1d(obj,varargin)
	% TODO interpolate to time if 3 arguments are given
	x0 = varargin{1};
	y0 = varargin{2};

	% TODO no magic numbers
	dmax = 500;
	[id dis] = obj.nearest_FlowLink(x0,y0);

	q = obj.map.q1(id,:);

	% correct the sign, the dfm direction is arbitrary
	% assign sign according to up and downstream distance of element centres
	if (length(varargin)>2)
		fl     = obj.map.FlowLink(:,id).';

		% somehow dfm refrences out of mesh links
		n = length(obj.map.FlowElem_xcc);
		fl     = min(fl,n);

		x0 = varargin{3};
		y0 = varargin{4};
		s0 = varargin{5};
		id1 = knnsearch([x0,y0],[obj.map.FlowElem_xcc(fl(:,1)),obj.map.FlowElem_ycc(fl(:,1))]);
		id2 = knnsearch([x0,y0],[obj.map.FlowElem_xcc(fl(:,2)),obj.map.FlowElem_ycc(fl(:,2))]);
		s1  = s0(id1);
		s2  = s0(id2);
		fdx = (s1 < s2);
		q(fdx,:) = -q(fdx,:);
	end
end % discharge_1d

