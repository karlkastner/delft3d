% Mon  5 Nov 10:21:52 CET 2018
% Wed 18 Jul 14:06:41 CEST 2018
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

classdef Delft3D_Map < handle
	properties
		% map file pointer
		map
		gsd
		% reading options
		vsopt = 'quiet';
		% mesh
		smesh
		% morphological time scale
		tmor_
		time_

		% aux vars
		nsed_
		nul_
		nz_
		S_
		N_
		%X_
		%Y_
		Xc_
		Yc_
		u3_
		v3_
		w3_
		sediment_concentration_
		salinity_concentration_
		u2_
		v2_
		w2_
		qv_
		qu_
		ssuk_;
		ssvk_;
		pssv_;
		dssv_;
		sbuk_;
		sbvk_;
		ssu_;
		ssv_;
		sbu_;
		sbv_;
		volume_;
		ustar_;
		dunelength_;
		duneheight_;
		viscosity_uv_;
		Cu_;
		nu_;
		bs_;
		bsout;
		ibs_;
		zs_;
		zb_;
		settling_velocity_;
		reference_concentration_;
		equilibrium_concentration_;
		nanval = -999;
		area_ = [];
		bsparam;
		cp;
		morfac_;
	end
	methods
	function obj = Delft3D_Map()
	end
	function init(obj,folder_)
		% clear
		% TODO, reset tmp vars
		obj.map   = [];
		if (strcmp(folder_(end-2:end),'dat'))
			path = folder_;
		else
		try
			path = ls([folder_,'/trim-delft3d.dat']);
			path = chomp(path);
		catch e1
			try
				path = ls([folder_,'/*/trim-delft3d.dat']);
				path_C = strsplit(path,'\n');
				path = path_C{1};
				path = chomp(path);
			catch e2
				disp(e1)
				disp(e2)
				return;
			end
		end
		end
		obj.map   = vs_use(path,obj.vsopt);
		try
			gsd = load([folder_,'/gsd.csv']);
			obj.gsd.d = gsd(1,:);
			obj.gsd.p = gsd(2,:); 
		catch e
			e
		end

		% init mesh
		obj.X();
	end
	function nz = nz(obj)
		if (~isempty(obj.nz_))
			nz = obj.nz_;
		else
			nz = vs_get(obj.map,'map-const','KMAX',obj.vsopt);
			obj.nz_ = nz;
		end
	end
	function nsed = nsed(obj)
		if (~isempty(obj.nsed_))
			nsed = obj.nsed_;
		else
			nsed = vs_get(obj.map,'map-const','LSED',obj.vsopt);
			obj.nsed_ = nsed;
		end
	end

	function nul = nul(obj,varargin)
		if (~isempty(obj.nul_))
			nul = obj.nul_;
		else
			s   = vs_disp(obj.map,'map-sed-series',varargin,'MSED',obj.vsopt);
			siz = s.SizeDim;
			nul = siz(3);
			%nul = vs_get(obj.map,'map-const','LSED',obj.vsopt);
			obj.nul_ = nul;
		end
	end

	% time step in days (matlab default unit of time)
	function dt = dt(obj)
		dt = vs_let(obj.map,'map-const','DT',obj.vsopt)/1440;
	end

	function nt = nt(obj)
		nt = length(obj.time);
	end

	function time = time(obj)
		if (isempty(obj.time_))
			% nt  = vs_let(obj.map,'map-infsed-serie','ITMAPS',obj.vsopt);
			% number of time steps
			nt  = vs_let(obj.map,'map-info-series','ITMAPC',obj.vsopt);
			time_d = obj.dt*nt;
			%time_s = vs_let(obj.map,'map-infavg-serie','ITAVGS',obj.vsopt)
			%time_d = time_s/86400;
			obj.time_      =  time_d;
		end
		time = obj.time_;
	end

	function tmor = tmor(obj)
		if (isempty(obj.tmor_))
			% t  = vs_let(obj.map,'map-infsed-serie','ITMAPS',obj.vsopt);
			obj.tmor_ = vs_let(obj.map, 'map-infsed-serie', ...
					            'MORFT', obj.vsopt);
		end
		tmor = obj.tmor_;
	end

	function [Xc,Yc] = Xc(obj)
		if (isempty(obj.Xc_))
			Xc = vs_get(obj.map,'map-const','XZ',obj.vsopt);
			Yc = vs_get(obj.map,'map-const','YZ',obj.vsopt);
			obj.Xc_ = Xc;
			obj.Yc_ = Yc;
		else
			Xc = obj.Xc_;
			Yc = obj.Yc_;		
		end
	end

	function [Yc,Xc] = Yc(obj)
		[Xc,Yc] = obj.Xc;
	end

	% TODO pass from smesh
	function [X,Y] = X(obj)
		if (isempty(obj.smesh))
			X = vs_get(obj.map,'map-const','XCOR',obj.vsopt);
			Y = vs_get(obj.map,'map-const','YCOR',obj.vsopt);
			% invalidate
			if (0)
			[Xc,Yc] = obj.Xc;
			valid   = true(size(Xc));
			valid(:,end) = false;
			v = mid(Xc(:,2:end-1),2)~=0;
			valid(:,2:end-2) = valid(:,2:end-2) & v;
