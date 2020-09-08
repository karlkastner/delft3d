% Mon 19 Nov 15:33:59 CET 2018
function plot_stratigraphy(obj,msed,d,csid)
	[S,N] = obj.S;

	msed = flipud(msed);
	d = flipud(d);

	d = flipud(d);
	cm = [zeros(1,size(msed,2)); cumsum((msed))];
	if (nargin>3)
		N = N(csid,:);
	else
		N = 0:size(msed,2);
		%[idx-1/2,idx+1/2,idx+1/2,idx-1/2]
	end
	for idx=2:size(msed,2)-1
		for jdx=1:size(msed,1)
			patch([N(idx-1),N(idx),N(idx),N(idx-1)], ...
			      [cm(end+1-jdx,idx),cm(end+1-jdx,idx),cm(end-jdx,idx),cm(end-jdx,idx)],...
			      [0,0,0,0],d(jdx,idx));
			hold on
		end
	end
	ylim([min(cm(2,2:end-1)),max(cm(end,2:end-1))]);
end

