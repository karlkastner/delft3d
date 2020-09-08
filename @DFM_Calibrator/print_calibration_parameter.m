% Fri 13 Jan 09:16:01 CET 2017
% Karl Kastner, Berlin
% TODO this does not correctly work if different calibration sets calibrate different parameter
function obj = print_calibration_parameter(obj,val)
	T={};
	%format_str = '%32s';
	%format_str=[format_str,' %s'];
	np = sum(any(obj.id));
	format_str = ['%32s',repmat('%8s',1,np)];
	for idx=1:length(obj.reachpoly_C)
		Ti = {};
		% reach index
		rid = cvec([obj.reachpoly_C{idx}.id]);
		nr = length(rid); %obj.reachpoly_C{idx});
		% first column: name of calibration station
		% TODO, sort out duplicates
		[Ti{1,1:nr}] = deal(obj.reachpoly_C{idx}.Placename);
		% other columns: station values of each calibration parameter
		for jdx=1:length(obj.parameter_C)
			%par = obj.parameter_C{jdx};
			if (obj.id(rid(1),jdx) > 0)
			%~isempty(obj.id(idx).(par)))
				c=num2cell(val(obj.id(rid,jdx)));
				%c=num2cell(val(obj.id(idx).(par)));
				c=cellfun(@(x) num2str(x,'%7.3f'),c,'uniformoutput',false);
				[Ti{jdx+1,1:nr}] = deal(c{:});
			end % if
		end % for jdx
		T = horzcat(T,Ti);
	end % for idx
	[void uid] = unique(T(1,:));
	format_str = [format_str,'\n'];
	T = T(:,uid); %uid,:);
	fprintf(1,format_str,T{:});
end % print_calibration_parameter

