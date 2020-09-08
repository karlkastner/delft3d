% Di 16. Feb 20:18:40 CET 2016
function export_bc_(folder,s,t0,dt,id)
	bcname_ = [folder,filesep,s.name,'.bc'];
	fid = fopen(bcname_,'w');
	if (fid <= 0)
		error('Unable to open file\n');
	end

	% convert days to seconds
	dt_s   = Constant.SECONDS_PER_DAY*dt;
	time_s = Constant.SECONDS_PER_DAY*(s.time-t0);

	% interpolate values to time slots
	% do not subtract start time here, otherwise series is truncated at the end
	% if there is a gap at the start
	%time_si = (0:dt_s:time_s(end))';
	nt      = round(time_s(end)/dt_s);
	% Note: + 1 to circumvent dfm bug that acesses values beyond end of simulation period
	time_si = (0:nt+1)*(time_s(end)/nt);

	% shape preserving cubic interpolation
	fdx = isfinite(s.val);
	vali    = interp1(time_s(fdx),s.val(fdx),time_si,'pchip',NaN);

	% extrapolate boundary values
	fdx          = isnan(vali);
	vali(fdx)    = interp1(time_si(~fdx),vali(~fdx),time_si(fdx),'nearest','extrap');

	fprintf(fid,'[forcing]\n');
	fprintf(fid,'Name               = %s_%04d\n',s.name,id);
	fprintf(fid,'Function           = timeseries\n');
	fprintf(fid,'Time-interpolation = linear\n');
	fprintf(fid,'Quantity           = time\n');
	fprintf(fid,'Unit               = seconds since %s\n',datestr(t0,'yyyy-mm-dd HH:MM:SS'));
	switch (s.type)
	case {'discharge'}
		fprintf(fid,'Quantity           = dischargebnd\n');
		fprintf(fid,'Unit               = m³/s\n');
	case {'waterlevel'}
		fprintf(fid,'Quantity           = waterlevelbnd\n');
		fprintf(fid,'Unit               = m\n');
	otherwise
		error('not yet implemented');
	end
	% minus sign is for left justification
	fprintf(fid,'%-9d %-9g\n',[round(rvec(time_si));rvec(vali)]);
	fprintf(fid,'\n');

	fclose(fid);
end % put

