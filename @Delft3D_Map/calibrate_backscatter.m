% Wed 24 Feb 12:52:21 CET 2021
function [param,cp,stat] = calibrate_backscatter(obj, beamangle_rad, mode, varargin)

	% grain size in mm
	gsd    = obj.gsd;
	d_mm   = obj.gsd(1,:);

	% distance to surface
	range  = obj.range(varargin{:});

	% range to transducer
	range  = range/cos(beamangle_rad);

	weight = obj.volume(varargin{:});

	% sediment concentration per fraction
	c = obj.sediment_concentration(varargin{:});
	
	% backscatter and integral along range
	bs  = obj.bs_;
	ibs = obj.ibs_;

	% total concentration
	c = sum(c,5);

%	n  = size(c);
%	nt = n(1); 
%	nx = n(2); 
%	ny = n(3); 
%	nz = n(4); 

	% reorganize variables into ensembles

%	% shift time and fraction to the first to dimensions
%%	c  = permute( c,[4,1,2,3]);
%	range = permute(range,[4,1,2,3]);
%	bs  = permute( c,[4,1,2,3]);
%	bs  = permute( c,[4,1,2,3]);
	% flatten last dimensions [ensemble = t,x,y]
%	c  = reshape( c,[nz,nt*nx*ny]);
%	dr = reshape(dr,[nz,nt*nx*ny]);

	[param,cp,stat] = calibrate_backscatter(range,c,bs,ibs,weight,mode);

	obj.bsparam = param;
	obj.cp      = cp;
end

