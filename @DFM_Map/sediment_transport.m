% Fri 27 Jan 15:36:18 CET 2017

function [Qs] = sediment_transport(obj,varargin)
%	p = 2;
	U = obj.velocity_1d(varargin{:});
	Q = obj.discharge_1d(varargin{:});
	[void void2 H] = obj.waterlevel(varargin{:});
	% Qs = Q.*(U.^p);

	% grain size [mm]
	% TODO make argument
	%d_mm = 0.25; % 0.25mm
	d50_mm = obj.grain_size(varargin{1:2});
%	d50_mm = repmat(d50_mm,1,size(U,2));

	% Chezy coefficient (TODO, get from model)
	C = obj.roughness(varargin{1:2});
%	C = repmat(C,1,size(U,2));

	% there is no direct way to query width
	W = (Q./(U.*H));
	% sometimes sign(U) ~= sign(Q), catch this here
	W = abs(W);

	%[Qs] = sediment_transport_eh(C,d,U,W)
	[Qs] = -total_transport_engelund_hansen(C,d50_mm,U,[],W);
	%[Qs] = total_transport_bagnold(C,d50_mm,U,[],W);
end

