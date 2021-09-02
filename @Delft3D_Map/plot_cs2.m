% Wed 24 Feb 16:30:32 CET 2021
function plot_cs2(obj, tdx, kt, ks, val)

	zs    = obj.zs(tdx);
	depth = obj.depth(tdx);
	z     = zs(:,2:end-1,ks) - shiftdim(1-obj.sigma,-3).*squeeze(depth(:,2:end-1,ks));

	if (isvector(kt))
		if (~isempty(val))
		val = mean(val(kt,:,ks,:),1);
		end
		z   = mean(z(kt,:,:,:),1);
		zs  = mean(zs(kt,:,:),1);
	else
		if (~isempty(val))
		val = val(kt,:,ks,:);
		end
		z   = z(kt,:,:,:);
		zs  = zs(kt,:,:);
	end
	z  = squeeze(z)';
	zs = squeeze(zs);

	S       = obj.smesh.S;
	x       = mid(rvec(S(1:end,ks)));
	x       = x-0.5*(S(1,ks)+S(end,ks));
	x       = repmat(x,size(z,1),1);
	xi      = inner2outer(inner2outer(x,1),2);
	zi      = inner2outer(inner2outer(z,1),2);
	zi(1,:) = inner2outer(rvec(zs(2:end-1,ks)));

	if (~isempty(val))
	val = squeeze(val)';
	val = inner2outer(inner2outer(val,1),2);
	surface(xi,zi,val,'edgecolor','none');
	else
	surface(xi,zi,zeros(size(zi)),'facecolor','none'); %'edgecolor','none');
	end
end

