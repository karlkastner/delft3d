% Sat 14 Jan 16:26:14 CET 2017
% Karl Kastner, Berlin
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

classdef DFM_Map < handle
	properties
		map
		info
		tref = 0;
		FlowElem_rgh
		FlowElem_grain_size
		FlowLink_width_;
	end
	methods
		function obj = DFM_Map(varargin)
			if (length(varargin)>0)
				obj.read(varargin{1});
			end
			for idx=2:length(varargin)
				obji = DFM_Map(varargin{idx});
				obj.cat(obji);
			end % for idx
		end % constructor

		function [t, obj] = time(obj)
			t = obj.map.time/86400+obj.tref;
		end

		function [obj] = read(obj,arg)
			if (isstr(arg))
				[obj.map, obj.info] = nc_readall(arg);
			else
				obj.map = arg;
			end
		end

		function [t, obj] = write(obj, filename)
			% adapt length of time			
			nt  = length(obj.map.time);
			idx = find(arrayfun(@(x) strcmp(x.Name,'time'),obj.info.Dimensions));
			obj.info.Dimensions(idx).Length = nt;
			nc_writeall(filename,obj.map,obj.info);
		end
	end % methods
end % classdef DFM_Map

