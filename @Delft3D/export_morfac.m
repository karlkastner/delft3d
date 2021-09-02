% Sun 23 May 21:42:13 CEST 2021
function export_morfac(obj,folder,filename)

	itdate = obj.itdate;

	if (isstruct(obj.MorFac))
	s = obj.MorFac;
	s_ = struct();
	s_.MorFac = filename;
	obj.mor.set(s_);
	fid     = fopen([folder,filesep,filename],'w');
	if (fid <= 0)
		error('Unable to open file\n');
	end
	
	if (~isfield(s,'t0'))
		s.t0 = 0;
	end

	% convert days to seconds since start
	%dt_m   = Constant.MINUTES_PER_DAY*s.dto_dt
	time_mi = Constant.MINUTES_PER_DAY*(s.t - s.t0);

	% interpolate values to time slots
	% do not subtract start time here, otherwise series is truncated at the end
	% if there is a gap at the start
	%time_mi = (0:dt_m:time_m(end))';
	% nt      = round(time_m(end)/dt_m);

	% Note: + 1 to circumvent dfm bug that acesses values beyond end of simulation period
	%time_mi = (0:nt+1)*dt_m;
	% (time_m(end)/nt) does not work, time step has to be multiple of sim-time

	% shape preserving cubic interpolation
	%vali = interp1(time_m,val,time_mi,'pchip',NaN);
	vali = s.val; 
	ndx  = vali < 0;
	vali(ndx) = 0;

	% extrapolate boundary values
%	fdx2          = ~isfinite(vali);
	%vali(fdx)    = interp1(time_mi(~fdx),vali(~fdx),time_mi(fdx),'nearest','extrap');
%	vali(fdx2)    = interp1(time_m(fdx),bcc(bdx).val(fdx,idx),time_mi(fdx2),'nearest','extrap');

	% header
	fprintf(fid,'table-name           ''MorFac''\n');
%	fprintf(fid,'contents             ''Uniform             ''\n');
%	fprintf(fid,'location             ''%-20s''\n', bcc(bdx).location);
	fprintf(fid,'time-function        ''non-equidistant''\n');
	fprintf(fid,['reference-time       ',datestr(itdate,'yyyymmdd'),'\n']);
	fprintf(fid,'time-unit            ''minutes''\n');
	fprintf(fid,'interpolation        ''block''\n');
	fprintf(fid,'extrapolation        ''constant''\n');
	fprintf(fid,'parameter            ''time''                     unit ''[min]''\n');
	fprintf(fid,'parameter            ''MorFac'' unit ''-''\n');
%	fprintf(fid,'records-in-table     %d\n',length(time_mi));

	% minus sign is for left justification
	fprintf(fid,'%-9e %-9e\n',[round(rvec(time_mi));rvec(vali)]);

	fclose(fid);
	end % if isstruct MorFac
end % export_morfac

