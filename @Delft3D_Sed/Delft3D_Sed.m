% Thu 24 May 08:22:34 CEST 2018
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
classdef Delft3D_Sed < handle
	properties
		dat
	end % methods
	methods
		function obj = Delft3D_Sed()
		end

		function set(obj,s)
			f_C   = fieldnames(s);
			% not : rvec(f_C) is breaks when list is empty
			for idx = 1:length(f_C)
				val = s.(f_C{idx});
				if (isstruct(val))
					obj.dat.(f_C{idx}) = setfield_deep(obj.dat.(f_C{idx}),val);
				else
				if (islogical(val))
					if (val)
						val = 'true';
					else
						val = 'false';
					end
				elseif (isnumeric(val))
					val = num2str(val);
				elseif (isstr(val))
					val = ['#',val,'#'];
				else
					error('here');
				end
				obj.dat.(f_C{idx}) = val;
				end % else of if struct
			end % for f
		end % function set_

		function [obj2, obj] = copy(obj)
			f_C = fieldnames(obj);
			obj2 = Delft3D();
			for idx=1:length(obj)
				obj2.(f_C{idx}) = obj.(f_C{idx});
			end
		end
		function obj = read(obj,file_str)
			if (nargin() < 2)
				w       = what(class(obj));
				file_str = [w.path,filesep,'delft3d.sed'];
			end
			obj.dat = struct();

			fid = fopen(file_str,'r');
			line = fgetl(fid);
			id = 1;
			section = [];
			while ischar(line)
			if (line(1) == '[')
				section    = regexprep(regexprep(line,'^\s*[',''),']\s*$','');
				if (isfield(obj.dat,section))
					id_ = length(obj.dat.(section))+1;
				else
					id_ = 1;
				end % if
			else	
				id   = strfind(line,'=');
				name = chomp(line(1:id(1)-1));
				name = regexprep(regexprep(name,'^\s*',''),'\s*$','');
				if (~isempty(name))
					val  = chomp(line(id(1)+1:end));
					val = regexprep(regexprep(val,'^\s*',''),'\s*$','');
					obj.dat.(section)(id_(1)).(name) = val;
				end % if
			end % if
				line = fgetl(fid);
			end % while
			fclose(fid);
		end

		function obj = write(obj,file_str,folder)
			if (nargin() < 3)
				folder = '.';
			end
			fid = fopen([folder,filesep,file_str],'w');
			%line = fgetl(fid);
			s_C = fieldnames(obj.dat);
			for jdx=1:length(s_C)
				section = obj.dat.(s_C{jdx});
				for kdx=1:length(section)
					fprintf(fid,'[%s]\n',s_C{jdx});
					f_C = fieldnames(section(kdx));
					%obj.dat.(sed.dat{1});
					for idx=1:length(f_C)
						fprintf(fid,'%s = %s\n',f_C{idx},section(kdx).(f_C{idx}));
					end % for idx
				end % % for kdx
			end % for jdx
			fclose(fid);
		end	
	end % methods
end % class Delft3D_Sed

