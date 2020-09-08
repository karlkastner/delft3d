% Di 16. Feb 20:18:40 CET 2016
% Karl Kastner, Berlin
%
% input:
% ofilename
% s : structure with field
%	name : name (same for all elements)
%       type : {discharge, waterlevel}
% 	x,y  : coordinates
%	time : vector
%	val  : vector
% t0 : [days since 00/00/00] reference time of simulation
% dt : [days]                time step in output file
%
% TODO : individual files per boundary
% TODO : implement read_bc
% TODO : allow to copy files
% 
function export_bc(folder,s,t0,dt)

	%base    = [dirname(ofilename),filesep,basename(ofilename)];
	%if (nargin()<2)
	%	base    = 'boundary';
	%end
%	pliname = [folder,filesep,base,'.pli'];
	if (~isempty(folder))
		folder = [folder,filesep];
	end

	%bcname  = [folder,base,'.bc'];
	
	% generate pli file
	% NOTE: each boundary requires an individual pli-file
	% as of 2018/01 dfm gui and cli silently fails to apply boundaries
	% that are stored in the same pli-file

	% TODO combine with export pli
	for idx=1:length(s)
		pliname_ = [folder,s(idx).name,'.pli'];

		fid = fopen(pliname_,'w');
		if (fid <= 0)
			error(['Unable to open file ',pliname_]);
		end
		% TODO variable number of points
		nrow = 2;
		ncol = 2;
		k = 1;
		% for idx=1:length(s)
		fprintf(fid,'%s\n',s(idx).name);
		fprintf(fid,'%d\t%d\n',nrow,ncol);
		for jdx=1:length(s(idx).x)
			% was s(1).name
			fprintf(fid,'%15E %15E %s_%04d\n',s(idx).x(jdx),s(idx).y(jdx),s(idx).name,k);
		end % for jdx
		fclose(fid);
	end % for idx
if (0)
	fid = fopen(pliname,'w');
	fprintf(fid,'%s\n',s(1).name);
	fprintf(fid,'%d\t%d\n',nrow,ncol);
	for idx=1:nrow
		for jdx=1:length(s(idx).x)
			% was s(1).name
			fprintf(fid,'%15E %15E %s_%04d\n',s(idx).x(jdx),s(idx).y(jdx),s(idx).name,idx);
		end
	end
	fclose(fid);
end

	% generate bc file
	for idx=1:length(s)
		export_bc_(folder,s(idx),t0,dt,k);
	end

	% generate FlowFM_bnd.ext
	extname = [folder,'FlowFM_bnd.ext'];
	fid = fopen(extname,'w');
	if (fid <= 0)
		error('Unable to open file\n');
	end
	
	% bcname_  = [base,'.bc'];
	for idx=1:length(s)
		pliname_ = [s(idx).name,'.pli'];
		bcname_  = [s(idx).name,'.bc'];
		%pliname_ = [folder,filesep,s(idx).name,'.pli'];
		fprintf(fid,'[boundary]\n');
		switch (s(idx).type)
		case {'discharge'}
			fprintf(fid,'quantity=dischargebnd\n');
		case {'waterlevel'}
			fprintf(fid,'quantity=waterlevelbnd\n');
		otherwise
			error('here');
		end
		fprintf(fid,'locationfile=%s\n',pliname_);
		fprintf(fid,'forcingfile=%s\n',bcname_);
		fprintf(fid,'return_time=0.0000000e+000\n');
		fprintf(fid,'\n');
	end
	fclose(fid);

end % eport_bc


