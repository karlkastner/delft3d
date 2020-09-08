% Wed 10 Aug 18:25:23 CEST 2016
% Karl Kastner, Berlin

% wrapper returning objective function value and gradient
function [f, g] = calibration_objective(obj, val)
	if (isempty(obj.cnt))
		% as there is no previous evaluation at the origin, start with 1
		obj.cnt.f = 1;
		obj.cnt.g = 0;
	end

	nv = size(val,2);
	if (nargout() < 2)
		% function value only

		if (1 == nv)
			% TODO no magic numbers
			np = 4;
			obj.run(val,np);
			f = obj.extract(val); %, np);
			obj.cnt.f = obj.cnt.f + 1;
			obj.log('%d %d %g %g\n', obj.cnt.f, obj.cnt.g, norm(f), NaN);
			%fprintf(obj.log_fid, '%d %d %g %g\n', obj.cnt.f, obj.cnt.g, norm(f), NaN);
		else
			np = 1;
			% start model runs
			for idx=1:nv
				obj.run(val(:,idx),np);
			end
			% wait for completition and extract data
			for idx=1:nv
				f(:,idx)  = obj.extract(val(:,idx)); %,np);
				obj.cnt.f = obj.cnt.f + 1;
				%fprintf(obj.log_fid, '%d %d %g %g\n', obj.cnt.f, obj.cnt.g, norm(f(:,idx)), NaN);
				obj.log('%d %d %g %g\n', obj.cnt.f, obj.cnt.g, norm(f(:,idx)), NaN);
			end
		end
	else
		%
		% function value and gradient
		%

		% TODO no magic numbers
		parallel = false; % parallelisation done by bash, not matlab
		np = 1;

		% relative step length for gradient estimation
		dv = NaN(size(val));
		% prepare model runs for gradient computation
		[rid pid] = find(obj.id);
		for idx=1:length(rid)
			vid = obj.id(rid,pid);
			par = obj.parameter_C{pid};
			dv(vid) = max(abs(val(vid))*obj.delta_rel.(par), ...
                                                         obj.delta_abs.(par));
		end
%		for idx=1:length(obj.parameter_C)
%			par = obj.parameter_C{idx};
%
%			id = obj.id.(par);
%			if (~isempty(id))
%				dv(id) = max(abs(val(id))*obj.delta_rel.(par), ...
%				                          obj.delta_abs.(par));
%			end % if
%		end % for idx

		% start model runs in parallel
		obj.run(val,np);

		% start model runs for numerical gradient computation
		grad(@(val) obj.run(val,np), val, dv, 'one-sided', parallel);

		% wait for model runs to complete and extract results
		f = obj.extract(val); %,np);

		% compute numerical gradient from results
		g = grad(@(val) obj.extract(val),val,dv,'one-sided',parallel);
		%g = grad(@(val) obj.extract(val,np),val,dv,'one-sided',parallel);

		% log to file
		% evaluation at origin took already place at last step,
		% there are only nr evaluations
		%fprintf(obj.log_fid, '%d %d %g %g\n', obj.cnt.f, obj.cnt.g, norm(f), NaN);
		obj.log('%d %d %g %g\n', obj.cnt.f, obj.cnt.g, norm(f), NaN);
		obj.cnt.f = obj.cnt.f+length(val);
		obj.cnt.g = obj.cnt.g + 1;
		obj.log('%d %d %g %g\n', obj.cnt.f, obj.cnt.g, norm(f), norm(g));
	end % else of if nargout < 2
end % calibration_objective

