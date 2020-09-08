% Wed 26 Feb 12:12:53 +08 2020
% function [gsd_,obj] = set_fractions(obj,d_mm,p)
function [gsd_,obj] = set_fractions(obj,d_mm,p)
	if (isempty(d_mm))
		gsd_ = [];
	else
		gsd_ = struct();
	end

	for idx=1:length(d_mm)
		idx_ = idx;
		%if (pp(idx,1) ~= 0)
			% name
			%idx_ = pp(idx,2);
			gsd_(idx_).field  = sprintf('Namc%d',idx); %pp(idx,2)); 
			c0field           = sprintf('C0%d',idx); %pp(idx,2)); 
			gsd_(idx_).SedDia = 1e-3*d_mm(idx);
			gsd_(idx_).p      = p(idx);
			% value
			if (d_mm(idx)<=2)
				% TODO reduce rounding and take name to bcc
				gsd_(idx_).Name  = sprintf('#Sediment Sand %4dum#',roundn(d_mm(idx)*1000,2));
			else
				gsd_(idx_).Name  = sprintf('#Sediment Gravel %2dmm#',round(1e2*d_mm(idx)));
			end
			obj.mdf.set(gsd_(idx_).field, gsd_(idx_).Name);
			obj.mdf.set(c0field, 0);
			%obj.mdf.dat.(gsd_(idx_).field) = gsd_(idx_).Name;
		%end
	end % for
	while (1)
		idx=idx+1;
		b = true;
		field =  sprintf('Namc%d',idx);
		if (isfield(obj.mdf.mdf.dat,field))
			obj.mdf.mdf.dat = rmfield(obj.mdf.mdf.dat,field);
			b = false;
		end
		c0field           = sprintf('C0%d',idx); %pp(idx,2)); 
		if (isfield(obj.mdf.mdf.dat,c0field))
			obj.mdf.mdf.dat = rmfield(obj.mdf.mdf.dat,c0field);
			b = false;
		end
		if (b)
			break;
		end
	end

	obj.sed.set_gsd(gsd_);
	% TODO delete surplus fractions
%	for idx=sum(pp(:,1)>0)+1:length(dc)
%			field = sprintf('Namc%d',idx) 
%			mdf.mdf.dat=rmfield(mdf.mdf.dat,field);
%	end
end

