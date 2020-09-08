% Tue  8 Sep 14:32:04 +08 2020
% since the boundaries are written interleaved and not consecutively,
% append-mode is not possible
% frequencies are silently assumed to be integer multiples of the base
% frequency omega
function write_bch(obj,filename)
	bch   = obj.bch;

	if (~isempty(bch))
		fid     = fopen(filename,'w');
		if (fid <= 0)
			error(['Unable to open file "', filename, '" for writing.\n']);
		end

	omega = obj.bch(1,1).omega;

	nf = size(bch,2);
	nb = size(bch,1);

	% convert frequency from rad/s into deg/h
	pf = (360/(2*pi))*(1/3600);

	% frequency header
	for idx=1:nf
		fprintf(' %-1.13e',(idx-1)*pf*omega);
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
			a = abs(bch(bdx,kdx).rhs));
			fprintf(fid,fmt,a);
		end % for k
	   end % for bdx
	end % for edx

	% write phase for each boundary twice
	% (each end-point of the boundary)
	for edx=1:2
	   % placeholder for phase of zero-frequency component
	   fprintf(fid,'%14s',' ');
	   % for each boundary
	   for bdx=2:nb
		% for each frequency
		for k=1:nf
			% amplitude
			phase = bch(bdx,kdx).rhs);
			fprintf(fid,fmt,pf*phase);
		end % for k
	   end % for bdx
	end % for edx

	fclose(fid);
	end % ~isempty(bch)
end % write_bch

