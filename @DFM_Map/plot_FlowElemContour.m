% Sat 14 Jan 16:09:28 CET 2017

function map_plot_FlowElemContour(obj,varargin)
% edges are identical to triangulation of NetElemNode
	x = obj.map.FlowElemContour_x;
	y = obj.map.FlowElemContour_y;

%	x = [x; x(1,:)];
%	y = [y; y(1,:)];

	x(end+1,:) = NaN;
	y(end+1,:) = NaN;
	
	plot(x(:),y(:),varargin{:});

%	plot(x,y,varargin{:});
%	patch(x,y,varargin{:})

%	L = map.NetLink;
%	X = map.NetNode_x;
%	Y = map.NetNode_y;
%
%	flag = ishold();
%	plot(X(L),Y(L),'k-');
%	hold on
%	L = L(:,map.BndLink);
%	plot(X(L),Y(L),'r-');
%	plot(map.NetLink_xu,map.NetLink_yu,'.');
%
%
%	if (~flag)
%		hold off
%	end
end

