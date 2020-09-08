% 2016-12-12 07:41:20.339808366 +0100

function obj = plot(obj,arg1,id)
	if (nargin()<3)
		% id=1
		%id = length(obj.map.time);
		id = size(arg1,2);
	end
	if (isnumeric(arg1))
		val = arg1;
	else
		field = arg1;
		switch (field)
		case {'id'}
			val = (1:(length(obj.map.FlowElem_xcc)))';
		case {'z'}
			val = obj.map.FlowElem_zcc;
		case ('umag')
			val = sqrt(obj.map.ucx.^2+obj.map.ucy.^2);
		otherwise
			val = obj.map.(field);
		end
	end

	n = size(val,1);

	flag = false;
	switch (n)
	case {obj.nvertex}
		x = obj.map.mesh2d_node_x;
		y = obj.map.mesh2d_node_y;
		flag = true;
	case {obj.nedge()}
		x = obj.edge_x();
		y = obj.edge_y();
	case {obj.nelem()}
	%	x = obj.elem_x_centre();
	%	y = obj.elem_y_centre();
		if (isfield(obj.map,'NetElemNode'))
			elem = obj.map.NetElemNode;
			x    = obj.map.NetNode_x(elem);
			y    = obj.map.NetNode_y(elem);
		else
			elem = obj.map.mesh2d_face_nodes;
			x    = obj.map.mesh2d_node_x(elem);
			y    = obj.map.mesh2d_node_y(elem);
		end

%		x = obj.elem_x();
%		y = obj.elem_y();
	otherwise
		error(['number of rows in val must correspond', ...
		       ' to number of elements or edges']);
	end % switch
	
	if (isnumeric(id))
		val = val(:,id);
	else
		val = id(val);
	end
	if (flag)
		scatter3(x,y,val,[],val,'filled');
	else
		%patch(x,y,rvec(val),'edgecolor','none');
		patch(x,y,ones(size(elem,1),1)*rvec(val),rvec(val),'edgecolor','none');
	end
	

	%scatter3(x,y,val(:,id),[],val(:,id),'filled');
	view(0,90);
	axis equal;
% scatter3(a(:,1),a(:,2),a(:,3),[],a(:,3)), view(0,90); axis equal
end

