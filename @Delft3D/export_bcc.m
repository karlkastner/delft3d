% Mon 23 Dec 21:39:45 +08 2019
% export dummy boundary condition for sediment concentration
function export_bcc(obj,filename,mode)
	bcc = obj.bcc;
	itdate = obj.itdate;
	bcname_ = filename;

	gsd = obj.sed.dat.Sediment;

	if (nargin()<3)
		mode = 'w';
	end
	fid     = fopen(bcname_,mode);
	if (fid <= 0)
		error('Unable to open file\n');
	end

	for bdx=1:length(bcc)
	if (~isfield(bcc(bdx),'t0') || isempty(bcc(bdx).t0))
		bcc(bdx).t0 = bcc(bdx).time(1);
	end
	for idx=1:length(gsd)

	% convert days to seconds
	dt_m   = Constant.MINUTES_PER_DAY*bcc(bdx).dt_d;
	time_m = Constant.MINUTES_PER_DAY*(bcc(bdx).time-bcc(bdx).t0);

	% interpolate values to time slots
	% do not subtract start time here, otherwise series is truncated at the end
	% if there is a gap at the start
	%time_mi = (0:dt_m:time_m(end))';
	nt      = round(time_m(end)/dt_m);

	% Note: + 1 to circumvent dfm bug that acesses values beyond end of simulation period
	time_mi = (0:nt+1)*dt_m;
	% (time_m(end)/nt) does not work, time step has to be multiple of sim-time

	% shape preserving cubic interpolation
	fdx  = isfinite(bcc(bdx).val(:,idx));
	vali = interp1(time_m(fdx),bcc(bdx).val(fdx,idx),time_mi,'pchip',NaN);

	% extrapolate boundary values
	fdx          = ~isfinite(vali);
	vali(fdx)    = interp1(time_mi(~fdx),vali(~fdx),time_mi(fdx),'nearest','extrap');

	% header
	fprintf(fid,'table-name           ''Boundary Section : %d''\n',bdx);
	fprintf(fid,'contents             ''Uniform             ''\n');
	fprintf(fid,'location             ''%-20s''\n', bcc(bdx).location);
	fprintf(fid,'time-function        ''non-equidistant''\n');
	fprintf(fid,['reference-time       ',datestr(itdate,'yyyymmdd'),'\n']);
	fprintf(fid,'time-unit            ''minutes''\n');
	fprintf(fid,'interpolation        ''linear''\n');
	fprintf(fid,'parameter            ''time                ''                     unit ''[min]''\n');
	fprintf(fid,'parameter            ''%-20s end A uniform''       unit ''[kg/m3]''\n',gsd(idx).Name(2:end-1));
	fprintf(fid,'parameter            ''%-20s end B uniform''       unit ''[kg/m3]''\n',gsd(idx).Name(2:end-1));
	fprintf(fid,'records-in-table     %d\n',length(time_mi));

	% minus sign is for left justification
	fprintf(fid,'%-9e %-9e %-9e\n',[round(rvec(time_mi));rvec(vali);rvec(vali)]);

	end % for idx
	end % for bdx

	fclose(fid);
end % export_bcc

