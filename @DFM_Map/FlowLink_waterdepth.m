% Sat 17 Jun 14:17:43 CEST 2017
function [d obj] = FlowLink_waterdepth(obj)
	 d   = obj.map.waterdepth;
	 n   = size(d,1);
	 fl  = obj.map.FlowLink';
	 fdx = fl > n;
	 fl(fdx) = 1;
	 d   = 0.5*(d(fl(:,1),:) + d(fl(:,2),:));
	 d(any(fdx,2),:) = NaN;
end

