% Wed 26 Feb 12:12:53 +08 2020
% function [gsd_,obj] = set_fractions(obj,d_mm,p)
function [gsd_,obj] = set_fractions(obj,sediment,salinity,hsed,T_C)
	if (~isempty(salinity))
		% remove surplus fractions
		S0 = 0;
		obj.mdf.mdf.dat = setfield_behind(obj.mdf.mdf.dat, 'S0', num2str(S0), 'Tstop')
%		obj.mdf.mdf.dat = setfield_behind(obj.mdf.mdf.dat, 'S0', num2str(S0), 'Sub2')
	else
		% no salinity modelled
		% remove initial salinity concentration
		if (isfield(obj.mdf.mdf.dat,'S0'))
			obj.mdf.mdf.dat = rmfield(obj.mdf.mdf.dat,'S0');
			b = false;
		end
		
	end
	idx = [];
	sub2 = strtrim(obj.mdf.mdf.dat.Sub2);
	if (sub2(2) == 'C')
	if (isempty(sediment))
		gsd_ = [];
	else
		gsd_ = struct();
	end
	for idx=1:length(sediment)
		idx_ = idx;
		% fraction name	
		gsd_(idx_).field   = sprintf('Namc%d',idx);
		% initial condition field
		gsd_(idx_).c0field = sprintf('C%02d',idx);
		% initial condition value
		gsd_(idx).c0       = num2str(sediment(idx).c0);
		% diameter, convert mm to m
		gsd_(idx_).SedDia  = 1e-3*sediment(idx).d_mm;
		% proportion in bed
		gsd_(idx_).p       = sediment(idx).p;
		% sediment type (sand, mud, or bedload)
		gsd_(idx).SedTyp   = sediment(idx).SedTyp;
		if (strcmp(lower(sediment(idx).SedTyp),'mud'))
			gsd_(idx).TcrSed   = sediment(idx).TcrSed;
			gsd_(idx).TcrEro   = sediment(idx).TcrEro;
			gsd_(idx).EroPar   = sediment(idx).EroPar;
		end
		% value
		switch (lower(gsd_(idx).SedTyp))
		case {'sand'}
		%if (d_mm(idx)<=2)
			% TODO take name to bcc
			gsd_(idx_).Name  = sprintf('#Sediment Sand %4dum#',round(1e3*sediment(idx).d_mm));
			%gsd_(idx_).Name  = sprintf('#Sediment Sand %4dum#',roundn(1e3*d_mm(idx),2));
		case {'mud'}
			gsd_(idx_).Name  = sprintf('#Sediment Mud  %4dum#',round(1e3*sediment(idx).d_mm));
		case {'gravel','bedload'}
			gsd_(idx_).Name  = sprintf('#Sediment Gravel %3gmm#',roundn(sediment(idx).d_mm,3));
		otherwise
			error('');
		end
		if (1 == idx)
			obj.mdf.set(gsd_(idx_).field, gsd_(idx_).Name);
			obj.mdf.set(gsd_(idx).c0field, gsd_(idx_).c0);
		else	
			obj.mdf.mdf.dat = setfield_behind(obj.mdf.mdf.dat,gsd_(idx_).field, gsd_(idx_).Name, gsd_(idx_-1).field)
			obj.mdf.mdf.dat = setfield_behind(obj.mdf.mdf.dat,gsd_(idx).c0field, gsd_(idx_).c0, gsd_(idx_-1).c0field)
		end
	end % for
	obj.sed.set_gsd(gsd_,hsed,T_C);
	else
		obj.sed.dat.Sediment = []; 
	end
	if (isempty(idx))
		idx = 0;
	end
	while (1)
		% remove surplus fractions
		idx   = idx+1;
		b     = true;
		field =  sprintf('Namc%d',idx);
		if (isfield(obj.mdf.mdf.dat,field))
			obj.mdf.mdf.dat = rmfield(obj.mdf.mdf.dat,field);
			b = false;
		end
		c0field = sprintf('C%02d',idx);
		if (isfield(obj.mdf.mdf.dat,c0field))
			obj.mdf.mdf.dat = rmfield(obj.mdf.mdf.dat,c0field);
			b = false;
		end
		if (b)
			break;
		end
	end
end % set_fractions

