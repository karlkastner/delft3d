% Thu 15 Jun 11:32:19 CEST 2017
function [grain_size obj] = d50(obj,varargin)
	[id dis x y obj] = obj.nearest_FlowElem(varargin{:}); %x0,y0);
	grain_size = obj.FlowElem_grain_size(id,:);
end
    
