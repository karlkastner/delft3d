% Wed 10 Aug 18:25:23 CEST 2016
% Karl Kastner, Berlin

function val = calibrate(obj,template_str,reach_C,val0)
	obj.template_str = regexprep(template_str,'/$','');

	% load reach definition files
	% points for interpolation or polygons of constant value
	% multiple reaches can have the same value and are identified by "id"
	reachpoly_C = {};
	for idx=1:length(reach_C)
		reachpoly_C{idx} = Shp.read(reach_C{idx});
	end % for idx

	% total number of calibration reaches
	% TODO id must be different for each calibration parameter
	%nc = length(reachpoly);
	%[uid ua ub] = unique([reachpoly_C(:).id]);
	%obj.ub      = ub;

	% number of unique calibration reaches
	%nu = length(uid);

	% verify that reaches are enumerated without gaps
	% TODO renumber reaches if this is the case
	%if (max(abs(rvec(uid) - (1:nu)))>0)
	%	error('Unique calibration values must be continuously enumerated starting from 1');
	%end
	
	np = 0;
	% uniquely references each calibration-parameter pair in the calibration value vector
	nr = max([cellfun(@(x) x.id,reachpoly_C)]);
	id = zeros(nr,length(obj.parameter_C));
	% set initial values for each reach
	if (isempty(val0))
		% number of parameter sets
		np = 0;
		% for each set of calibration reaches
		for idx=1:length(reachpoly_C)
			% for each calibration parameter
			for jdx=1:length(obj.parameter_C)
				par      = obj.parameter_C{jdx};
				if (isfield(reachpoly_C{idx},par))
						%id(idx).(par) = nu*np + (1:nu)';
					% for each reach, take over parameter values
					% (latest value overwrites previous)
					for kdx=1:length(reachpoly_C{idx})
						% reach index in calibration reach file
						rid = reachpoly_C{idx}(kdx).id;
						% check if reach-parameter combination exists
						if (0==id(rid,jdx))
							% increase number of calibration reach-parameter pairs
							np = np+1;
							% set slot number of the parameter-reach combination
							id(rid,jdx) = np;
						end
						% index in parameter vector
						%ud0 = ub(id0);
						% set initial value
						val0(id(rid,jdx),1) = reachpoly_C{idx}(kdx).(par);
						%val0(id(idx).(par)(ub(kdx)),1) = reachpoly_C{idx}(kdx).(par);
					end % for kdx
				%else
					%id(jdx).(par) = [];
				end % else of if isfield reachpoly_C par
			end % for jdx
		end % for idx
		if (0==np)
			error('No calibration parameter/reaches specified');
		end
	end % isempty val0

	obj.id          = id;
	obj.reachpoly_C = reachpoly_C;

	% load reference data
	obj.station = obj.reference_stations();

	% create log file
	obj.log_fid = fopen(obj.log_str, 'w');
	if (obj.log_fid < 1)
		error('Cannot open log file for writing\n');
	end

	% log file header
	obj.log('nf ng f ||g||\n');

	% print initial values
	fprintf(1,'Initial values:\n')
	obj.print_calibration_parameter(val0);

	%
	% calibrate by optimisation
	%
	opt         = obj.opt;
	opt.ls_h    = sqrt(length(val0))*opt.ls_h;
	opt.logfile = [template_str,filesep,'nlls.mat'];
	solver      = obj.opt.solver;
	% TODO set lower bound for each parameter
	[val f res] = solver(@(val) obj.calibration_objective(val), val0, opt); %, obj.roughness.lower_bound);

	fprintf('Calibrated values:\n');
	obj.print_calibration_parameter(val);

	% close log file
	fclose(obj.log_fid);

end % Delft3dfm::calibrate

