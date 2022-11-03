% Wed 18 Jul 14:06:41 CEST 2018
function stat = init(obj)
	% clear
	% TODO, reset tmp vars
	obj.map   = [];
	stat = 0;
%	if (strcmp(obj.folder_(end-2:end),'dat'))
%		path = folder_;
%	else
%	try
		path_a = dir([obj.folder,'/trim-',obj.runid,'.dat']);
		%path = ls([folder_,'/trim-',runid,'.dat']);
		%path = chomp(path);
		if (isempty(path_a))
			path_a = dir([obj.folder,'/*/trim-',obj.runid,'.dat']);
		end
%	catch e1
%		try
%			%path = ls([folder_,'/*/trim-delft3d.dat']);
%			%path_C = strsplit(path,'\n');
%			path = path_C{1};
%			path = chomp(path);
%		catch e2
%			disp(e1)
%			disp(e2)
%			stat = -1;
%			return;
%		end
%	end
%	end
	switch (length(path_a))
	case {0}
		error('no dat file found');
	case {1}
		% unique
	case {2}
		fprintf('more than one dat file found, loading first');
	end
	obj.map   = vs_use([path_a(1).folder,filesep,path_a(1).name],obj.vsopt);
%	try
%		gsd = load([folder_,'/gsd.csv']);
%		obj.gsd.d = gsd(1,:);
%		obj.gsd.p = gsd(2,:); 
%	catch e
%		e
%	end

	% init mesh
	obj.X();
end

