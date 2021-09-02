% Tue 10 Mar 12:35:54 +08 2020
%
%% interface for automatically generating and reading Delft3D-4 models
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
		% structured mesh object
		mesh
		% model-definition-file object
		mdf
		% mor-file object
		mor
		% sed-file object
		sed
		% boundary condition location
		bnd
		% boundary condition as time series
		bct	
		% boundary values as harmonic series
		bch
		% suspended sediment concentration boundary values as times series
		bcc
		% salinity concentration at boundary as time series
		bcc_sal
		% bed load transport boundary values as times series
		bcm
		% measurement cross sections
		crs
		% observation points
		obs
		% time-varying morfac
		MorFac
		% thin dames
		thin_dams
		% initial condition
		ini
		inicomp
		% domain decomposition
		ddb

		itdate
		tratype
		reference_level = 0.0;

		% folder, where model files reside in
		folder
		hfolder

		% basename for model files
		base = 'delft3d';
	end %  properties
	methods
		function obj = Delft3D()
 			obj.mesh = StructuredMesh();
			obj.mdf  = Delft3D_Mdf();
			obj.mor  = Delft3D_Mor();
			obj.sed  = Delft3D_Sed();
		end % constructor

		function folder = templatefolder(obj)
			w      = what(class(obj));
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

