% Thu 15 Jun 11:21:26 CEST 2017
function obj = read_grain_size(obj,arg)
	if (isstr(arg))
		xyz = load(arg);
	else
		xyz = arg;
	end
	x       = obj.map.FlowElem_xcc;
	y       = obj.map.FlowElem_ycc;
	[id d]  = knnsearch(xyz(:,1:2), [x y]);
	obj.FlowElem_grain_size = xyz(id,3);
	fprintf('max d: %d\n',max(d));
end

