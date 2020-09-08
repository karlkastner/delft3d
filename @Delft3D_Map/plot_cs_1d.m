% Mon 26 Nov 12:31:39 CET 2018
function plot_cs_1d(obj,val,id,jd)
	% TODO vline for split
	if (~isempty(id))
		N  = obj.N;
		if (length(val) == size(N,2)-1)
			plot(N(id,2:end),val); % TODO mid?
		else
			plot(N(id,:),val);
		end
	else
		S  = obj.S;
		if (length(val) == size(S,1)-1) % was -2
			plot(S(2:end,jd),val);
		else
			plot(S(2:end,jd),val);
		end
	end
end

