% Thu  3 Sep 12:15:57 +08 2020
function write_ini(obj,filename)	
	
	ini = obj.ini;

	if (~isempty(ini))

	fid  = fopen(filename,'w');
	if (fid <= 0)
		error('cannot open file for writing');
	end

	zs = ini.zs;
%	zs = zs';
	
	% dummy
	dval = 999;
	zs(:,end+1) = zs(:,end);	
	zs(end+1,:) = zs(end,:);

	% write water level
	write_(zs);

	% write other variables
	% u,v,sal,temp,sediment
	dummy = zeros(size(zs));
	for kdx=1:5
		write_(dummy);
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

