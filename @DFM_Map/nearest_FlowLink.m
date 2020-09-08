% Sat 14 Jan 16:26:14 CET 2017
% Karl Kastner, Berlin
function [id dis obj] = nearest_FlowLink(obj,x0,y0)
	x = cvec(obj.map.FlowLink_xu);
	y = cvec(obj.map.FlowLink_yu);
	[id dis] = knnsearch([x,y],[cvec(x0),cvec(y0)]);
end
	
