% Wed 21 Jun 00:08:14 CEST 2017
% TODO, this does not change the link indices
function [obj] = order_coordinates(obj)
	xy = [obj.map.FlowElem_xcc obj.map.FlowElem_ycc];
	[xy sdx] = sortrows(xy);%,'stable');

	name = { ...
                   'FlowElem_xcc', 1;
                   'FlowElem_ycc', 1;
                   'FlowElem_zcc', 1;
                   'FlowElem_bac', 1;
                   'FlowElem_xzw', 1;
                   'FlowElem_yzw', 1;
                             's1', 1;
                     'waterdepth', 1;
                       'numlimdt', 1;
                           'taus', 1;
                    'FlowElem_bl', 1;
                            'ucx', 1;
                            'ucy', 1;
                            'czs', 1;
		 'NetElemNode', 2;
                    'NetElemLink', 2;
              'FlowElemContour_x', 2;
              'FlowElemContour_y', 2;
		};
	for idx=1:size(name,1)
		switch (name{idx,2})
		case{1}
			obj.map.(name{idx,1}) = obj.map.(name{idx,1})(sdx,:);
		case{2}
			obj.map.(name{idx,1}) = obj.map.(name{idx,1})(:,sdx);
		otherwise
			error('e')
		end
	end
end

