% Thu  3 Sep 12:15:57 +08 2020
function write_ini(obj,filename)	
	
	ini = obj.ini;

	if (~isempty(ini))

	fid  = fopen(filename,'w');
	if (fid <= 0)
		error('cannot open file for writing');
	end

	nn=str2num(obj.mdf.mdf.dat.MNKmax);
	nc = length(obj.sed.dat.Sediment);

	% dummy
	dval = 999;

	if (isfield(ini,'Zeta0'))
	if (isnumeric(ini.Zeta0))
			zs = repmat(ini.Zeta0,size(obj.mesh.X));
	else
		zs = feval(ini.Zeta0,obj.mesh.X,obj.mesh.Y);

%		zs = z00*ones(size(zb));
%		if (abs(Q0)>0)
%			zs = max(zs,zb+h0);
%		end
	%	zs = [mid(zs(1:end-),zs(end)];
		%zs = [2*zs(:,1)-zs(:,2),zs(:,1:end-1)];
		zs = [2*zs(:,1)-zs(:,2),zs]; %;(:,1:end-1)];
		zs = mid(zs')';
		%zs = [zs,2*zs(:,end)-zs(:,end-1)];
	end
	end
	zs(:,end+1) = zs(:,end);	
	zs(end+1,:) = zs(end,:);

	if (isfield(ini,'u0'))
		if (isnumeric(ini.u0))
			u0 = repmat(ini.u0,size(obj.mesh.X));
		else
			u0 = feval(ini.u0,obj.mesh.X,obj.mesh.Y);
		end
		u0 = [2*u0(:,1)-u0(:,2),u0];
		u0 = mid(u0')';
	end
	u0(:,end+1) = u0(:,end);	
	u0(end+1,:) = u0(end,:);

	% write water level
	write_(zs);

	% write velocity for each layer
	for idx=1:nn(3)
		write_(u0);
	end

	% write v-velocity
	dummy = zeros(size(zs));
	for kdx=1:nn(3)
		write_(dummy);
	end

	% sal,temp
	% TODO check if process are on
if (0)
	for kdx=1:2*nn(3)
		write_(dummy);
	end
end

	% sediment concentration
	for kdx=1:nc
		field = sprintf('C%02d',kdx);
		c0 = obj.mdf.get(field);
		c0 = repmat(c0,size(obj.mesh.X));
		c0 = [2*c0(:,1)-c0(:,2),c0];
		c0 = mid(c0')';
		c0(:,end+1) = c0(:,end);	
		c0(end+1,:) = c0(end,:);
	for idx=1:nn(3)
		write_(c0);
	end
	end
	% salinity
if (0)
	sub1 = strtrim(obj.mdf.mdf.dat.Sub1);
	if (    (length(sub1)>1) && (sub1(1) == 'S'))
		S0 = 0;
		write_(S0);
	end
end

	fclose(fid);

	end % write_ini

	function write_(val)
		for idx=1:size(val,1)
		 for jdx=1:size(val,2)
			fprintf(fid,'  % .7E',val(idx,jdx));
		 end % for jdx
		 fprintf(fid,'\n');
		end % for jdx
	end
end % write_ini

