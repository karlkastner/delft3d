% 2016-12-12 07:41:20.339808366 +0100

function obj = video(obj,arg1,dt_plot,dt_pause,filename)
%	if (nargin()<3)
%		% id=1
%		%id = length(obj.map.time);
%		id = size(arg1,2);
%	end

	mtime  = obj.mtime();
	T      = mtime(end)-mtime(1);

	if (nargin()<3)
		dt_plot = T/min(100,length(mtime)-1);
	end
	if (nargin()<4)
		dt_pause = 1;
	end
	if (nargin()<5)
		filename = [];
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
	
%	if (isnumeric(id))
%		val = val(:,id);
%	else
%		val = id(val);
%	end
	nt     = round(T/dt_plot);
	mtimei = (0:nt)'*(T/nt);
	vali   = interp1(rvec(mtime),val.',rvec(mtimei),'linear').';

	if (0)
		scatter3(x,y,val,[],val,'filled');
	else
		%patch(x,y,rvec(val),'edgecolor','none');
		clim = quantile(vali(:),[0.01,0.99]);
		%limits(vali(:))
		n = size(val,2);
		k = 0;
		for idx=1:nt+1
			cla();
			patch(x/1e3,y/1e3,ones(size(elem,1),1)*vali(:,idx).',vali(:,idx)','edgecolor','none');
			view(0,90);
			if (1==idx)
				%axis equal;
				%axis tight;
				axis square
				ax = axis;
			else
				axis(ax);
			end
			
			text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d years',round(mtimei(idx)/365.25),round(mtimei(end)/365.25)));
			%sprintf('%d/%d',idx,n));
			caxis(clim);
			h = colorbar();
			ylabel(h,'z_b (m)')
			xlabel('Eastimg (km)');
			ylabel('Northing (km)');
			drawnow();
			pause(dt_pause);
			if (~isempty(filename))
				print('-dpng',sprintf('%s-%03d.png',filename,k));
				k = k+1;
			end
		end
	end


	%scatter3(x,y,val(:,id),[],val(:,id),'filled');

% scatter3(a(:,1),a(:,2),a(:,3),[],a(:,3)), view(0,90); axis equal
end

