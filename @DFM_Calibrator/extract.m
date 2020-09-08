% Wed 10 Aug 15:28:19 CEST 2016
% Karl Kastner, Berlin
function f         = extract(obj,reachval)
	outfolder  = obj.template_str;
	if (nargin()>1 && ~isempty(reachval))
		outfolder = [outfolder,sprintf('_%1.2f',reachval)];
	end

	% wait for completition of model run
	while (true)
		state = obj.getstate(outfolder);
		if (isempty(state))
			% TODO, put this into getstate
			error('can''t get state');
		end
		if (strcmp(obj.getstate(outfolder),'completed'))
			break;
		end
		fprintf('Waiting for %s\n',outfolder);
		% wait
		pause(obj.twait);
	end % while 1

	if (exist([outfolder,filesep,'model.mat'],'file'))
		% load extracted model result
		load([outfolder,filesep,'model.mat'],'model');
	else
		model = [];
	end

	% reload model if data is incomplete
	if (test_model(model))
		% extract model results, if not yet extracted
		file_a = dir([outfolder,filesep,'DFM_OUTPUT_FlowFM',filesep,'FlowFM*his*.nc']);
		% extract modelled values at calibration stations
		for idx=1:length(file_a)
			file_a(idx).name = [outfolder,filesep,'DFM_OUTPUT_FlowFM',filesep,file_a(idx).name]; 
		end
		file_C = {file_a.name};
		model = obj.extract_water_level(file_C);
		% save extracted model results
		save([outfolder,filesep,'model.mat'],'model');
	else
		% load extracted model result
		load([outfolder,filesep,'model.mat'],'model');
	end

	if (test_model(model))
		warning('model data incomplete');
		f = NaN;
		return;
	end
	
	% interpolate to identical time slots
	hmeas  = zeros(length(obj.station(1).time),length(obj.station));
	hmodel = zeros(length(obj.station(1).time),length(obj.station));

	% this assume synchronous time steps in measurements
	for idx=1:length(obj.station)
		% TODO, extract only slots in calibration period
		hmeas(:,idx)  = obj.station(idx).depth;
		hmodel(:,idx) = interp1_limited(cvec(model(1).time),cvec(model(idx).level),cvec(obj.station(1).time),obj.dt_max,'pchip');
	end

	% if stage has no absolute reference (only depth, but no elevation)
	% the bias is removed
	if (obj.relative_level)
		offset = nanmean(hmodel-hmeas);
		hmodel = bsxfun(@minus,hmodel,offset);
	end
	
	% exclude a time span at the begin of calibration period
	T0  = obj.tstart; %datenum(obj.mdu.DStart,'yyyy/mm/dd');
	tdx = ((cvec(obj.station(1).time) - T0) >= obj.Tskip);

	% compute objective function vale
	% TODO account for covariances in time and space
	d   = hmodel-hmeas;
	fdx = isfinite(d);
	f   = d(bsxfun(@and,fdx,tdx));
end % extract

function flag = test_model(model)
	flag = true;
	if (isfield(model,'time'))
		t = model(1).time;
	else
		return;
	end
	% check for completeness
	if (length(t)<2 || (length(t)-1)*(t(2)-t(1)) ~= (t(end)-t(1)))
		return;
		%disp([length(t), (t(end)-t(1))/(t(2)-t(1))]);
%		warning('Incomplete model output data');
%		f = NaN;
%		return;
	end
	flag = false;
end

