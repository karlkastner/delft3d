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
classdef Delft3D_Mdf < handle
	properties
		mdf
	end % methods
	methods
		function obj = Delft3D_Mdf()
		end
		function set(obj,pname,pval)
			if (isstruct(pname))
				obj.set_(pname);
			else

			if (~ischar(pval))
				pval = sprintf(' %g',pval);
			end
			obj.mdf.dat.(pname) = pval;
			end
		end
		function val = get(obj,pname)
			val = obj.mdf.dat.(pname);
			num = str2num(val);
			if (~isempty(num))
				val = num;
			end
			if (isstr(val))
				val = strtrim(val);
				if (length(val) > 0 && val(1) == '#')
					val = val(2:end);
				end
				if (length(val) > 0 && val(end) == '#')
					val = val(1:end-1);
				end
			end
		end

		function set_(obj,s)
			f_C   = fieldnames(s);
			for f = rvec(f_C)
				val = s.(f{1});
				if (isstruct(val))
					obj.mdf.dat.(f{1}) = setfield_deep(obj.mdf.dat.(f{1}),val);
				else
				switch (f{1})
				case {'Flmap_dt','dt_map'}
					%obj.mdf.Flmap = ['0 ', num2str(val), ' ', obj.mdf.Tstop];
					obj.mdf.dat.Flmap  = ['0.0000000e+000 ', num2str(val,'%4d'), '  6.0000000e+008'];
				case {'Flhis_dt'}
					obj.mdf.dat.Flhis = ['0 ', num2str(val), ' ', obj.mdf.Tstop];
					%obj.mdf.dat.Flmap  = ['0.0000000e+000 ', num2str(dt_map,'%4d'), '  6.0000000e+008'];
				otherwise
				
				if (islogical(val))
					if (val)
						val = 'true';
					else
						val = 'false';
					end
				elseif (isnumeric(val))
					%val = num2str(val);
					val = sprintf('%g\n',val);
					val = chomp(val);
				elseif (isstr(val))
					val = ['#',val,'#'];
				else
					error('here');
				end
				obj.mdf.dat.(f{1}) = val;
				end % switch
				end % else of if struct
			end % for f
		end % function set_

		% TODO make base a member or get from parent Delft3D
		function set_filenames(obj,base)
			% TODO : edy : eddy viscosity
			% TODO : sed : sediment thickness
			% TODO : dry : dry points
			% TODO : cor : astrononmical boundary conditions
			% TODO : src, dis : in-grid discharge sources/sinks and values
			% TODO : par : drogues
			% TODO : fou : fourier analysis
			% grid
			obj.mdf.dat.Filcco  = ['#',base,'.grd#'];
			% domain enclosure
			obj.mdf.dat.Filgrd  = ['#',base,'.enc#'];
			% bed level
			obj.mdf.dat.Fildep  = ['#',base,'.dep#'];
			% initial conditions
			obj.mdf.dat.Filic   = ['#',base,'.ini#'];
			% ?
			obj.mdf.dat.Filtd   = ['#',base,'.thd#'];
			sub2 = strtrim(obj.mdf.dat.Sub2);
			if (length(sub2)>0 && sub2(1) == '#')
				sub2 = sub2(2:end);
			end
			if (length(sub2)<2 || (sub2(2) ~= 'C'))
				obj.mdf.dat.FilbcC = '';
				obj.mdf.dat.Filsed = '';
				obj.mdf.dat.Filmor = '';
			else
				% sediment definition
				obj.mdf.dat.Filsed  = ['#',base,'.sed#'];
				% morphodynamics
				obj.mdf.dat.Filmor = ['#',base,'.mor#'];
				% transport conditions at boundaries
				obj.mdf.dat.FilbcC = ['#',base,'.bcc#'];
			end
			% roughness model
			obj.mdf.dat.Trtu    = ['#',base,'.trtu#'];
			obj.mdf.dat.Trtv    = ['#',base,'.trtv#'];
			% roughness values
			obj.mdf.dat.Filrgh = ['#',base,'.rgh#'];
			% boundary condition location
			obj.mdf.dat.Filbnd = ['#',base,'.bnd#'];
			% boundaries as harmonic series
			obj.mdf.dat.FilbcH = ['#',base,'.bch#'];
			% boundary as rating courve
			obj.mdf.dat.FilbcQ = ['#',base,'.bcq#'];
			% boundaries as time series
			obj.mdf.dat.FilbcT = ['#',base,'.bct#'];
			% 
			obj.mdf.dat.Filsta = ['#',base,'.obs#'];
			% 
			obj.mdf.dat.Filcrs = ['#',base,'.crs#'];
			%
			obj.mdf.dat.Trtdef = ['#',base,'.tra#'];
		end % set_filenames

		function [obj2, obj] = copy(obj)
			f_C = fieldnames(obj);
			obj2 = Delft3D();
			for idx=1:length(obj)
				obj2.(f_C{idx}) = obj.(f_C{idx});
			end
		end
		function obj = read_mdf(obj,mdf_str)
			if (nargin() < 2)
				w = what(class(obj));
				mdf_str = [w.path,filesep,'delft3d_2d.mdf'];
			end
			%if (nargin() < 3)
			%	folder = '.';
			%end

			% obj.mdf.file_str = mdf_str;
			fid = fopen(mdf_str,'r');
			line = fgetl(fid);
			while ischar(line)
				id   = strfind(line,'=');
				name = chomp(line(1:id-1));
				if (~isempty(name))
					val  = chomp(line(id+1:end));
					obj.mdf.dat.(name) = val;
				end
				line = fgetl(fid);
			end
			fclose(fid);
		end

		function obj = write_mdf(obj,mdf_str,folder)
			if (nargin() < 3)
				folder = '.';
			end
			% sanity check runid
			if (~isfield(obj.mdf.dat,'Runid'))
				obj.set('Runid','delft3d');
			end

			% broken in Delft3D 4
			Tkemod = obj.get('Tkemod');
			if (length(Tkemod) > 2 && strcmp(Tkemod(1:3),'K-e'))
			% && obj.param.mor.DensIn)
				warning('K-eps model is broke in Delft3D 4, esp with DensIn set, causes checkerboarding, use only for testing')
			end

			% sanity checks

			% make stop time multiple of Dt
			Dt    = obj.get('Dt');
			Tstop = obj.get('Tstop');
			Tstop = Dt*round(Tstop/Dt);
			obj.set('Tstop',Tstop);

			% note that this works also for Fl-fiels which are arrays
			f_C = {'Tlfsmo','Flmap','Flhis','Flpp'};
			for idx=1:length(f_C)
				val = obj.get(f_C{idx});
				% make times multiple of time step
				val = Dt*round(val/Dt);
				% limit end time
				val = min(val,Tstop);
				obj.set(f_C{idx},val);
				% why not set?
				%obj.mdf.dat.(f_C{idx}) = num2str(val);
			end % for f

			%obj.mdf.file_str = mdf_str;
			fid = fopen([folder,filesep,mdf_str],'w');
			%line = fgetl(fid);
			f_C = fieldnames(obj.mdf.dat);
			for idx=1:length(f_C)
				fprintf(fid,'%-8s = %s\n',f_C{idx},obj.mdf.dat.(f_C{idx}));
			end
			fclose(fid);
		end	
	end % methods
end % class Delft3D

