% 2018-11-15 14:41:39.761965649 +0100
%
% this is not exact
%function [qu,qv] = discharge(obj)
function [qu,qv] = discharge(obj,varargin)
	u = obj.u2(varargin{:});
	v = obj.v2(varargin{:});

	%xcor = obj.X;
	%ycor = obj.Y;
	%xcor = vs_get(obj.map,'map-const','XCOR');
	%ycor = vs_get(obj.map,'map-const','YCOR');
	%x    = xcor(1:end-1,1:end-1);
	%y    = ycor(1:end-1,1:end-1);
	x = obj.X;
	y = obj.Y;
	%x=smesh.X;
	%y=smesh.Y;
	d = obj.depth(varargin{:});
	%d  = obj.zs(varargin{:}) - obj.zb(varargin{:});
	%d  = d(:,:,2:end-1);
	d_ = squeeze(d(:,:,2:end-1));
	%d_ = squeeze(d(end,:,:));
	%v_ = squeeze(v(end,1:end-1,2:end-1));
	%u_ = squeeze(u(end,2:end-1,2:end-2));

	v_ = (v(:,1:end-1,2:end-1));
	u_ = (u(:,2:end-1,2:end-2));
	dn2 = hypot(diff(mid(x,1),[],2),diff(mid(y,1),[],2));
	dn1 = hypot(diff(mid(x,2),[],1),diff(mid(y,2),[],1));
	%qu = bsxfun(@times,u_.*mid(d,3),shiftdim(mid(dn1,2),-1));
	%qv = bsxfun(@times,mid(v_,2).*d,shiftdim(dn2,-1));
	qu = bsxfun(@times,u_.*mid(d_(:,2:end-1,:),3),shiftdim(mid(dn1,2),-1));
	qv = bsxfun(@times,mid(v_.*mid(d_,2),2),shiftdim(dn2,-1));

	obj.qu_ = qu;
	obj.qv_ = qv;
end
