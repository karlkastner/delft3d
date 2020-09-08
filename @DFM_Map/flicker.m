% 2016-12-12 07:41:20.339808366 +0100

function obj = plot(obj,arg1,dt)
%	if (nargin()<3)
%		% id=1
%		%id = length(obj.map.time);
%		id = size(arg1,2);
%	end
	if (nargin()<3)
		dt = 0.5;
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

	switch (n)
	case {obj.nedge()}
		x = obj.edge_x();
		y = obj.edge_y();
	case {obj.nelem()}
	%	x = obj.elem_x_centre();
	%	y = obj.elem_y_centre();
		elem = obj.map.mesh2d_face_nodes;
		x    = obj.map.mesh2d_node_x(elem);
		y    = obj.map.mesh2d_node_y(elem);
%		x = obj.elem_x();
%		y = obj.elem_y();
	otherwise
		error(['number of rows in val must correspond', ...
		       ' to number of elements or edges']);
	end % switch
	
%	if (isnumeric(id))
%		val = val(:,id);
%	else
%		val = id(val);
%	end
	if (0)
		scatter3(x,y,val,[],val,'filled');
	else
		%patch(x,y,rvec(val),'edgecolor','none');
		clim = limits(val(:));
		n = size(val,2);
		flag = true;
		while (1)
%		for idx=1:size(val,2)
			cla();
			patch(x,y,ones(3,1)*val(:,1).',val(:,1)','edgecolor','none');
			view(0,90);
			caxis(clim);
			drawnow
			pause(dt);

			if (flag)
				axis equal;
				ax = axis;
				flag = false;
			else
				axis(ax);
			end

			cla();
			patch(x,y,ones(3,1)*val(:,end).',val(:,end)','edgecolor','none');
			view(0,90);
			caxis(clim);
			axis(ax);
			drawnow
			pause(dt);
%			text(ax(1)+0.9*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d',idx,n));
		end
	end
	

	%scatter3(x,y,val(:,id),[],val(:,id),'filled');

% scatter3(a(:,1),a(:,2),a(:,3),[],a(:,3)), view(0,90); axis equal
end

