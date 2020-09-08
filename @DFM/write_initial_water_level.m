% Sat 10 Feb 15:42:48 CET 2018
function obj = write_initial_water_level(obj)
%	try
		mesh=UnstructuredMesh();
		mesh.import_delft3d([obj.folder_str,filesep,obj.NetFile]);
		zs = zeros(mesh.np,1);
		write_xyz([obj.folder_str,filesep,obj.WaterLevIniFile],mesh.X,mesh.Y,zs);
%	catch e
%		disp(e);
%	end
end

