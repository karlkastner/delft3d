% Tue 10 Mar 12:35:54 +08 2020
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
classdef Delft3D < handle
	properties
		mesh;
		mdf
		mor
		sed
		bnd
		bct	
		bcc	
		crs
		obs
		thin_dams

		itdate
		tratype
		reference_level = 0.0;

		folder
		base = 'delft3d';
	end %  properties
	methods
		function obj = Delft3D()
 			obj.mesh = StructuredMesh();
			obj.mdf  = Delft3D_Mdf();
			obj.mor  = Delft3D_Mor();
			obj.sed  = Delft3D_Sed();
			%obj.bnd  = struct();
			%obj.bcc  = struct();
			%obj.crs  = struct();
			%obj.obs  = struct();
			%obj.thin_dams = struct();
		end % constructor

		function folder = templatefolder(obj)
			w=what(class(obj));
			folder = [dirname(w.path),'/delft3d-template'];
		end

		function ij = pq2ij(obj,pq)
			nm = obj.mesh.n;
			% note the swap of dimensions
			ij(:,1) = 1 + round(pq(:,1)*(nm(2)-1));
			ij(:,2) = 1 + round(pq(:,2)*(nm(1)-1));
		end
	end % methods
end % Delft3D

