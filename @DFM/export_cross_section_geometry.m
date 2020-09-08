% Fri 18 Nov 10:19:47 CET 2016
% Karl Kastner, Berlin

function export_cross_section_geometry(name,Xc,Yc,Fc,X,Y,Z)
	% TODO no magic numbers
	PROFTYPE_XYZ=201;

	n = size(Xc,1);
	id = (1:n)';

	% export profile type
	% XXXX_profdef.txt
	% PROFNR=id	TYPE=201
	fid = fopen([name,'_profdef.txt'],'w');
	if (fid < 1)
		error('here');
	end
	fprintf(fid,'PROFNR=%d\tTYPE=%d FRCCF=%f\n',[id PROFTYPE_XYZ*ones(n,1) cvec(Fc)]');
	fclose(fid);
	
	% export profile location
	% XXXX_profloc.xyz
	% x, y, id
	fid = fopen([name,'_profloc.xyz'],'w');
	if (fid < 1)
		error('here');
	end
	fprintf(fid,'%f %f %d\n',[Xc,Yc,id]');
	fclose(fid);

	% export actual profile
	% XXX.xyzprof
	fid = fopen([name,'.xyzprof'],'w');
	if (fid < 1)
		error('here');
	end
	fprintf(fid,['PROFNR=%d\n',   ...
                '2 3\n',         ... % nrow ncol
		'%f %f %f\n',    ... % left bank coordinates
		'%f %f %f\n\n'],  ... % right bank coordinates
		[id,X(:,1),Y(:,1),Z(:,1),X(:,2),Y(:,2),Z(:,2)]');
	fclose(fid);
end % export_cross_section 

