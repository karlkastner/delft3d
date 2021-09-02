% Sat 13 Feb 13:58:02 CET 2021
function export_mft(obj,filename)
    bct     = obj.mft;
    if (~isempty(mft))
        itdate  = obj.itdate;
    
        fid     = fopen(filename,'w');
        if (fid <= 0)
            error('Unable to open file\n');
        end
   
	time_mi = 1440*mft.time;
	vali    = mft.val;
 
	% header
%	fprintf(fid,'table-name           ''Boundary Section : %d''\n',bdx);
%	fprintf(fid,'contents             ''Uniform             ''\n');
%	fprintf(fid,'location             ''%-20s''\n', bcc(bdx).location);
	fprintf(fid,'time-function        ''non-equidistant''\n');
	fprintf(fid,['reference-time       ',datestr(itdate,'yyyymmdd'),'\n']);
	fprintf(fid,'time-unit            ''minutes''\n');
	fprintf(fid,'interpolation        ''linear''\n');
	fprintf(fid,'extrapolation	  ''constant''\n');
	fprintf(fid,'parameter            ''time                ''                     unit ''[min]''\n');
	fprintf(fid,'parameter            ''%-20s end A uniform''       unit ''[kg/m3]''\n',gsd(idx).Name(2:end-1));
	fprintf(fid,'parameter            ''parameter	''MorFac' unit ''[-]''\n');
%	fprintf(fid,'records-in-table     %d\n',length(time_mi));

	% minus sign is for left justification
	fprintf(fid,'%-9e %-9e\n',[round(rvec(time_mi));rvec(vali)]);

	end % for idx
	end % for bdx

	fclose(fid);
	end
end % export_mft