%			fdx = (Xc~=0) & (Yc~=0);
%			fdx(1,:) = true; fdx(end,:) = true;
%			fdx(:,1) = true; fdx(:,end) = true;
%			fdx = fdx & (X>0);
			X(~valid) = NaN;
			Y(~valid) = NaN;
			end

			% remove last column
			X = X(1:end-1,1:end-1);
		        Y = Y(1:end-1,1:end-1);
			%fdx = (X==0) && (Y==0);
		        %X(fdx) = NaN;
		        %Y(fdx) = NaN;
			%obj.X_ = X;
			%obj.Y_ = Y;

			obj.smesh = SMesh();
			%X = obj.X;
			%Y = obj.Y;
			obj.smesh.X = X;
			obj.smesh.Y = Y;
			obj.smesh.extract_elements(); 
		else
			X = obj.smesh.X;
			Y = obj.smesh.Y;
		end
	end
	function [Y,X] = Y(obj)
		[X,Y] = obj.X;
	end
		function XX = XX(obj)
			XX = repmat(shiftdim(obj.X,-1),[length(obj.tmor),1,1]);
		end
		function YY = YY(obj)
			YY = repmat(shiftdim(obj.Y,-1),[length(obj.tmor),1,1]);
		end
		function tt = tt(obj)
			tt = repmat(shiftdim(obj.tmor),[1,size(obj.X)]);
		end
	function [S,N] = S(obj)
		if (isempty(obj.S_))
		%X    = X(1:end-1,1:end-1);
		%Y    = Y(1:end-1,1:end-1);
		[X,Y] = obj.X;
	
		% hold the zeros and NaNs
		X(isnan(X)) = 0;
		Y(isnan(Y)) = 0;
		X_ = X;
		Y_ = Y;
		for idx=2:size(X,1)
		 for jdx=1:size(X,2)
			if (0 == X_(idx,jdx) && 0 == Y_(idx,jdx))
				X_(idx,jdx) = X_(idx-1,jdx);
				Y_(idx,jdx) = Y_(idx-1,jdx);
			end
		end
		end
		S = cumsum([zeros(1,size(X,2)); hypot(diff(X_),diff(Y_))]);
		X_ = X;
		Y_ = Y;
		for idx=1:size(X,1)
		 for jdx=2:size(X,2)
			if (0 == X_(idx,jdx) && 0 == Y_(idx,jdx))
				X_(idx,jdx) = X_(idx,jdx-1);
				Y_(idx,jdx) = Y_(idx,jdx-1);
			end
		end
		end
		N = cumsum([zeros(size(X,1),1), hypot(diff(X_,[],2),diff(Y_,[],2))],2);
		obj.S_ = S;
		obj.N_ = N;
		else
			S = obj.S_;
			N = obj.N_;
		end
	end
	function [N,S] = N(obj)
		[S,N] = obj.S;
	end
	function depth = depth(obj,varargin)
		depth = obj.zs(varargin{:}) - obj.zb(varargin{:});
	end
	function ds = dsigma(obj)
		ds = vs_let(obj.map,'map-const','THICK',obj.vsopt);
	end
	function dz   = dz(obj,varargin)
		depth = max(0,obj.depth(varargin{:}));
		ds    = obj.dsigma;
		dz    = depth.*shiftdim(ds,-2);
	end
	function sigma = sigma(obj)
		sigma = 1-cumsum(mid([0,obj.dsigma]));
	end

	% distance from surface
	function range = range(obj,varargin)
		Z     = obj.Z(varargin{:});
		range = obj.zs(varargin{:}) - Z;
	end


