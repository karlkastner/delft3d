% Fri 23 Nov 09:58:35 CET 2018
function mark_cs(obj,id,jd)
	X = obj.X;
	X(0==X) = NaN;
	Y = obj.Y;
	if (~isempty(id))
	hold on
	plot(X(id,1:end-1)',Y(id,1:end-1)','r');
	for idx=1:length(id)
		text(X(id(idx),1),Y(id(idx),2),num2str(idx)); %,'r');
	end
	end
	if (~isempty(jd))
		hold on
		plot(X(:,jd),Y(:,jd),'r');
	end
end
