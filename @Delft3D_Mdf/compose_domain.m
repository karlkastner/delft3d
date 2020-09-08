% Wed 23 May 20:25:42 CEST 2018
function smesh = compose_domain(folder,name_C,ddb_str,ds_max)
	fid = fopen([folder,filesep,ddb_str],'w');
	for idx=1:length(name_C)
		sm(idx) = SMesh();
		sm(idx).read_grd([folder,filesep,name_C{idx}]);
		sm(idx).plot();
		hold on
		for jdx=1:idx-1
			[id, jd] = sm(idx).snap(sm(jdx),ds_max,true);
			for kdx=1:size(id,1)
				% fprintf(fid,'%s %d %d %d %d %s %d %d %d %d\n',name_C{idx},id(kdx,:), name_C{jdx},jd(kdx,:));
				fprintf(fid,'%s %d %d %d %d %s %d %d %d %d\n',name_C{idx},id(kdx,[2,1,4,3]), name_C{jdx},jd(kdx,[2,1,4,3]));
			end % for kdx
		end % for jdx
		sm(idx).export_grd([folder,filesep,name_C{idx}]);
	end % for idx
	fclose(fid);
end % smesh

