%Tue 10 Dec 15:30:50 +08 2019
function export_trt(obj,base,type,n)
	type = obj.tratype;
	n    = obj.mesh.n;

	fid = fopen([base,'.tra'],'w');
	fprintf(fid,'%d %d\n',1,type);
	fclose(fid); 
	
	fid=fopen([base,'.trtu'],'w');
	area_fraction = 1.0;
	for idx=1:n(1)
		for jdx=1:n(2);
			fprintf(fid,'%4d %4d %d %f\n',idx,jdx,1,area_fraction); 
		end	
	end
	fclose(fid);
	
	fid=fopen([base,'.trtv'],'w');
	for idx=1:n(1)
		for jdx=1:n(2);
			fprintf(fid,'%4d %4d %d %f\n',idx,jdx,1,area_fraction); 
		end
	end
	fclose(fid);
end % export_trt

