% Thu  8 Feb 20:44:10 CET 2018
function y = elem_y(obj)
	if (isfield(obj.map,'FlowElem_ycc'))
		y = obj.map.FlowElem_ycc;
	elseif (isfield(obj.map,'mesh2d_face_y'))
		y = obj.map.mesh2d_face_y;
	else
		error('unimplemented map format');
	end
end

