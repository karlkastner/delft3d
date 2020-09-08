% 2018-11-15 14:46:45.630149596 +0100 cs_flux.m
% TODO allow for both directions
function [flux,jd] = cs_flux(obj,field,id)
	val = obj.(field);
	flux = [];
	valm = squeeze(max(abs(val),[],1));
	for jdx=1:length(id)
	id_ = id(jdx);
	%fdx = [squeeze(val(3,id_,:)~=0)];
	fdx = [valm(id_,:)~=0];
	state = false;
	k = 0;
	for idx=1:size(val,3)
	switch (state)
	case {false}
		if (fdx(idx))
			% no field
			k = k+1;
			flux(:,k,jdx) = val(:,id_,idx);
			state = true;
		else
			% hold state at false
		end
	case {true}
		if (fdx(idx))
			flux(:,k,jdx) = flux(:,k,jdx) + val(:,id_,idx);
		else
			% toggle state to false
			state = false;
		end
	end % switch
	end
end % cs_flux

