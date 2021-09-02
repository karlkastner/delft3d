% Wed 24 Feb 09:51:53 CET 2021
% TODO backscatter object
function [bs,ibs,out] = backscatter(obj, f_Hz, beamangle_rad, varargin)
	if (isempty(obj.bs_))
	% frequency
	% f_Hz         = obj.f_Hz;

	% grain size in mm
	d_mm  = obj.gsd.d;

	% distance to surface
	dz = obj.dz(varargin{:});
	%range = obj.range(varargin{:});

	% range to transducer
	drange = dz/cos(beamangle_rad);

	% sediment concentration per fraction
	c = obj.sediment_concentration(varargin{:});

	n = size(c);
	nt = n(1); 
	nx = n(2); 
	ny = n(3); 
	nz = n(4); 
	nk = n(5);

	% reorganize variables into ensembles

	% shift time and fraction to the first to dimensions
	c     = permute(c,[4,5,1,2,3]);
	drange = permute(drange,[4,1,2,3]);
	% flatten last dimensions [ensemble = t,x,y]
	c     = reshape(c,[nz,nk,nt*nx*ny]);
	drange = reshape(drange,[nz,nt*nx*ny]);
	% reorder [z : ensemble : fraction]
	c     = permute(c,[1,3,2]);

	[bs,ibs,out] = simulate_backscatter(drange,d_mm,c,f_Hz);

	% reorganize variables into space-time
	bs  = reshape(bs,[nz,nt,nx,ny]);
	bs  = permute(bs,[2,3,4,1]);
	ibs = reshape(ibs,[nz,nt,nx,ny]);
	ibs = permute(ibs,[2,3,4,1]);
	
	%if (nargout()>2)
		out.bs0 = reshape(out.bs0,[nz,nt,nx,ny]);
		out.bs0 = permute(out.bs0,[2,3,4,1]);
		out.as  = reshape(out.as, [nz,nt,nx,ny]);
		out.as  = permute(out.as, [2,3,4,1]);
		out.ia  = reshape(out.ia, [nz,nt,nx,ny]);
		out.ia  = permute(out.ia, [2,3,4,1]);
		out.ask = reshape(out.ask,[nz,nt,nx,ny,nk]);
		out.ask = permute(out.ask,[2,3,4,1,5]);
	%end

	obj.bs_  = bs;
	obj.ibs_ = ibs;
	obj.bsout = out;
	else
		bs = obj.bs_;
		ibs = obj.ibs_;
	end
end

