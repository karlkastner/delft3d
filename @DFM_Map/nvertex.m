% Sun 11 Feb 19:28:19 CET 2018
function n = nvertex(obj)
	if (isfield(obj.map,'mesh2d_node_x'))
		n = length(obj.map.mesh2d_node_x);
	else
		n = length(obj.map.NetNode_x);
	end
%	if (isfield(obj.map,'mesh2d_face_nodes'))
%		n = size(obj.map.mesh2d_face_nodes,2);
%	elseif (isfield(obj.map,'NetElemNode'))
%		n = size(obj.map.NetElemNode,2);
%	else
%		error('unimplemented map format');
%	end
end

