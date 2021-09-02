% Tue  8 Sep 14:32:04 +08 2020
% since the boundaries are written interleaved and not consecutively,
% append-mode is not possible
% frequencies are silently assumed to be integer multiples of the base
% frequency omega
function write_bch(obj,filename)
	bch   = obj.bch;
	fmt   = ' %+0.8E';
	fmts  = '%16s';

	if (~isempty(bch))
		fid     = fopen(filename,'w');
		if (fid <= 0)
			error(['Unable to open file "', filename, '" for writing.\n']);
		end

	omega = obj.bch(1,2).omega;

	nf = size(bch,2);
	nb = size(bch,1);

	% convert frequency from rad/s into deg/h
	%pf = (360/(2*pi))*(1/3600);
	pf = (360/(2*pi))*3600;

	% frequency header
	for idx=1:nf
		if (isfield(bch(1,idx),'omega') & ~isempty(bch(1,idx).omega))
			fprintf(fid,fmt,pf*bch(1,idx).omega);
		else
			fprintf(fid,fmt,(idx-1)*pf*omega);
		end
	end
	fprintf(fid,'\n\n');

	% write amplitudes for each boundary twice
	% (each end-point of the boundary)
	for edx=1:2
	   % for each boundary
	   for bdx=1:nb
		% for each frequency
		for k=1:nf
			% amplitude
			if (1==k)
				a = bch(bdx,k).rhs;
			else
				a = abs(bch(bdx,k).rhs);
			end
			fprintf(fid,fmt,a);
		end % for k
		fprintf(fid,'\n');
	   end % for bdx
	end % for edx
	fprintf(fid,'\n');

	% write phase for each boundary twice
	% (each end-point of the boundary)
	for edx=1:2
	   % for each boundary
	   for bdx=1:nb
	   	% placeholder for phase of zero-frequency component
	        fprintf(fid,fmts,' ');
		% for each frequency
		for k=2:nf
			% amplitude
			phase = angle(bch(bdx,k).rhs);
			pf    = 360/(2*pi);
			dphi  = -180;
			fprintf(fid,fmt,pf*phase+dphi);
		end % for k
		fprintf(fid,'\n');
	   end % for bdx
	end % for edx

	fclose(fid);
	end % ~isempty(bch)
end % write_bch

