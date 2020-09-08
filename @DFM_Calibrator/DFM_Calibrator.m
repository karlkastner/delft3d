% Fri  2 Sep 10:56:25 CEST 2016 
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

classdef DFM_Calibrator < handle
	properties
		% do not run model, just pretend
		dryflag = false;

		% water level data is not referenced (has offset to NAP)
		relative_level = true

		% 
		mdu_str       = 'FlowFM.mdu';
		% maximum distance to reference station
		dmax = 1e3;
		% mesh_str      = [];

		% default roughness values
		%roughness = struct('value',70, ...
		%		   'lower_bound',10);
		%delta_rel = struct('Chezy',1e-3, ...
		delta_rel = struct('Chezy',1e-2, ...
                                   'bedlevel',1e-3);
		delta_abs = struct('Chezy', 1, ...
                                   'bedlevel',0.05);

		% options for calibration
		opt = struct( ... %'solver', @nlcg, ...
		            'solver', @nlls, ... %@nlcg, ...
			    ... %'maxiter',3, ...
			    'verbose', 2, ...
			    'reltol', 1e-3, ...
			    'abstol', 0.1, ...
			    'ls_solver', @line_search_quadratic2, ...
			    'ls_maxiter',10, ...
			    'ls_h', 1e-2 );
	
		% additional mdu options
		%mdu ={};
		tstart;
		tstop;

		% time to wait during model runs to check if run is complete
		twait   = 30;
		
		% maximum time to bridge with interpolation
		dt_max  = 1/24;
		
		cygpath='C:\cygwin64\bin\';

		% counter for calibration statistics
		cnt;
		% TODO Chezy should become roughness
		parameter_C = {'Chezy', 'bedlevel'};


% reach    : n_reach-1 x 1   :  struct(x,y) polygon of input files
		reachpoly_C;
% base     : folder of output
		template_str;
% station  : struct(x,y,t,h) : depth to be calibrated against
		station;
	
		id;
		log_fid;
		log_str = 'log.txt';
		ub;
	
		% timespan to ignore at begin of calibration model run
		Tskip = 4;

		% reference time
		tref = 0;

		% number of running models
		np = 0
		% maximum number of running models	
		npmax = 4
		% list of running processes
		process_C;

		% function returning data at reference stations
		reference_stations
	end % properties
	methods (Static)
		[out, Q, A, mesh] = extract_discharge(mapname_C,t0,x0,y0,name_C)
%		[out, mwl, unorm, mwlt, unormt] = extract_water_level(tref,mapname_C,x0,y0,Su,placename_C,blocksize)
		state = getstate(outfolder);
	end % methods (STATIC)
	methods
		% constructor
		function obj = DFM_Calibrator(varargin)
                        for idx=1:length(varargin)/2                            
                                obj = setfield_deep(obj,varargin{1+2*(idx-1)},varargin{2*idx});
                        end % for  
		end
	end % methods
end % class DFM_Calibrator

