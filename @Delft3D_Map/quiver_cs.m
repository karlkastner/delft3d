% Tue 19 Feb 16:42:38 CET 2019
function quiver_cs(obj,tid,cid,u,v,nq,varargin)
	u = squeeze(u);
	v = squeeze(v);

	[S,N] = obj.S;
	%sigma = obj.sigma;
	Z   = obj.Z;
	%imagesc(val);
	S(:,end) = 2*S(:,end-1)-S(:,end-2);
	S(end,:) = 2*S(end-2,:)-S(end-1);
	N(:,end) = 2*N(:,end-1)-N(:,end-2);
	N(end,:) = 2*N(end-2,:)-N(end-1);
%	NN = (N(cid,:)'*ones(1,size(val,1)))';
%	ZZ = squeeze(Z(tid,cid,:,:))';
%	surface(NN(:,2:end-1),ZZ(:,2:end-1),val(:,2:end-1),'edgecolor','none');

	N = N(cid,:);
	N = N+(1:length(N))*sqrt(eps);
	% resample
	N_ = innerspace(N(1),N(end),nq(1));
% TODO max/min depth
	zmin = min(size(squeeze(Z(end,cid,:,:))));
	Z_ = innerspace(zmin,0,nq(2));

	u_ = interp1(N,u,N_);
-> TODO, z varies per column -> interpolated 2d !! or loop
	u_ = interp1(Z,u_.',Z_)';
	v_ = interp1(N,v,N_);
	v_ = interp1(Z,v_.',Z_)';
	
	N_ = repmat(cvec(N_),1,nq(2));
	Z_ = repmat(rvec(Z_),nq(1),1);

	%val = squeeze(val)';
	quiver(N_(:),Z_(:),u_(:),v_(:),varargin{:});
end
