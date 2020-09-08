% Fri 13 Dec 09:43:40 +08 2019
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
classdef Delft3D_His < handle
	properties
		% his file pointer
		his

		% reading options
		vsopt = 'quiet';

		% mesh
		smesh

		% morphological time scale
		tmor_
		time_

		% aux vars

		nanval = -999;
	end
	methods
	function obj = Delft3D_His()
	end
	function init(obj,folder_)
		if (strcmp(folder_(end-2:end),'dat'))
			path = folder_;
		else
		try
			path  = ls([folder_,'/trih-delft3d.dat']);
			path  = chomp(path);
		catch e1
			try
			path   = ls([folder_,'/*/trih-delft3d.dat'])
			path_C = strsplit(path,'\n')
			path = path_C{1};
			path  = chomp(path);
			catch e2
				disp(e1)
				disp(e2)
				return;
			end
		end
		end
		obj.his   = vs_use(path,obj.vsopt);
	end
	function sb = bedload_transport(obj)
		sb=squeeze(vs_let(obj.his,'his-sed-series','SBTR',obj.vsopt));
		%sb = 2650*sb;
	end
	function ss = suspended_transport(obj)
		ss=squeeze(vs_let(obj.his,'his-sed-series','SSTR',obj.vsopt));
		% TODO make dependeng on TR 
		%ss = 2650*ss;
	end
	function Q = discharge(obj)
		Q = squeeze(vs_let(obj.his,'his-series','CTR',obj.vsopt));
	end
	function v = water_level(obj)
		v = squeeze(vs_let(obj.his,'his-series','ZWL',obj.vsopt));
	end
	function v = depth(obj)
		v = obj.water_level() - obj.bed_level();
	end
	function v = bed_level(obj)
		v = -squeeze(vs_let(obj.his,'his-series','DPS',obj.vsopt));
	end
	
	function v = u(obj)
		v = squeeze(vs_let(obj.his,'his-series','ZCURU',obj.vsopt));
	end
	function v = v(obj)
		v = squeeze(vs_let(obj.his,'his-series','ZCURV',obj.vsopt));
	end
	function v = lstci(obj)
		v = vs_get(obj.his,'his-const','LSTCI',obj.vsopt)
	end

