% Mon  7 Sep 11:43:33 +08 2020
function default_bcc(obj)
	obj.bcc             = struct();
	Tstop = str2num(obj.mdf.mdf.dat.Tstop);
	for idx=1:length(obj.bct)
		obj.bcc(idx).location = obj.bct(idx).location;
		obj.bcc(idx).time = [0, Tstop/1440];
		obj.bcc(idx).val  = [0; 0];
		obj.bcc(idx).dt_d = 1;
	end
end % default_bcc

