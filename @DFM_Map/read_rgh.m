% Thu 15 Jun 11:20:06 CEST 2017
function obj = read_rgh(obj,filename)
	x       = obj.map.FlowElem_xcc;
	y       = obj.map.FlowElem_ycc;
	xyz     = load(filename);
	[id d]  = knnsearch(xyz(:,1:2), [x y]);
	obj.FlowElem_rgh = xyz(id,3);
	fprintf('max d: %d\n',max(d));
end

