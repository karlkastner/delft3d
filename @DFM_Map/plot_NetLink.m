% 2016-12-09 15:01:36.812539858 +0100

function map_plot_NetLink(obj)
% edges are identical to triangulation of NetElemNode
	L = obj.map.NetLink;
	X = obj.map.NetNode_x;
	Y = obj.map.NetNode_y;

	flag = ishold();
	plot(X(L),Y(L),'k-');
	hold on
	L = L(:,obj.map.BndLink);
	plot(X(L),Y(L),'r-');
	plot(obj.map.NetLink_xu,obj.map.NetLink_yu,'.');

	if (~flag)
		hold off
	end
end

