% Mon 16 Jan 12:22:15 CET 2017
% Karl Kastner, Berlin

% TODO interpolate linearly, not constant

function [zs zb d id obj] = waterlevel(obj,varargin)
	% TODO interpolate to time if 3 arguments are given
	if (length(varargin) > 0)
	x0 = varargin{1};
	y0 = varargin{2};

	[id dis] = obj.nearest_FlowElem(x0,y0);
	else
		id = true(size(obj.map.FlowElem_zcc));
	end

	zb = -obj.map.FlowElem_zcc(id);
%figure()
	d  =  obj.map.waterdepth(id,:);
	
	zs = bsxfun(@plus,d,zb);
%	plot([zb mean(zs')'])
%pause

	%[fdx dis] = knnsearch([Xi Yi],[nc.FlowElem_xcc,nc.FlowElem_ycc]);
%	[fdx dis] = knnsearch([nc(idx).FlowElem_xcc,nc(idx).FlowElem_ycc],[Xi Yi]);
%	zb(:,idx) = -nc(idx).FlowElem_zcc(fdx);	
%	h_mean(:,idx) = mean(h,2);
%	h_ = bsxfun(@minus,h,h_mean(:,idx));
%	h_rms(:,idx)  = rms(h_,2);

end % waterlevel

