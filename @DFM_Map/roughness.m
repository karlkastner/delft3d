% Thu 15 Jun 11:31:16 CEST 2017
function [rgh obj] = roughness(obj,varargin)
	[id dis x y obj] = obj.nearest_FlowElem(varargin{:}); %x0,y0);
	rgh = obj.FlowElem_rgh(id);
end


