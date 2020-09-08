% Mon 26 Nov 11:05:39 CET 2018
function [d,val2] = difference(obj1,obj2,field)
	val1 = obj1.(field);
	val2 = obj2.(field);
	if(norm(size(val1)-size(val2)) ~= 0)
		%ip2  = TriScatteredInterp([flat(obj2.tt) flat(obj2.XX) flat(obj2.YY)],flat(val2),'linear');
		ip2  = scatteredInterpolant([flat(obj2.tt) flat(obj2.XX) flat(obj2.YY)],flat(val2),'linear','nearest');
		val2 = ip2([flat(obj1.tt),flat(obj1.XX),flat(obj1.YY)]);
		val2 = reshape(val2,size(val1));
	end
	if (0)
	% interpolate in time
	t1 = obj1.time;
	t2 = obj2.time;
	if ( norm(size(t1)-size(t2))>0 || norm(t1-t2) > 0)
		val2 = interp1(t2,val2,t1,'linear',NaN);
	end
	% interpolate in space
	if (norm(obj1.n-obj2.n) > 0 || norm(obj1.X-obj2.X) > 0)
		ip2  = scatteredInterpolant([flat(obj2.XX) flat(obj2.YY)],flat(val2),'linear','nearest');
		val2 = ip2([flat(obj1.XX),flat(obj1.YY)]);
	end
	end
	d    = val2-val1; 
end % compare

