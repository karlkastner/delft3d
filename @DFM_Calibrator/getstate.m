% Thu  1 Sep 16:36:02 CEST 2016
function state = getstate(outfolder)
	statefile_str = [outfolder,filesep,'state.txt'];
	if (exist(statefile_str,'file'));
		state=chomp(fileread(statefile_str));
	else
		state=[];
	end
end

