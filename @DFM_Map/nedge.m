% Thu  8 Feb 20:44:26 CET 2018
function n = nedge(obj)
	if (isfield(obj.map,'mesh2d_edge_nodes'))
		n = size(obj.map.mesh2d_edge_nodes,2);
	elseif (isfield(obj.map,'FlowLink'))
		n = size(obj.map.FlowLink,2);
	else
		error('unimplemented map format');
	end
end

