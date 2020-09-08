% Sat 14 Jan 16:26:14 CET 2017
% Karl Kastner, Berlin
function [id dis x y obj] = nearest_FlowElem(obj,x0,y0)
	x = cvec(obj.map.FlowElem_xcc);
	y = cvec(obj.map.FlowElem_ycc);
	[id dis] = knnsearch([x,y],[cvec(x0),cvec(y0)]);
	if (nargout() > 2)
		x = x(id);
		y = y(id);
	end
end

