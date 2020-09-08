% Fri 16 Jun 19:56:47 CEST 2017
function [Delta Lambda obj] = bedform_dimension(obj,varargin)
	U = obj.velocity_1d(varargin{:});
	%Q = obj.discharge_1d(varargin{:});
	[void void2 H] = obj.waterlevel(varargin{:});
	d50 = obj.grain_size(varargin{1:2});

	d90 = 2*d50;
	sd  = 1;

	% determine equilibrium bed form height
%	U_rms         = (U);
%	H_bar         = (H);
	T             = transport_stage_rijn(d50, d90, H, abs(U));
	T_bar         = mean(T,2);
	H_bar         = mean(H,2);
	[Delta Lambda] = bed_form_dimension_rijn(H_bar,d50,T_bar);
end
