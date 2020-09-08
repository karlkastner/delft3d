
% Thu  8 Feb 20:43:48 CET 2018
function x = elem_x(obj)
	if (isfield(obj.map,'FlowElem_xcc'))
		x = obj.map.FlowElem_xcc;
	elseif (isfield(obj.map,'mesh2d_face_x'))
		x = obj.map.mesh2d_face_x;
	else
		error('unimplemented map format');
	end
end