%	function nz = nz(obj)
%		if (~isempty(obj.nz_))
%			nz = obj.nz_;
%		else
%			nz = vs_get(obj.map,'map-const','KMAX',obj.vsopt);
%			obj.nz_ = nz;
%		end
%	end
%	function nsed = nsed(obj)
%		if (~isempty(obj.nsed_))
%			nsed = obj.nsed_;
%		else
%			nsed = vs_get(obj.map,'map-const','LSED',obj.vsopt);
%			obj.nsed_ = nsed;
%		end
%	end
%	function nul = nul(obj)
%		if (~isempty(obj.nul_))
%			nul = obj.nul_;
%		else
%			s   = vs_disp(obj.map,'map-sed-series','MSED',obj.vsopt);
%			siz = s.SizeDim;
%			nul = siz(3);
%			%nul = vs_get(obj.map,'map-const','LSED',obj.vsopt);
%			obj.nul_ = nul;
%		end
%	end
%	function time = time(obj)
%		if (isempty(obj.time_))
%			dt = vs_let('map-const','DT');
%			t  = vs_let('map-infsed-serie','ITMAPS');
%			time_d = dt*t/1440;
%			%time_s = vs_let(obj.map,'map-infavg-serie','ITAVGS',obj.vsopt)
%			%time_d = time_s/86400;
%			obj.time_      =  time_d;
%		end
%		time = obj.time_;
%	end
%
%	function tmor = tmor(obj)
%		if (isempty(obj.tmor_))
%			obj.tmor_ = vs_let(obj.map, 'map-infsed-serie', ...
%					            'MORFT', obj.vsopt);
%		end
%		tmor = obj.tmor_;
%	end
%
%	function [Xc,Yc] = Xc(obj)
%		if (isempty(obj.Xc_))
%			Xc = vs_get(obj.map,'map-const','XZ',obj.vsopt);
%			Yc = vs_get(obj.map,'map-const','YZ',obj.vsopt);
%			obj.Xc_ = Xc;
%			obj.Yc_ = Yc;
%		else
%			Xc = obj.Xc_;
%			Yc = obj.Yc_;		
%		end
%	end
%
%	function [Yc,Xc] = Yc(obj)
%		[Xc,Yc] = obj.Xc;
%	end
%
%	% TODO pass from smesh
%	function [X,Y] = X(obj)
%		if (isempty(obj.smesh))
%			X = vs_get(obj.map,'map-const','XCOR',obj.vsopt);
%			Y = vs_get(obj.map,'map-const','YCOR',obj.vsopt);
%			% invalidate
%			[Xc,Yc] = obj.Xc;
%			valid   = true(size(Xc));
%			valid(:,end) = false;
%			v = mid(Xc(:,2:end-1),2)~=0;
%			valid(:,2:end-2) = valid(:,2:end-2) & v;
%%			fdx = (Xc~=0) & (Yc~=0);
%%			fdx(1,:) = true; fdx(end,:) = true;
%%			fdx(:,1) = true; fdx(:,end) = true;
%%			fdx = fdx & (X>0);
%			X(~valid) = NaN;
%			Y(~valid) = NaN;
%
%			% remove last column
%			X = X(1:end-1,1:end-1);
%		        Y = Y(1:end-1,1:end-1);
%		        X(X==0) = NaN;
%		        Y(Y==0) = NaN;
%			%obj.X_ = X;
%			%obj.Y_ = Y;
%
%			obj.smesh = SMesh();
%			%X = obj.X;
%			%Y = obj.Y;
%			obj.smesh.X = X;
%			obj.smesh.Y = Y;
%			obj.smesh.extract_elements(); 
%		else
%			X = obj.smesh.X;
%			Y = obj.smesh.Y;
%		end
%	end
%	function [Y,X] = Y(obj)
%		[X,Y] = obj.X;
%	end
%		function XX = XX(obj)
%			XX = repmat(shiftdim(obj.X,-1),[length(obj.tmor),1,1]);
%		end
%		function YY = YY(obj)
%			YY = repmat(shiftdim(obj.Y,-1),[length(obj.tmor),1,1]);
%		end
%		function tt = tt(obj)
%			tt = repmat(shiftdim(obj.tmor),[1,size(obj.X)]);
%		end
%	function [S,N] = S(obj)
%		if (isempty(obj.S_))
%		%X    = X(1:end-1,1:end-1);
%		%Y    = Y(1:end-1,1:end-1);
%		[X,Y] = obj.X;
%	
%		% hold the zeros and NaNs
%		X(isnan(X)) = 0;
%		Y(isnan(Y)) = 0;
%		X_ = X;
%		Y_ = Y;
%		for idx=2:size(X,1)
%		 for jdx=1:size(X,2)
%			if (0 == X_(idx,jdx) && 0 == Y_(idx,jdx))
%				X_(idx,jdx) = X_(idx-1,jdx);
%				Y_(idx,jdx) = Y_(idx-1,jdx);
%			end
%		end
%		end
%		S = cumsum([zeros(1,size(X,2)); hypot(diff(X_),diff(Y_))]);
%		X_ = X;
%		Y_ = Y;
%		for idx=1:size(X,1)
%		 for jdx=2:size(X,2)
%			if (0 == X_(idx,jdx) && 0 == Y_(idx,jdx))
%				X_(idx,jdx) = X_(idx,jdx-1);
%				Y_(idx,jdx) = Y_(idx,jdx-1);
%			end
%		end
%		end
%		N = cumsum([zeros(size(X,1),1), hypot(diff(X_,[],2),diff(Y_,[],2))],2);
%		obj.S_ = S;
%		obj.N_ = N;
%		else
%			S = obj.S_;
%			N = obj.N_;
%		end
%	end
%	function [N,S] = N(obj)
%		[S,N] = obj.S;
%	end
%	function depth = depth(obj)
%		depth = obj.zs - obj.zb;
%	end
%	function sigma = sigma(obj)
%		sigma = cumsum(mid([0,vs_let(obj.map,'map-const','THICK',obj.vsopt)]));
%	end
%	function Z = Z(obj)
%		if (~isempty(vs_find('LAYER_INTERFACE')))
%			Z = vs_let(obj.map,'map-series','LAYER_INTERFACE');
%			Z = 0.5*(Z(:,:,:,1:end-1)+Z(:,:,:,2:end));
%		else
%			disp('computing Z');
%			depth = obj.depth;
%			zb = obj.zb;
%			depth = depth(:,:,1:end-1);
%			zb = zb(:,:,1:end-1);
%			sigma = obj.sigma;
%			sigma = shiftdim(rvec(sigma),-2);
%			Z = bsxfun(@times,depth,1-sigma);
%			Z = bsxfun(@plus,zb,Z);
%		end
%	end
%
%	function zb = zb(obj)
%		zb     = -vs_let(obj.map,'map-sed-series','DPS',obj.vsopt);
%	end
%	function zs = zs(obj)
%		zs     =  vs_let(obj.map,'map-series','S1',obj.vsopt);
%	end
%	function u3 = u3(obj)
%		if (~isempty(obj.u3_))
%			u3  = obj.u3_;
%		else
%			u3      =  vs_let(obj.map,'map-series','U1',obj.vsopt);
%			u3(u3 == obj.nanval) = NaN;
%			obj.u3_ = u3;
%			% set flow through closed boundary to zero, zmesh fix, where it is set incorrectly to nan
%%			X = obj.X;
%%			for idx=1:size(u3,2)
%%			 % first
%%			 if (isnan(u3(1,idx,1,1)))
%%				u3(:,idx,1,:) = 0;
%%			 end % if first
%%			 % centre
%%			 for jdx=2:size(u3,3)-1
%%				if (~isnan(X(idx,jdx)) && isnan(u3(1,idx,jdx,1)) ...
%%				     && ( isnan(X(idx,jdx+1)) || isnan(X(idx,jdx-1)) ) )
%%					u3(:,idx,jdx,:) = 0;
%%				end
%%			 end % for jdx
%%			 % last
%%			 if (isnan(u3(1,idx,end,1)))
%%				u3(:,idx,end,:) = 0;
%%			 end % if last
%%			end % for idx
%		end % if
%	end % u3
%	function v3 = v3(obj)
%		if (~isempty(obj.v3_))
%			v3  = obj.v3_;
%		else
%			v3      =  vs_let(obj.map,'map-series','V1',obj.vsopt);
%			v3(v3 == obj.nanval) = NaN;
%			obj.v3_ = v3;
%		end
%	end
%	function w3 = w3(obj)
%		if (~isempty(obj.w3_))
%			w3  = obj.w3_;
%		else
%			w3      =  vs_let(obj.map,'map-series','WPHY',obj.vsopt);
%			w3(w3 == obj.nanval) = NaN;
%			obj.w3_ = w3;
%		end
%	end
%
%	function [ts,tn] = tau_sn(obj)
%		ts = vs_let('map-series','TAUKSI',obj.vsopt);
%		%ts = squeeze(ts(end,:,:));
%		% TODO, make this a matrix
%		ts = ts(:,2:end-1,:);
%		ts = ts(:,:,1:end-1);
%		ts(:,:,1)  =ts(:,:,2);
%		ts(:,:,end)=ts(:,:,end-1);
%		ts = mid(ts,3);
%		tn = vs_let('map-series','TAUETA',obj.vsopt);
%		%tn = squeeze(tn(end,:,:));
%		tn = tn(:,:,2:end-1);
%		tn=tn(:,1:end-1,:);
%		tn(:,1,:) = tn(:,2,:);
%		tn(:,end,:)=tn(:,end-1,:);
%		tn = mid(tn,2);
%	end
%
%	function [tx,ty] = tau_xy(obj)
%		[ts,tn] = obj.tau_sn();
%		ts = shiftdim(ts,1);
%		tn = shiftdim(tn,1);
%		[ty,tx] = obj.smesh.vel_sn2xy(ts,tn);
%		tx = shiftdim(tx,2);
%		ty = shiftdim(ty,2);
%	end
%
%	function [ux,uy] = u3_xy(obj)
%		us = obj.u3;
%		us = obj.v3;
%		us = us(:,2:end-1,2:end-1,:);
%		un = ux(:,2:end-1,2:end-1,:);
%		us = shiftdim(us,1);
%		ux = shiftdim(ux,1);
%		[ux,uy] = obj.smesh.vel_xy2sn(us,un);
%		ux = shiftdim(ux,3);
%		uy = shiftdim(uy,3);
%	end
%
%	function c = sediment_concentration(obj)
%		if (~isempty(obj.c_))
%			c  = obj.c_;
%		else
%			c      =  vs_let(obj.map,'map-series','R1',obj.vsopt);
%			c(c==obj.nanval) = NaN;
%			obj.c_ = c;
%		end
%	end
%	function c = concentration_flux_averaged(obj)
%		%if (~isempty(obj.c_))
%		%end
%			% TODO this is only valid for equal vertical cell size
%			c = obj.sediment_concentration();
%			umag = hypot(obj.u3,obj.v3);
%			cu = bsxfun(@times,umag,c);
%			c  = squeeze(sum(c,4))./squeeze(sum(umag,4));
%	end
%	function [u3_,v3_] = streamwise_velocity(obj)
%		u3 = obj.u3;
%		v3 = obj.v3;
%		% depth average and rotate back
%		u = nanmean(u3,4);
%		v = nanmean(v3,4);
%		umag = hypot(u,v);
%		c = u./umag;
%		s = v./umag;
%		sig = -1;
%		u3_ =     bsxfun(@times,c,u3) - sig*bsxfun(@times,s,v3);
%		v3_ = sig*bsxfun(@times,s,u3) +     bsxfun(@times,c,v3);
%		% mean v3 == 0
%	end
%	function I = secondary_flow_intensity(obj)
%		% fit intensity
%		[u,v] = streamwise_velocity(obj);
%		if (0)
%			n = size(v,4);
%			A = 2*((n:-1:1)/(n+1)-1/2);
%			I = 1/(A*A')*bsxfun(@times,v,shiftdim(A,-2)); 
%			I = sum(I,4);
%		else
%			I = NaN(size(v,1),size(v,2),size(v,3));
%			for idx=1:size(v,2)
%			 for jdx=1:size(v,3)
%				v_ = fliplr(squeeze(v(:,idx,jdx,:))); 
%				n=find(isfinite(v_(end,:)),1,'last');
%				if (n>0)
%				A = 2*((n:-1:1)/(n+1)-1/2);
%				I(:,idx,jdx) = 1/(A*A')*(A*v_(:,1:n)');
%				end
%			 end
%			end
%		end
%	end
%
%	function u2 = u2(obj)
%		if (~isempty(obj.u2_))
%			u2 = obj.u2_;
%		else
%			u3 = obj.u3;
%			% TODO weight with layer thickness and make it a function
%			u2 = nanmean(u3,4);
%			obj.u2_ = u2;
%		end
%	end
%	function v2 = v2(obj)
%		if (~isempty(obj.v2_))
%			v2 = obj.v2_;
%		else
%			v3 = obj.v3;
%			% TODO weight with layer thickness and make it a function
%			v2 = nanmean(v3,4);
%			obj.v2_ = v2;
%		end
%	end
%	function w2 = w2(obj)
%		if (~isempty(obj.w2_))
%			w2 = obj.w2_;
%		else
%			w3 = obj.w3;
%			% TODO weight with layer thickness and make it a function
%			w2 = nanmean(w3,4);
%			obj.w2_ = w2;
%		end
%	end
%	
%	% note: ssuu is already depth integrated
%	function ssu2 = ssu2(obj)
%		if (~isempty(obj.ssu2_))
%			ssu2 = obj.ssu2_;
%		else
%			ssu2   =  vs_let(obj.map,'map-sed-series','SSUU',obj.vsopt);
%			ssu2(ssu2 == obj.nanval) = NaN;
%			%ssu3 = squeeze(ssu3(:,2:end-1,1:end-1,:));
%			obj.ssu2_ = ssu2;
%		end
%	end
%
%	function ssv2 = ssv2(obj)
%		if (~isempty(obj.ssv2_))
%			ssv2 = obj.ssv2_;
%		else
%			ssv2   =  vs_let(obj.map,'map-sed-series','SSVV',obj.vsopt);
%			ssv2(ssv2 == obj.nanval) = NaN;
%			%ssv3 = squeeze(ssv3(:,1:end-1,2:end-1,:));
%			obj.ssv2_ = ssv2;
%		end
%	end
%
%	function sbu3 = sbu3(obj)
%		if (~isempty(obj.sbu3_))
%			sbu3 = obj.sbu3_;
%		else
%			sbu3   =  vs_let(obj.map,'map-sed-series','SBUU',obj.vsopt);
%			sbu3(sbu3 == obj.nanval) = NaN;
%			%sbu3 = squeeze(sbu3(:,2:end-1,1:end-1,:));
%			obj.sbu3_ = sbu3;
%		end
%	end
%
%	function sbv3 = sbv3(obj)
%		if (~isempty(obj.sbv3_))
%			sbv3 = obj.sbu3_;
%		else
%			sbv3   =  vs_let(obj.map,'map-sed-series','SBVV',obj.vsopt);
%			sbv3(sbv3 == obj.nanval) = NaN;
%			%sbv3 = squeeze(sbv3(:,1:end-1,2:end-1,:));
%			obj.sbv3_ = sbv3;
%		end
%	end
%
%	function ssu = ssu(obj)
%		if (~isempty(obj.ssu_))
%			ssu = obj.ssu_;
%		else
%			ssu3 = obj.ssu3;
%			% sum fractions
%			ssu = nansum(ssu3,4);
%			obj.ssu_ = ssu;
%		end
%	end
%	function ssv = ssv(obj)
%		if (~isempty(obj.ssv_))
%			ssv = obj.ssv_;
%		else
%			ssv3 = obj.ssv3;
%			% sum fractions
%			ssv = nansum(ssv3,4);
%			obj.ssv_ = ssv;
%		end
%	end
%
%	function sbu = sbu(obj)
%		if (~isempty(obj.sbu_))
%			sbu = obj.sbu_;
%		else
%			sbu3 = obj.sbu3;
%			% sum fractions
%			sbu = nansum(sbu3,4);
%			obj.sbu_ = sbu;
%		end
%	end
%	function sbv = sbv(obj)
%		if (~isempty(obj.sbv_))
%			sbv = obj.sbv_;
%		else
%			sbv3 = obj.sbv3;
%			% sum fractions
%			sbv = nansum(sbv3,4);
%			obj.sbv_ = sbv;
%		end
%	end
%	
%	% aux classes
%	function qu = qu(obj)
%		if (~isempty(obj.qu_))
%			qu = obj.qu_;
%		else
%			[qu,qv] = obj.discharge();
%		end
%	end
%
%	function qv = qv(obj)
%		if (~isempty(obj.qv_))
%			qv = obj.qv_;
%		else
%			[qu,qv] = obj.discharge();
%		end
%	end
%
%	function [msed,pdf,diametre,msum,diametre_class] = grain_size(obj)
%		if (~isempty(vs_find('MSED')))
%			% normalize mass per fraction to get gsd
%			msed  = vs_let(obj.map,'map-sed-series','MSED',obj.vsopt);
%			%msed = [];
%			%for idx=1:length(gsd_C)
%			%	gsd_i(idx,:,:,:) = gsd_C{idx};
%			%end
%			% topmost layer
%			%gsd  = squeeze(gsd(:,:,:,:));
%			nd = ndims(msed);
%			% normalized
%			msum = sum(msed,nd);
%			pdf  = bsxfun(@times,msed,1./msum);	
%			d_str = vs_get(obj.map,'map-const','NAMSED',obj.vsopt);
%			for idx=1:size(d_str,1)
%				diametre_class(idx,1) = str2num(regexprep(d_str(idx,:),'[A-Za-z ]*([0-9]*).*','$1'));
%			end
%			switch (nd)
%			case {4}
%			case {5}
%				d_   = shiftdim(diametre_class,-4);
%				diametre   = bsxfun(@times,d_,msed);
%				% normalize
%				diametre   = sum(diametre,5)./msum;
%			end
%		else
%			msed = [];
%			msum = [];
%			pdf        = [];
%			diametre   = [];
%			diametre_class = [];
%		end
%	end
%
	function dm = dm(obj)
		if (~isempty(vs_find(obj.his,'DM')))
			dm = vs_let(obj.his,'his-sed-series','DM',obj.vsopt);
%			%	dm = cell2mat(cellfun(@(x) shiftdim(x,-1),dm,'uniformoutput',false));
		else
			dm = [];
		end
	end
	function mnstat = mnstat(obj)
		mnstat = vs_let(obj.his,'his-const','MNSTAT',obj.vsopt);
	end
%
%	function x = turbulence(obj)
%		if (~isempty(vs_find('RTUR1')))
%			x = vs_let(obj.map,'map-series','RTUR1',obj.vsopt);
%		else
%			x = [];
%		end
%	end % furbulence ()
%	
%	function quiver(obj,u,v,varargin)
%		obj.smesh.quiver(u,v,varargin{:});
%	end
%	function v = duneheight(obj)
%		v=vs_let(obj.his,'his-sed-series','DUNEHEIGHT'); 
%	end
%	function v = dunelength(obj)
%		v=vs_let(obj.his,'his-sed-series','DUNELENGTH'); 
%	end
%	
%	
	end % methods
end % class D3D

