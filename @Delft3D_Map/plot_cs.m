% Mon 19 Nov 16:54:10 CET 2018
% function plot_cs(obj,tid,cid,cjd,val)
function plot_cs(obj,tid,cid,cjd,val)
	if (ndims(val)>3)
		val = squeeze(val(tid,:,:,:));
	end
	if (~isempty(cid))
		if (ndims(val)>2)
			val = squeeze(val(cid,:,:));
		end
		[S,N] = obj.S;
		%sigma = obj.sigma;
		Z   = obj.Z;
		val = squeeze(val)';
		%imagesc(val);
		%S(:,end) = 2*S(:,end-1)-S(:,end-2); S(end,:) = 2*S(end-2,:)-S(end-1);
		N  = inner2outer(inner2outer(N,1),2);
%		N(:,end) = 2*N(:,end-1)-N(:,end-2);
%		N(end,:) = 2*N(end-2,:)-N(end-1);
		NN       = (N(cid,:)'*ones(1,size(val,1)))';
		ZZ       = squeeze(Z(tid,cid,:,:))';
		surface(NN(:,2:end-1),ZZ(:,2:end-1),val(:,2:end-1),'edgecolor','none');
	else
		[S,N] = obj.S;
		Z   = obj.Z;
		val = squeeze(val)';

		S  = inner2outer(inner2outer(S,1),2);
%		S(:,end) = 2*S(:,end-1)-S(:,end-2);
%		S(end,:) = 2*S(end-2,:)-S(end-1);
		%N(:,end) = 2*N(:,end-1)-N(:,end-2); N(end,:) = 2*N(end-2,:)-N(end-1);
		SS = (ones(size(val,1),1)*S(:,cjd));
		ZZ = squeeze(Z(tid,:,cjd,:))';
		surface(SS(:,2:end-1),ZZ(:,2:end-1),val(:,2:end-1),'edgecolor','none');
	end
end

