function v = pred(v)
	d=diff(v);
	%d=d(:,1:end);
	l = 1;
	p=(d(end,:)./d(end-l,:)).^(1/l);
	p(p>1)=NaN;
 	d(end,:)
 	d =d(end,:).*(p./(1-p)),
 	v(end,:)
	v = v(end,:) + d;
end