%	function sigma = sigma_(obj)
%		sigma = 1-cumsum(([0,obj.dsigma]));
%	endi
	function Z = Z(obj,varargin)
		if (~isempty(vs_find(obj.map,'LAYER_INTERFACE')))
			Z = vs_let(obj.map,'map-series',varargin,'LAYER_INTERFACE');
			Z = 0.5*(Z(:,:,:,1:end-1)+Z(:,:,:,2:end));
		else
			depth = obj.depth(varargin);
			zb    = obj.zb(varargin);
			%depth = depth(:,:,1:end-1);
			%zb    = zb(:,:,1:end-1);
			sigma = obj.sigma;
			sigma = shiftdim(rvec(sigma),-2);
			%Z     = bsxfun(@times,depth,1-sigma);
			Z     = bsxfun(@times,depth,sigma);
			Z     = bsxfun(@plus,zb,Z);
		end
	end

	function zb = zb(obj,varargin)
		% DPS is documented as "bottom depth", but it is actually the
		% bed level
		if (isempty(obj.zb_))
		if (~isempty(vs_find(obj.map,'DPS')))
			zb     = -vs_let(obj.map,'map-sed-series',varargin,'DPS',obj.vsopt);
		else
			zb     = -vs_let(obj.map,'map-const','DPS0',obj.vsopt);
		end
			obj.zb_ = zb;
		else
			zb = obj.zb_;
		end
	end
	function zs = zs(obj,varargin)
		if (isempty(obj.zs_))
			zs     =  vs_let(obj.map,'map-series',varargin,'S1',obj.vsopt);
			obj.zs_ = zs;
		else
			zs = obj.zs_;
		end
	end
	function u3 = u3(obj,varargin)
		if (~isempty(obj.u3_))
			u3  = obj.u3_;
		else
			u3      =  vs_let(obj.map,'map-series',varargin,'U1',obj.vsopt);
			u3(u3 == obj.nanval) = NaN;
			obj.u3_ = u3;
			% set flow through closed boundary to zero, zmesh fix, where it is set incorrectly to nan
