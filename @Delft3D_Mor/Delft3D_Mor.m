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
classdef Delft3D_Mor < handle
	properties
		dat
	end % methods
	methods
		function obj = Delft3D_Mor()
		end
		function [obj2, obj] = copy(obj)
			f_C = fieldnames(obj);
			obj2 = Delft3D();
			for idx=1:length(obj)
				obj2.(f_C{idx}) = obj.(f_C{idx});
			end
		end
		function obj = read(obj,file_str)
			if (nargin() < 2)
				w = what(class(obj));
				file_str = [w.path,filesep,'delft3d.mor'];
			end
			obj.dat = struct();

			fid = fopen(file_str,'r');
			line = fgetl(fid);
			while ischar(line)
			if (line(1) == '[')
				name = regexprep(regexprep(line,'^\s*[',''),']\s*$','');
				obj.dat.(name) = NaN;
			else	
				id   = strfind(line,'=');
				name = chomp(line(1:id-1));
				name = regexprep(regexprep(name,'^\s*',''),'\s*$','');
				if (~isempty(name))
					val  = chomp(line(id+1:end));
					val = regexprep(regexprep(val,'^\s*',''),'\s*$','');
					obj.dat.(name) = val;
				end
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
			f_C = fieldnames(obj.dat);
			for idx=1:length(f_C)
				if (isnan(obj.dat.(f_C{idx})))
					% print header (nan-value)
					fprintf(fid,'[%s]\n',f_C{idx});
				else
					vuc = obj.dat.(f_C{idx});
					if (~isempty(vuc))
					% split into value, unit and comment
					vuc = regexprep(regexprep(vuc,'^ *',''),' *$','');
					k   = strfind(vuc,' ');
					if (isempty(k))
						k = length(vuc);
					end
					k = k(1);
					val = vuc(1:k);
					uc  = vuc(k+1:end);
					uc = regexprep(regexprep(uc,'^ *',''),' *$','');
					k   = strfind(uc,']');
					% get unit
					if (isempty(k))
						k = 0;
					end
					unit    = uc(1:k);
					comment = uc(k+1:end);
					% fetch values only for numbers (and not filenames)
					if (~isempty(str2num(val)))	
					if (isempty(unit))
						try
							unit = Mor_Units.(f_C{idx});
						catch e
							e
							unit = '';
						end
					end
					end
					else
						val = '';
						unit = '';
						comment = '';
					end
					fprintf(fid,'%-12s = %-15s %-3s %s\n',f_C{idx},val,unit,comment);
				end
			end
			fclose(fid);
		end
		function set_behind(obj,field,value,predecessor)
			if (isfield(obj.dat,field))
				obj.dat.(field) = value;
			else
				obj.dat=setfield_behind(obj.dat,field,value,predecessor);
			end
		end
		function set(obj,s)
			if (~isempty(s))
			f_C = fieldnames(s);
			for idx=1:length(f_C)
				val = s.(f_C{idx});
				if (isnumeric(val))
					obj.dat.(f_C{idx}) = num2str(val);
				elseif (islogical(val))
					if (val)
						val = 'true';
					else
						val = 'false';
					end
					obj.dat.(f_C{idx}) = val;
				elseif (ischar(val))
					obj.dat.(f_C{idx}) = val;
				else
					disp(f_C{idx});
					disp(val);
					error('here');
				end
			end
			end
		end
	end % methods
end % class Delft3D_Mor

