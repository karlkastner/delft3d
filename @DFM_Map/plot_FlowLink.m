% 2016-12-09 15:28:30.322984580 +0100

function map_plot_FlowLink(obj)
	Xc  = obj.map.FlowElem_xcc; % difference xzw??
	Yc  = obj.map.FlowElem_ycc;
	L   = obj.map.FlowLink;
	fdx = all(L<length(Xc),1);
	%true(size(L,1),1);
	n = sum(fdx);
%	plot([Xc(L(:,fdx))', NaN(n,1)],[Yc(L(:,fdx))', NaN(n,1)],'b-');
	plot(flat([Xc(L(:,fdx)); NaN(1,n)]),flat([Yc(L(:,fdx)); NaN(1,n)]),'b-');

%	Xc = Xc(L(:,fdx));
%	Yc = Yc(L(:,fdx));
%	X  = 0.5*sum(Xc,1);
%	Y  = 0.5*sum(Yc,1);
%	dir = [diff(Xc);
%	       diff(Xc)];
%	l   = hypot(dir(1,:),dir(2,:));
%	dir = bsxfun(@times,dir,1./l);
%	odir = [-dir(2,:); dir(1,:)];
%
%	hold on	
%	this is not width
%	W   = obj.map.FlowElem_xzw(L(:,fdx));
%	W   = 0.5*sum(W);
%	plot([X-odir(1,:).*W; X+odir(1,:).*W],[Y-odir(2,:).*W; Y+odir(2,:).*W],'k');
%	
%	-> get bnd edges
%	-> get bnd elements
%	-> get xy velocities in bnd elements
%	-> get flow velocities into the elements
%	-> project to 
end

