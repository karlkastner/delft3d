% 2016-12-12 07:41:20.339808366 +0100

function obj = video(obj,arg1,dt_plot,dt_pause,filename,clim)
%	if (nargin()<3)
%		% id=1
%		%id = length(obj.map.time);
%		id = size(arg1,2);
%	end

	mtime  = obj.tmor();
	if (mtime(end) == mtime(1))
		mtime = obj.time();
	end
	T      = mtime(end)-mtime(1);

	if (nargin()<3 || isempty(dt_plot))
		dt_plot = []; % T/min(100,length(mtime)-1);
	end
	if (nargin()<4 || isempty(dt_pause))
		dt_pause = 1;
	end
	if (nargin()<5)
		filename = ['video-',datestr(now,'yyyy-mm-dd-HH-MM-SS'),'.gif'];
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
	if (nargin()<6)
		clim = [];
	end

	n = size(val,1);

%	switch (n)
%	case {obj.nedge()}
%		x = obj.edge_x();
%		y = obj.edge_y();
%	case {obj.nelem()}
%	%	x = obj.elem_x_centre();
%	%	y = obj.elem_y_centre();
%		if (isfield(obj.map,'NetElemNode'))
%			elem = obj.map.NetElemNode;
%			x    = obj.map.NetNode_x(elem);
%			y    = obj.map.NetNode_y(elem);
%		else
%		elem = obj.map.mesh2d_face_nodes;
%		x    = obj.map.mesh2d_node_x(elem);
%		y    = obj.map.mesh2d_node_y(elem);
%		end
%
%%		x = obj.elem_x();
%%		y = obj.elem_y();
%	otherwise
%		error(['number of rows in val must correspond', ...
%		       ' to number of elements or edges']);
%	end % switch
	
%	if (isnumeric(id))
%		val = val(:,id);
%	else
%		val = id(val);
%	end
%	nt     = round(T/dt_plot);
%	mtimei = (0:nt)'*(T/nt);
%	vali   = interp1(rvec(mtime),val.',rvec(mtimei),'linear').';
	if (~isempty(dt_plot))
		nt  = length(mtime)
		nti = ceil(T/dt_plot) 
		dn  = ceil(nt/nti)
		%Ti = linspace(0,T,ceil(T/dt_plot))';
		%vali = interp1(
	else
		dn = 1;
	end

	nt = length(mtime);
	mtimei = mtime;
	vali = val;	

		p =0.001;
		if (isempty(clim))
			clim = quantile(vali(:),[p,1-p]);
		end
		n = size(val,2);
		k = 0;
		img = [];
		for idx=1:dn:nt
			printf('%d of %d\n',idx,nt);
			cla();
			obj.smesh.plot(squeeze(val(idx,:,:)).');
			view(0,90);
			if (1==idx)
				%axis equal;
				axis square;
				ax = axis;
			else
				axis(ax);
			end
			n = 10;
			if (T(end) > n*365.25) %Constant.MINUTES_PER_YEAR)
				text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d years',round(mtimei(idx)/365.25),round(mtimei(end)/365.25)));
			elseif (T(end) > n*30) % Constant.MINUTES_PER_MONTH)
				dT = 30;
				text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d months',round(mtimei(idx)/dT),round(mtimei(end)/dT)));
			elseif (T(end) > n*1) % Constant.MINUTES_PER_DAY)
				dT = 1;
				text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d days',round(mtimei(idx)/dT),round(mtimei(end)/dT)));
			elseif (T(end) > n*1/24) %Constant.MINUTES_PER_HOUR)
				dT = 1/24;
				text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d hours',round(mtimei(idx)/dT),round(mtimei(end)/dT)));
			elseif (T(end) > n*1/(24*60))
				dt = 1/(24*60);
				text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d minutes',round(mtimei(idx)/dT),round(mtimei(end)/dT)));
			else
				dT = 1/86400;
				text(ax(1)+0.1*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),sprintf('%d/%d seconds',round(mtimei(idx)/dT),round(mtimei(end)/dT)));		
			end
		
			%sprintf('%d/%d',idx,n));
			caxis(clim);
			h = colorbar();
			ylabel(h,'z_b (m)')
			xlabel('Eastimg (km)');
			ylabel('Northing (km)');
			drawnow();
			%pause(dt_pause);

			f   = getframe();
			img = cat(2,img,f.cdata);
			%img(:,:,:,k) = f.cdata
			if (1 == idx)
				siz = size(img);
				%[img,map] = rgb2ind(f.cdata,256,'nodither');
			end

			%if (~isempty(filename))
			%	print('-dpng',sprintf('%s-%03d.png',filename,k));
			%	k = k+1;
			%end
		end
		ncolor = 256;
		[img,cmap] = rgb2ind(img,ncolor,'nodither');
		img3 = reshape(img,siz(1),siz(2),[]);
		img_(:,:,1,:) = img3;
		imwrite(img_,cmap,filename,'gif','DelayTime',dt_pause,'LoopCount',0);
	%end

	%scatter3(x,y,val(:,id),[],val(:,id),'filled');

% scatter3(a(:,1),a(:,2),a(:,3),[],a(:,3)), view(0,90); axis equal
end

