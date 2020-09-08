% Wed 14 Feb 09:34:46 CET 2018
function	obj = resample(obj,dt_resample)
		mtime  = obj.mtime();
		T      = mtime(end)-mtime(1);
		nti     = round(T/dt_resample);
		mtimei = (0:nti)'*(T/nti);
		mtime = rvec(mtime) + (0:length(mtime)-1)*(T-mtime(1))*sqrt(eps);
		tdx = interp1(rvec(mtime),1:length(mtime),mtimei,'nearest');

		dimension = struct();
                           dimension.time = 1;
                       dimension.timestep = 1;
                dimension.mesh2d_Numlimdt = 2;
                      dimension.mesh2d_s1 = 2;
              dimension.mesh2d_waterdepth = 2;
                      dimension.mesh2d_u1 = 2;
                     dimension.mesh2d_ucx = 2;
                     dimension.mesh2d_ucy = 2;
                    dimension.mesh2d_ucxq = 2;
                    dimension.mesh2d_ucyq = 2;
                      dimension.mesh2d_q1 = 2;
                    dimension.mesh2d_taus = 2;
                     dimension.mesh2d_czs = 2;
                 dimension.mesh2d_spircrv = 2;
                 dimension.mesh2d_spirint = 2;
                         dimension.morfac = 1;
                          dimension.morft = 1;
                      dimension.mesh2d_ws = 3;
                  dimension.mesh2d_rsedeq = 3;
              dimension.mesh2d_fraction01 = 2;
                  dimension.mesh2d_z0ucur = 2;
                  dimension.mesh2d_z0urou = 2;
                     dimension.mesh2d_ssn = 3;
                     dimension.mesh2d_sst = 3;
                     dimension.mesh2d_sbn = 3;
                     dimension.mesh2d_sbt = 3;
                   dimension.mesh2d_sxtot = 3;
                   dimension.mesh2d_sytot = 3;
                  dimension.mesh2d_mor_bl = 2;
                  dimension.mesh2d_bodsed = 3;
                   dimension.mesh2d_dpsed = 2;

		field_C = fieldnames(dimension);
		for idx=1:length(field_C)
			switch (dimension.(field_C{idx}))
			case {1}
				obj.map.(field_C{idx}) = obj.map.(field_C{idx})(tdx,:,:);
			case {2}
				obj.map.(field_C{idx}) = obj.map.(field_C{idx})(:,tdx,:);
			case {3}
				obj.map.(field_C{idx}) = obj.map.(field_C{idx})(:,:,tdx);
			otherwise
				error('here');
		end
end

