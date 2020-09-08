% Tue 10 Mar 11:53:53 +08 2020
% here, diameter is given in d3d unit, m!
function obj = set_gsd(obj,gsd_)
	% TODO no magic data
	hsed = 50;
% clear old data
	obj.dat.Sediment = [];
	for idx=1:length(gsd_) %length(f_C)
		% copy template
		%obj.dat.Sediment(idx)        = sed.dat.Sediment(1);
		obj.dat.Sediment(idx).Name   = gsd_(idx).Name;
		obj.dat.Sediment(idx).SedTyp = 'sand'; %                          Must be "sand", "mud" or "bedload"
		obj.dat.Sediment(idx).RhoSol = '2.6500000e+003      [kg/m3]  Specific density';
		obj.dat.Sediment(idx).SedDia = sprintf('%e',gsd_(idx).SedDia);
		%obj.dat.SedDia = 1.500000e-04
		obj.dat.Sediment(idx).CDryB   = '1.6000000e+003      [kg/m3]  Dry bed density';
		%obj.dat.IniSedThick(idx)     = 1.000000e+01
		p  = gsd_(idx).p;
		h_ = hsed*p/sum([gsd_.p]); % TODO, why not gsd_.p ?
		obj.dat.Sediment(idx).IniSedThick = sprintf('%e',h_); 
		obj.dat.Sediment(idx).FacDSS = '1.0000000e+000      [-]      FacDss * SedDia = Initial suspended sediment diameter. Range [0.6 - 1.0]';
		%hsed*q*(1-p)/(1 - q));
	end
end

