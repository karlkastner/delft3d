% Fri 13 Jan 09:55:58 CET 2017
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
classdef DFM < handle
	properties
		folder_str      = '';
		mdufile_str     = 'FlowFM.mdu';
		

		% note : IniFile is assigned in the constructor,
		% as otherwise there are side effects for paralle objects
		mdu     
		mor
		sed
		extforce
		%frc_ext
		bnd_ext
	end % properties
	methods (Static)
		export_bc(folder,base,s,t0,dt)
		export_his(shp,oname);
		export_pli(shp,filename,name);
		[Xc Yc W X Y Z mesh] = read_cross_section_geometry(name,mesh);
		shp = read_pli(name);
		export_cross_section_geometry(name,Xc,Yc,Fc,X,Y,Z);
	end % methods (static)
	methods
		% default constructor
		function obj = DFM()
			obj.mdu      = IniFile();
			obj.mor      = IniFile();
			obj.sed      = IniFile();
			obj.extforce = IniFile();
			obj.bnd_ext  = IniFile();
		end % DFM
	
		% pseud member variables

		function [tref obj] = RefDate(obj,tref)
			% load the reference date
			if (nargin() < 2)
				RefDate  = obj.mdu.get('time','RefDate');
				%RefDate  = [RefDate(1:4),'/',RefDate(5:6),'/',RefDate(7:8)];
				tref     = datenum(RefDate,'yyyymmdd');
			else
				RefDate  = datestr(tref,'yyyymmdd');
				obj.mdu.set('time','RefDate',RefDate); 
			end
		end

		function [tstart obj] = TStart(obj,tstart)
			% load start date
			if (nargin() < 2)
				TStart = obj.mdu.get('time','TStart');
				tstart = 1/86400*(str2num(TStart)) + obj.RefDate;
			else
				if (isstr(tstart))
					tstart = datenum(tstart);
				end
				TStart = 86400*(tstart - obj.RefDate);
				obj.mdu.set('time','TStart',[num2str(TStart)]); %,' # ',obj.mdu.DStart]);
			end
		end

		function [tstop obj] = TStop(obj,tstop)
			% load stop date
			if (nargin() < 2)
				TStop = obj.mdu.get('time','TStop');
				tstop = 1/86400*(str2num(TStop)) + obj.RefDate;
			else
				if (isstr(tstop))
					tstop = datenum(tstop);
				end
				TStop = 86400*(tstop - obj.RefDate);
				obj.mdu.set('time','TStop',[num2str(TStop)]); %,' # ',obj.mdu.DStart]);
			end
		end
		
		function [val,obj] = HisInterval(obj,val)
			if (nargin()<2)
				val = obj.mdu.get('output','HisInterval');
				val = val/86400;
			else
				val = 86400*val;
				obj.mdu.set('output','HisInterval',[num2str(val)]);
			end
		end

		function [val,obj] = MorFac(obj,val)
			if (nargin()<2)
				val = obj.mor.get('Morphology','MorFac');
			else
				obj.mor.set('Morphology','MorFac',[num2str(val)]);
			end
		end

		function [val,obj] = MapInterval(obj,val)
			if (nargin()<2)
				val = obj.mdu.get('output','MapInterval');
				val = val/86400;
			else
				val = 86400*val;
				obj.mdu.set('output','MapInterval',[num2str(val)]);
			end
		end

		function [RestartFile obj] = RestartFile(obj,RestartFile)
			% load RestartFile name
			if (nargin() < 2)
				RestartFile = obj.mdu.get('restart','RestartFile');
			else
				obj.mdu.set('restart','RestartFile',RestartFile);
			end
		end

		function [ExtForceFile obj] = ExtForceFile(obj,ExtForceFile)
			% load RestartFile name
			if (nargin() < 2)
				ExtForceFile = obj.mdu.get('external forcing','ExtForceFile');
			else
				obj.mdu.set('external forcing','ExtForceFile',ExtForceFile);
			end
		end

		function [ExtForceFileNew obj] = ExtForceFileNew(obj,ExtForceFileNew)
			if (nargin() < 2)
				ExtForceFileNew = obj.mdu.get('external forcing','ExtForceFileNew');
			else
				obj.mdu.set('external forcing','ExtForceFileNew',ExtForceFileNew);
			end
		end

		function [val, obj] = WaterLevIniFile(obj,val)
			if (nargin() < 2)
				val = obj.mdu.get('geometry','WaterLevIniFile');
			else
				obj.mdu.set('geometry','WaterLevIniFile',val);
			end
		end

		function [NetFile obj] = NetFile(obj,NetFile)
			if (nargin() < 2)
				NetFile = obj.mdu.get('geometry','NetFile');
			else
				base = regexprep(NetFile,'_net.nc','');
				obj.mdu.set('geometry','NetFile',NetFile);
				% only add 1d-files, if they exist
				file = [base,'_profloc.xyz']
				if (exist(file,'file'))
					obj.mdu.set('geometry','ProflocFile',file);
				else
					obj.mdu.set('geometry','ProflocFile','');
				end
				file = [base,'_profdef.txt'];
				if (exist(file,'file'))
					obj.mdu.set('geometry','ProfdefFile',file);
				else
					obj.mdu.set('geometry','ProfdefFile','');
				end
				file = [base,'.xyzprof'];				
				if (exist(file,'file'))
					obj.mdu.set('geometry','ProfdefxyzFile',file);
				else
					obj.mdu.set('geometry','ProfdefxyzFile','');
				end
				file_str = [base,'_rgh.xyz'];
				% TODO, this does not work if the folder is different
				%if (exist(file,'file'))
					obj.extforce.set('','FILENAME',file_str);
				%else
				%	obj.extforce.set('','FILENAME','');
				%end
			end
		end
		function [ProfdefFile obj] = ProfdefFile(obj,ProfdefFile)
			% load RestartFile name
			if (nargin() < 2)
				ProfdefFile = obj.mdu.get('geometry','ProfdefFile');
			else
				obj.mdu.set('geometry','ProfdefFile',ProfdefFile);
			end
		end
	end % methods
end % classdef DFM

