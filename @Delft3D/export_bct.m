% Mon 11 Jun 18:02:49 CEST 2018
% TODO use itdate and t0 from mdf
function export_bct(obj,filename,mode)
	bct     = obj.bct;
	if (~isempty(bct))
		itdate  = obj.itdate;
		bcname_ = filename;
	
		fid     = fopen(bcname_,mode);
		if (fid <= 0)
			error('Unable to open file\n');
		end
	
		for bdx = 1:length(bct)	
		if (~isfield(bct(bdx),'t0') || isempty(bct(bdx).t0))
			bct(bdx).t0 = bct(bdx).time(1);
		end
	
		% convert days to seconds
		dt_m   = Constant.MINUTES_PER_DAY*bct(bdx).dt_d;
		time_m = Constant.MINUTES_PER_DAY*(bct(bdx).time-bct(bdx).t0);
	
		% interpolate values to time slots
		% do not subtract start time here, otherwise series is truncated at the end
		% if there is a gap at the start
		%time_mi = (0:dt_m:time_m(end))';
		nt      = round(time_m(end)/dt_m);
	
		% Note: + 1 to circumvent dfm bug that acesses values beyond end of simulation period
		time_mi = (0:nt+1)*(time_m(end)/nt);
	
		% shape preserving cubic interpolation
		fdx  = isfinite(bct(bdx).val);
		vali = interp1(time_m(fdx),bct(bdx).val(fdx),time_mi,'pchip',NaN);
	
		% extrapolate boundary values
		fdx          = isnan(vali);
		vali(fdx)    = interp1(time_mi(~fdx),vali(~fdx),time_mi(fdx),'nearest','extrap');
	
		% header
		fprintf(fid,'table-name           ''Boundary Section : %d''\n',bdx);
		fprintf(fid,'contents             ''Uniform             ''\n');
		%fprintf(fid,'location             ''(%d,%d)..(%d,%d)    ''\n',bct(idx).id+1);
		fprintf(fid,'location             ''%-20s''\n',bct(bdx).location);
		fprintf(fid,'time-function        ''non-equidistant''\n');
		fprintf(fid,['reference-time       ',datestr(itdate,'yyyymmdd'),'\n']);
		fprintf(fid,'time-unit            ''minutes''\n');
		fprintf(fid,'interpolation        ''linear''\n');
		fprintf(fid,'parameter            ''time                ''                     unit ''[min]''\n');
	
		switch (lower(bct(bdx).type))
		case {'discharge'}
			fprintf(fid,'parameter            ''total discharge (t)  end A''               unit ''[m3/s]''\n');
			fprintf(fid,'parameter            ''total discharge (t)  end B''               unit ''[m3/s]''\n');
		case {'waterlevel'}
			fprintf(fid,'parameter            ''water elevation (z)  end A''               unit ''[m]''\n');
			fprintf(fid,'parameter            ''water elevation (z)  end B''               unit ''[m]''\n');
		case {'current'}
			fprintf(fid,'parameter            ''current         (c)  end A''               unit ''[m/s]\n');
			fprintf(fid,'parameter            ''current         (c)  end B''               unit ''[m/s]\n');
		otherwise
			error('not yet implemented');
		end
		fprintf(fid,'records-in-table     %d\n',length(time_mi));
	
		% minus sign is for left justification
		fprintf(fid,'%-9e %-9e %-9e\n',[round(rvec(time_mi));rvec(vali);rvec(vali)]);
	
		end % for bdx
	
	
		fclose(fid);
	end % if ~isempty(bct)
end % export_bct

