% Sat 17 Jun 13:13:02 CEST 2017
function [w obj] = FlowLink_width(obj)
	if (isempty(obj.FlowLink_width_))
	if (1)
		% quick fix
		w = obj.map.q1./(obj.map.unorm.*obj.FlowLink_waterdepth);
		w = nanmedian(w,2)
	else
		% TODO this code can mismatch edges if elements are long and narrow
		% and overestimate hence the width of narrow channels

		% flow link mid-coordinates
		xu = cvec(obj.map.FlowLink_xu);
		yu = cvec(obj.map.FlowLink_yu);

		% flow elemen conotour coordinates
		xc = obj.map.FlowElemContour_x';
		yc = obj.map.FlowElemContour_y';

		% contour edge centres
		% TODO this may not get the last edge
		xe = 0.5*(xc(:,1:end-1)+xc(:,2:end));
		ye = 0.5*(yc(:,1:end-1)+yc(:,2:end));
		xe(:,end+1) = NaN;
		ye(:,end+1) = NaN;
		n = size(xc,1);
		id = (1:prod(size(xc)));
		% stack
		xe = xe(:);
		ye = ye(:);
	%	plot(xe,ye,'.')
	
		% nearest edge centre of each FlowLink
		id_ = knnsearch([xe ye],[xu,yu]);

		% reverse index
		id=cvec(id(id_));

%		plot([xc(id) xu xc(id+n)]', [yc(id) yu yc(id+n)]')
	
		% edge length
		w = Geometry.distance([xc(id) yc(id)],[xc(id+n),yc(id+n)]);
		obj.FlowLink_width_ = w;

		scatter3(xu,yu,w,[],w);
	
	%	plot([xu,xe(id)]',[yu ye(id)]','.-');
	else
		w = obj.FlowLink_width_;
	end
end

