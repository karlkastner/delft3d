% Tue 10 Mar 11:53:53 +08 2020
% here, diameter is given in d3d unit, m!
function obj = set_gsd(obj,gsd_,hsed,T_C)
	% TODO no magic data
	%hsed = 50;
	% clear old data
	obj.dat.Sediment = [];
	for idx=1:length(gsd_) %length(f_C)
		if (isempty(gsd_(idx).SedTyp))
			gsd_(idx).SedTyp = 'sand';
		end
		% copy template
		%obj.dat.Sediment(idx)        = sed.dat.Sediment(1);
		obj.dat.Sediment(idx).Name   = gsd_(idx).Name;
		% Must be "sand", "mud" or "bedload"
		obj.dat.Sediment(idx).SedTyp = gsd_(idx).SedTyp;
		obj.dat.Sediment(idx).RhoSol = '2.6500000e+003      [kg/m3]  Specific density';
		switch(lower(gsd_(idx).SedTyp))
		case {'sand','bedload'}
			obj.dat.Sediment(idx).SedDia = sprintf('%e [m]',gsd_(idx).SedDia);
		case{'mud'}
			obj.dat.Sediment(idx).SalMax = sprintf('%e [ppt]',0);
			ws = settling_velocity(gsd_(idx).SedDia,T_C);		
			obj.dat.Sediment(idx).WS0    = sprintf('%e [m/s]', ws);
			obj.dat.Sediment(idx).WSM    = sprintf('%e [m/s]', ws);
			obj.dat.Sediment(idx).TcrSed = sprintf('%e [N/m2]', gsd_(idx).TcrSed);
			obj.dat.Sediment(idx).TcrEro = sprintf('%e [N/m2]', gsd_(idx).TcrEro);
			obj.dat.Sediment(idx).EroPar = sprintf('%e [kg/m2/s]', gsd_(idx).EroPar);
		otherwise
			error('not yet implemented');
		end
		%obj.dat.SedDia = 1.500000e-04
		obj.dat.Sediment(idx).CDryB   = '1.6000000e+003      [kg/m3]  Dry bed density';
		%obj.dat.IniSedThick(idx)     = 1.000000e+01
		p  = gsd_(idx).p;
		h_ = hsed*p/sum([gsd_.p]); % TODO, why not gsd_.p ?
		obj.dat.Sediment(idx).IniSedThick = sprintf('%e [m]',h_); 
		obj.dat.Sediment(idx).FacDSS = '1.0000000e+000      [-]      FacDss * SedDia = Initial suspended sediment diameter. Range [0.6 - 1.0]';
		%hsed*q*(1-p)/(1 - q));
	end
end

