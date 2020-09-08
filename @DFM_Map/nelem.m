% Thu  8 Feb 20:37:05 CET 2018
function n = nelem(obj)
	if (isfield(obj.map,'mesh2d_face_nodes'))
		n = size(obj.map.mesh2d_face_nodes,2);
	elseif (isfield(obj.map,'NetElemNode'))
		n = size(obj.map.NetElemNode,2);
	else
		error('unimplemented map format');
	end
end

