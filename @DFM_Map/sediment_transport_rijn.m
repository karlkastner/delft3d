% Fri 27 Jan 15:36:18 CET 2017

function [Qs] = sediment_transport(obj,varargin)
	U = obj.velocity_1d(varargin{:});
	Q = obj.discharge_1d(varargin{:});
	[void void2 H] = obj.waterlevel(varargin{:});
	% Qs = Q.*(U.^p);

	% grain size [mm]
	% TODO make argument
	%d_mm = 0.25; % 0.25mm
	d50 = obj.grain_size(varargin{1:2});
%	d50_mm = repmat(d50_mm,1,size(U,2));

	% Chezy coefficient (TODO, get from model)
	C = obj.roughness(varargin{1:2});
%	C = repmat(C,1,size(U,2));

	W = (Q./(U.*H));
	% sometimes sign(Q) ~= sign(U), catch this here
	W = abs(W);

	% TODO, quick fix for 90th-percentile and sd of grain size distribution
	d90 = 2*d50;
	sd  = 1;

	% determine equilibrium bed form height
%	U_rms         = rms(U,2);
	H_bar         = mean(H,2);
	T             = transport_stage_rijn(d50, d90, H, abs(U));
	T_bar         = mean(T,2);
	[dune_height] = bed_form_dimension_rijn(H_bar,d50,T_bar);

	[Qs] = -total_transport_rijn(C,d50,d90,sd,U,H,W,dune_height);

	%[Qs] = sediment_transport_eh(C,d,U,W)
	%[Qs] = -total_transport_engelund_hansen(C,d50_mm,U,H,W);
	%[Qs] = total_transport_bagnold(C,d50_mm,U,[],W);
end

