% Fri 18 Nov 17:32:37 CET 2016
% Karl Kastner, Berlin

function shp = read_pli(name)
	id = 0;
	shp = struct();
	shp.Geometry='Line';
%	fid = fopen(name);
        line_C = textread(name, '%s', 'delimiter', '\n');                   
%        fclose(fid);
	
	state = 'READ_NAME';
	for ldx=1:length(line_C)
%	state
%	line_C{ldx}
%	pause
	switch (state)
	case {'READ_NAME'}
		name = line_C{ldx};
		state = 'READ_N';
	case {'READ_N'}
		n    = sscanf(line_C{ldx},'%d %d'); 
		nrow = n(1)
		irow = 0;
		X = [];
		Y = [];
		state = 'READ_COORD';
	case {'READ_COORD'}
		irow = irow+1;
		xy = sscanf(line_C{ldx},'%e\s*%e');
		%fscanf(fid,'%e\s%e'); 
		X(irow) = xy(1);
		Y(irow) = xy(2);
		if (nrow == irow)
			id = id+1;
			shp(id).X=X;
			shp(id).Y=Y;
			state='READ_NAME';
		end
	otherwise
		error('here');
	end % switch
	end % for ldx
	
end % read_pli

