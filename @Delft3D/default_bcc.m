% Mon  7 Sep 11:43:33 +08 2020
% TODO bcc.sal, bcc.sed
function default_bcc(obj,sediment,salinity,dt_d)
	sub1 = strtrim(obj.mdf.mdf.dat.Sub1);
	sub2 = strtrim(obj.mdf.mdf.dat.Sub2);
	if (length(sub1)>0 && sub1(1) == '#')
		sub1 = sub1(2:end);
	end
	if (length(sub2)>0 && sub2(1) == '#')
		sub2 = sub2(2:end);
	end
	if (    ((length(sub1)<1) || (sub1(1) ~= 'S')) ...
	     && ((length(sub2)<2) || (sub2(2) ~= 'C')) ...
	   )
		obj.mdf.mdf.dat.FilbcC = '';
	end
	if (    (length(sub1)>1) && (sub1(1) == 'S')) 
		% salinity
		obj.bcc_sal = [];
		Tstop = str2num(obj.mdf.mdf.dat.Tstop);
		dt_d = min(dt_d,Tstop/1440);
		time = [0:dt_d:Tstop/1440];
		nt = length(time);
		for idx=1:length(obj.bnd)
			obj.bcc_sal(idx).location = obj.bnd(idx).name;
			obj.bcc_sal(idx).time = time;
			% TODO T0
			if (nargin()<2 || isempty(salinity))
				obj.bcc_sal(idx).val  = zeros(nt,nc);
			else
				obj.bcc_sal(idx).val = repmat(rvec([salinity.s0]),nt,1);
			end
			obj.bcc_sal(idx).dt_d = dt_d;
		end % for idx
	end
	if (length(sub2)<2 || (sub2(2) ~= 'C'))
		obj.mdf.mdf.dat.Filsed = '';
		obj.mdf.mdf.dat.Filmor = '';
		obj.bcc = [];
	else
	gsd = obj.sed.dat.Sediment;
	nc = length(gsd);
	% note: not declared as struct, as otherwise non-empty
	obj.bcc             = [];
	Tstop = str2num(obj.mdf.mdf.dat.Tstop);
%	for cdx=1:length(gdx)
	dt_d = min(dt_d,Tstop/1440);
	time = [0:dt_d:Tstop/1440];
	nt = length(time);
	for idx=1:length(obj.bnd)
		obj.bcc(idx).location = obj.bnd(idx).name;
		obj.bcc(idx).time = time;
		% TODO T0
		if (nargin()<2 || isempty(sediment))
			obj.bcc(idx).val  = zeros(nt,nc);
		else
			obj.bcc(idx).val = repmat(rvec([sediment.c0]),nt,1);
		end
		obj.bcc(idx).dt_d = dt_d;
	end
	end
end % default_bcc

