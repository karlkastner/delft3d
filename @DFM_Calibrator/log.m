function obj = log(obj,format_str,varargin)
	fprintf(obj.log_fid, format_str, varargin{:});
end

