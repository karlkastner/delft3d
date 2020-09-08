% Sat 14 Jan 16:09:28 CET 2017

function obj = plot_NetLinkContour(obj)
% edges are identical to triangulation of NetElemNode
	x = obj.map.NetLinkContour_x;
	y = obj.map.NetLinkContour_y;

	x = [x; x(1,:)];
	y = [y; y(1,:)];

	plot(x,y);

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

