% 2016-12-09 13:27:23.299866539 +0100

function map_plot_NetElemLink(obj)
	Xc = obj.map.NetLink_xu;
	Yc = obj.map.NetLink_yu;

%^	Xc =obj.map.FlowElem_xcc;
%	Yc=obj.map.FlowElem_ycc;
	L=obj.map.NetElemLink';
	%fdx = true(size(L,1),1);
	fdx = all(L > 0,2);
	plot([Xc(L(fdx,:)) NaN(sum(fdx),1)]',[Yc(L(fdx,:)) NaN(sum(fdx),1)]','-');
end
