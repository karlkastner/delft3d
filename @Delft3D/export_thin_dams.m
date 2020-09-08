% Wed  1 Jul 11:09:20 +08 2020
function export_thin_dams(obj,file_str)
	td  = obj.thin_dams;

	%fid = fopen(obj.Filtd,'w');
	fid = fopen(file_str,'w');
	if (fid < 1)
		error('here');
	end

	for idx=1:length(td)
		pq = td(idx).pq;
		ij = obj.pq2ij(td(idx).pq);
		ij = ij';
		if (ij(1) == ij(3))
			if (ij(2) == ij(4))
				error('thin dam must be a line, not a point');
			end
			fprintf(fid,'%6d %6d %6d %6d U\n',ij);
		elseif (ij(2) == ij(4))
			fprintf(fid,'%6d %6d %6d %6d V\n',ij);
		else
			error('thin dams cannot be diagonal');
		end
	end % for idx
	fclose(fid);
end % export_thin_dams