%			X = obj.X;
%			for idx=1:size(u3,2)
%			 % first
%			 if (isnan(u3(1,idx,1,1)))
%				u3(:,idx,1,:) = 0;
%			 end % if first
%			 % centre
%			 for jdx=2:size(u3,3)-1
%				if (~isnan(X(idx,jdx)) && isnan(u3(1,idx,jdx,1)) ...
%				     && ( isnan(X(idx,jdx+1)) || isnan(X(idx,jdx-1)) ) )
%					u3(:,idx,jdx,:) = 0;
%				end
%			 end % for jdx
%			 % last
%			 if (isnan(u3(1,idx,end,1)))
%				u3(:,idx,end,:) = 0;
%			 end % if last
%			end % for idx
		end % if
	end % u3
	function v3 = v3(obj,varargin)
		if (~isempty(obj.v3_))
			v3  = obj.v3_;
		else
			v3      =  vs_let(obj.map,'map-series',varargin,'V1',obj.vsopt);
			v3(v3 == obj.nanval) = NaN;
			obj.v3_ = v3;
		end
	end
	function w3 = w3(obj,varargin)
		if (~isempty(obj.w3_))
			w3  = obj.w3_;
		else
			w3      =  vs_let(obj.map,'map-series',varargin,'WPHY',obj.vsopt);
			w3(w3 == obj.nanval) = NaN;
			obj.w3_ = w3;
		end
	end

	function [ts,tn] = tau_sn(obj,varargin)
		ts = vs_let(obj.map,'map-series',varargin,'TAUKSI',obj.vsopt);
		%ts = squeeze(ts(end,:,:));
		% TODO, make this a matrix
		if (0)
		ts = ts(:,2:end-1,:);
		ts = ts(:,:,1:end-1);
		ts(:,:,1)  = ts(:,:,2);
		ts(:,:,end)= ts(:,:,end-1);
		ts = mid(ts,3);
		end
		tn = vs_let(obj.map,'map-series',varargin,'TAUETA',obj.vsopt);
		%tn = squeeze(tn(end,:,:));
		if (0)
		tn = tn(:,:,2:end-1);
		tn=tn(:,1:end-1,:);
		tn(:,1,:) = tn(:,2,:);
		tn(:,end,:)=tn(:,end-1,:);
		tn = mid(tn,2);
		end
	end

	function [tx,ty] = tau_xy(obj)
		[ts,tn] = obj.tau_sn();
		ts = shiftdim(ts,1);
		tn = shiftdim(tn,1);
		[ty,tx] = obj.smesh.vel_sn2xy(ts,tn);
		tx = shiftdim(tx,2);
		ty = shiftdim(ty,2);
	end

	function [ux,uy] = u3_xy(obj)
		us = obj.u3;
		us = obj.v3;
		us = us(:,2:end-1,2:end-1,:);
		un = ux(:,2:end-1,2:end-1,:);
		us = shiftdim(us,1);
		ux = shiftdim(ux,1);
		[ux,uy] = obj.smesh.vel_xy2sn(us,un);
		ux = shiftdim(ux,3);
		uy = shiftdim(uy,3);
	end
	
	function c = salinity_concentration(obj,varargin)
		if (~isempty(obj.sediment_concentration_))
			c  = obj.sediment_concentration_;
		else
			c =  vs_let(obj.map,'map-series',varargin,'R1',obj.vsopt);
			c(c==obj.nanval) = NaN;
			% quick fix d3d bug
			%c = max(c,0);
			obj.salinity_concentration_ = c;
		end
	end

	function c = sediment_concentration(obj,varargin)
		if (~isempty(obj.sediment_concentration_))
			c  = obj.sediment_concentration_;
		else
			c      =  vs_let(obj.map,'map-series',varargin,'R1',obj.vsopt);
			c(c==obj.nanval) = NaN;
			% quick fix d3d bug
			%c = max(c,0);
			obj.sediment_concentration_ = c;
		end
	end
	function ct = ct(obj,k,varargin)
		ck = obj.sediment_concentration(varargin{:});
		if (nargin()<2 || isempty(k))
			ct = sum(ck,5);
		else
			ct = sum(ck(:,:,:,:,k),5);
		end
	end
	function c = concentration_flux_averaged(obj)
		%if (~isempty(obj.sediment_concentration_))
		%end
			% TODO this is only valid for equal vertical cell size
			c = obj.sediment_concentration();
			umag = hypot(obj.u3,obj.v3);
			cu = bsxfun(@times,umag,c);
			c  = squeeze(sum(c,4))./squeeze(sum(umag,4));
	end
	function [u3_,v3_] = streamwise_velocity(obj)
		u3 = obj.u3;
		v3 = obj.v3;
		% depth average and rotate back
		u = nanmean(u3,4);
		v = nanmean(v3,4);
		umag = hypot(u,v);
		c = u./umag;
		s = v./umag;
		sig = -1;
		u3_ =     bsxfun(@times,c,u3) - sig*bsxfun(@times,s,v3);
		v3_ = sig*bsxfun(@times,s,u3) +     bsxfun(@times,c,v3);
		% mean v3 == 0
	end
	function I = secondary_flow_intensity(obj)
		% fit intensity
		[u,v] = streamwise_velocity(obj);
		if (0)
			n = size(v,4);
			A = 2*((n:-1:1)/(n+1)-1/2);
			I = 1/(A*A')*bsxfun(@times,v,shiftdim(A,-2)); 
			I = sum(I,4);
		else
			I = NaN(size(v,1),size(v,2),size(v,3));
			for idx=1:size(v,2)
			 for jdx=1:size(v,3)
				v_ = fliplr(squeeze(v(:,idx,jdx,:))); 
				n=find(isfinite(v_(end,:)),1,'last');
				if (n>0)
				A = 2*((n:-1:1)/(n+1)-1/2);
				I(:,idx,jdx) = 1/(A*A')*(A*v_(:,1:n)');
				end
			 end
			end
		end
	end

	function u2 = u2(obj,varargin)
		if (~isempty(obj.u2_))
			u2 = obj.u2_;
		else
			u3 = obj.u3(varargin{:});
			ds = cvec(obj.dsigma);
			ds = shiftdim(ds,-3);
			u2 = nansum(u3.*ds,4);
			obj.u2_ = u2;
		end
	end
	function v2 = v2(obj,varargin)
		if (~isempty(obj.v2_))
			v2 = obj.v2_;
		else
			v3 = obj.v3(varargin{:});
			ds = cvec(obj.dsigma);
			ds = shiftdim(ds,-3);
			v2 = nansum(v3.*ds,4);
			obj.v2_ = v2;
		end
	end
	function w2 = w2(obj)
		if (~isempty(obj.w2_))
			w2 = obj.w2_;
		else
			w3 = obj.w3;
			% TODO weight with layer thickness and make it a function
			w2 = nanmean(w3,4);
			obj.w2_ = w2;
		end
	end
	
	% note: ssuu is already depth integrated
	% Note : this is transport per unit width (!)
	function ssuk = ssuk(obj,varargin)
		if (~isempty(obj.ssuk_))
			ssuk = obj.ssuk_;
		else
			if (~isempty(vs_find(obj.map,'SSUU')))
				ssuk   =  vs_let(obj.map,'map-sed-series',varargin,'SSUU',obj.vsopt);
				ssuk(ssuk == obj.nanval) = NaN;
				obj.ssuk_ = ssuk;
			else
				ssuk = [];
			end
		end
	end

	function ssvk = ssvk(obj,varargin)
		if (~isempty(obj.ssvk_))
			ssvk = obj.ssvk_;
		else
			ssvk   =  vs_let(obj.map,'map-sed-series',varargin,'SSVV',obj.vsopt);
			ssvk(ssvk == obj.nanval) = NaN;
			%ssv3 = squeeze(ssv3(:,1:end-1,2:end-1,:));
			obj.ssvk_ = ssvk;
		end
	end

	function sbuk = sbuk(obj,varargin)
		if (~isempty(obj.sbuk_))
			sbuk = obj.sbuk_;
		else
			sbuk   =  vs_let(obj.map,'map-sed-series',varargin,'SBUU',obj.vsopt);
			sbuk(sbuk == obj.nanval) = NaN;
			%sbu3 = squeeze(sbu3(:,2:end-1,1:end-1,:));
			obj.sbuk_ = sbuk;
		end
	end

	function sbvk = sbvk(obj,varargin)
		if (~isempty(obj.sbvk_))
			sbvk = obj.sbuk_;
		else
			sbvk   =  vs_let(obj.map,'map-sed-series',varargin,'SBVV',obj.vsopt);
			sbvk(sbvk == obj.nanval) = NaN;
			obj.sbvk_ = sbvk;
		end
	end

	function ssu = ssu(obj,k,varargin)
		if (~isempty(obj.ssu_))
			ssu = obj.ssu_;
		else
			ssuk = obj.ssuk(varargin{:});
			% sum transport over fractions
			if (isempty(k))
				ssu = nansum(ssuk,4);
			else
				ssu = nansum(ssuk(:,:,:,k),4);
			end
			obj.ssu_ = ssu;
		end
	end
	function ssv = ssv(obj,k,varargin)
		if (~isempty(obj.ssv_))
			ssv = obj.ssv_;
		else
			ssvk = obj.ssvk(varargin{:});
			% sum fractions
			if (isempty(k))
				ssv = nansum(ssvk,4);
			else
				ssv = nansum(ssvk(:,:,:,k),4);
			end
			obj.ssv_ = ssv;
		end
	end
	
	function dssv = dssv(obj,k,varargin)
		if (~isempty(obj.dssv_))
			dssv = obj.dssv_;
		else
			ssvk = obj.ssvk(varargin{:});
			size(ssvk)
			% sum fractions
			if (isempty(k))
				dssv = nansum(ssvk.*shiftdim(cvec(obj.gsd.d(k)),-3),4) ./sum(ssvk,4);
			else
				dssv = nansum(ssvk(:,:,:,k).*shiftdim(cvec(obj.gsd.d(k)),-3),4) ./ sum(ssvk(:,:,:,k),4);
			end
			obj.dssv_ = dssv;
		end
	end

	function pssv = pssv(obj,k,varargin)
		if (~isempty(obj.ssv_))
			pssv = obj.pssv_;
		else
			ssvk = obj.ssvk(varargin{:});
			% sum fractions
			if (isempty(k))
				pssv = ssvk./nansum(ssvk,4);
			else
				pssv = ssvk./nansum(ssvk(:,:,:,k),4);
			end
			obj.pssv_ = pssv;
		end
	end

	function sbu = sbu(obj)
		if (~isempty(obj.sbu_))
			sbu = obj.sbu_;
		else
			sbuk = obj.sbuk;
			% sum fractions
			sbu = nansum(sbuk,4);
			obj.sbu_ = sbu;
		end
	end
	function sbv = sbv(obj)
		if (~isempty(obj.sbv_))
			sbv = obj.sbv_;
		else
			sbvk = obj.sbvk;
			% sum fractions
			sbv = nansum(sbvk,4);
			obj.sbv_ = sbv;
		end
	end
	
	% aux classes
	function qu = qu(obj)
		if (~isempty(obj.qu_))
			qu = obj.qu_;
		else
			[qu,qv] = obj.discharge();
		end
	end

	function qv = qv(obj)
		if (~isempty(obj.qv_))
			qv = obj.qv_;
		else
			[qu,qv] = obj.discharge();
		end
	end

	function [m,n,k,nc] = mnk(obj)
			m  = vs_let(obj.map,'map-const','MMAX',obj.vsopt);
			n  = vs_let(obj.map,'map-const','NMAX',obj.vsopt);
			k  = vs_let(obj.map,'map-const','KMAX',obj.vsopt);
			nc = vs_let(obj.map,'map-const','LSTCI',obj.vsopt);
	end
	
	function gsd = grain_size_pdf(obj,varargin)
		msed = obj.msed(varargin{:});
		gsd  = msed./sum(msed,5);
	end

	function msed = msed(obj,varargin)
		[m,n,k,nc] = obj.mnk();
		nt      = obj.nt();
		if (numel(varargin)>0)
			tdx = varargin;
		else
			tdx={};
		end
		msed = obj.msed_UL(tdx,{1:n, 1:m, 1, 1:nc});
	end

	% mass in under layers (bed material)
	function [msed,pdf,diametre,msum,diametre_class] = msed_UL(obj,tdx,gdx)
		if (nargin()<2)
			tdx = {};
		end
		if (nargin()<3)
			gdx = {};
		end
		if (~isempty(vs_find(obj.map,'MSED')))
			% normalize mass per fraction to get gsd
			msed  = vs_let(obj.map,'map-sed-series',tdx,'MSED',gdx,obj.vsopt);
			msed  = single(msed);
			%msed = [];
			%for idx=1:length(gsd_C)
			%	gsd_i(idx,:,:,:) = gsd_C{idx};
			%end
			% topmost layer
			%gsd  = squeeze(gsd(:,:,:,:));
			nd = ndims(msed);
			% normalize
			if (nargout()>1)
			msum = sum(msed,nd);
			pdf  = bsxfun(@times,msed,1./msum);	
			d_str = vs_get(obj.map,'map-const','NAMSED',obj.vsopt);
			for idx=1:size(d_str,1)
				diametre_class(idx,1) = str2num(regexprep(d_str(idx,:),'[A-Za-z ]*([0-9]*).*','$1'));
			end
			switch (nd)
			case {4}
			case {5}
				d_   = shiftdim(diametre_class,-4);
				diametre   = bsxfun(@times,d_,msed);
				% normalize
				diametre   = sum(diametre,5)./msum;
			end
			end
		else
			msed = [];
			msum = [];
			pdf        = [];
			diametre   = [];
			diametre_class = [];
		end
	end

	function dm = dm(obj,varargin)
		if (~isempty(vs_find(obj.map,'DM')))
			dm = vs_let(obj.map,'map-sed-series',varargin,'DM',obj.vsopt);
			%	dm = cell2mat(cellfun(@(x) shiftdim(x,-1),dm,'uniformoutput',false));
		else
			dm = [];
		end
	end

	function x = turbulence(obj,varargin)
		if (~isempty(vs_find(obj.map,'RTUR1')))
			x = vs_let(obj.map,'map-series',varargin,'RTUR1',obj.vsopt);
		else
			x = [];
		end
	end % furbulence ()

	function v = sediment_mass(obj,varargin)
			v = vs_let(obj.map,'map-sed-series',varargin,'MSED',obj.vsopt);
	end
	
	function quiver(obj,u,v,varargin)
		obj.smesh.quiver(u,v,varargin);
	end
	function v = duneheight(obj,varargin)
		if (isempty(obj.duneheight_))
			obj.duneheight_ = vs_let(obj.map,'map-sed-series',varargin,'DUNEHEIGHT',obj.vsopt); 
		end
		v = obj.duneheight_;
	end
	function v = dunelength(obj,varargin)
		if (isempty(obj.dunelength_))
			obj.dunelength_=vs_let(obj.map,'map-sed-series',varargin,'DUNELENGTH',obj.vsopt); 
		end
		v = obj.dunelength_;
	end
	function v = viscosity_uv(obj,varargin)
		if (isempty(obj.viscosity_uv_))
			obj.viscosity_uv_=vs_let(obj.map,'map-series',varargin,'VICUV',obj.vsopt);
		end
		v = obj.viscosity_uv_;
	end
	function v = Mannung_u(obj,varargin)
		if (isempty(obj.nu_))
			obj.nu_=vs_let(obj.map,'map-series',varargin,'ROUMETU',obj.vsopt);
		end
		v = obj.nu_;
	end
	% roughness
	function v = Chezy_u(obj,varargin)
		if (isempty(obj.Cu_))
			obj.Cu_ = vs_let(obj.map,'map-series',varargin,'CFUROU',obj.vsopt);                     
		end
		v = obj.Cu_;
	end
	function v = settling_velocity(obj,varargin)
		if (isempty(obj.settling_velocity_))
			obj.settling_velocity_=vs_let(obj.map,'map-sed-series',varargin,'WS',obj.vsopt); 
		end
			v = obj.settling_velocity_;
	end	
	function v = reference_concentration(obj,varargin)
		if (isempty(obj.reference_concentration_))
			obj.reference_concentration_ = vs_let(obj.map, ...
				   'map-sed-series', varargin,'RCA',obj.vsopt); 
		end
		v = obj.reference_concentration_;
	end	
	function v = equilibrium_concentration(obj,varargin)
		if (isempty(obj.equilibrium_concentration_))
			obj.equilibrium_concentration_= vs_let(obj.map, ...	
				'map-sed-series', varargin,'RSEDEQ',obj.vsopt); 
		end
		v = obj.equilibrium_concentration_;
	end
	function ustar = shear_velocity(obj,varargin)
		if (isempty(obj.ustar_))
			obj.ustar_ = vs_let(obj.map, ...
				'map-sed-series', varargin, 'USTAR',obj.vsopt);
		end
		v = obj.ustar_;
	end	
	function volume = volume(obj,varargin)
		if (isempty(obj.volume_))
			area   = obj.area();
			dz     = obj.dz(varargin{:});
			volume = shiftdim(area,-1).*dz;
			obj.volume_ = volume;
		end
		volume = obj.volume_;
	end
	function area = area(obj)
		if (isempty(obj.area_))
			obj.area_ = squeeze(vs_let('map-const','GSQS',obj.vsopt));
		end
		area = obj.area_;
	end

	function dp = particle_size(obj,k,varargin)
		ck = obj.sediment_concentration(varargin);
		ct = obj.ct(k,varargin{:});
		if (isempty(k))
			k = 1:size(ck,5);
		end
		dp = sum(ck(:,:,:,:,k).*shiftdim(cvec(obj.gsd.d(k)),-4),5)./ct;
	end

	function dxx = dxx(obj, k, varargin)
		dxx = vs_let(obj.map, 'map-sed-series', varargin, ...
					       ['DXX0',num2str(k)], obj.vsopt);
	end
	function val = morfac(obj,varargin)
		if (isempty(obj.morfac_))
			obj.morfac_ = vs_let('map-infsed-serie','MORFAC',varargin,obj.vsopt);
		end
		val = obj.morfac_;
	end
	end % methods
end % class Delft3D_Map

