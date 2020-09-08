% Mon 12 Feb 11:24:49 CET 2018
function	obj1 = cat(obj1,obj2)

		field = struct();
                           field.time = 1;
                       field.timestep = 1;
                field.mesh2d_Numlimdt = 2;
                      field.mesh2d_s1 = 2;
              field.mesh2d_waterdepth = 2;
                      field.mesh2d_u1 = 2;
                     field.mesh2d_ucx = 2;
                     field.mesh2d_ucy = 2;
                    field.mesh2d_ucxq = 2;
                    field.mesh2d_ucyq = 2;
                      field.mesh2d_q1 = 2;
                    field.mesh2d_taus = 2;
                     field.mesh2d_czs = 2;
                 field.mesh2d_spircrv = 2;
                 field.mesh2d_spirint = 2;
                         field.morfac = 1;
                          field.morft = 1;
                      field.mesh2d_ws = 3;
                  field.mesh2d_rsedeq = 3;
              field.mesh2d_fraction01 = 2;
                  field.mesh2d_z0ucur = 2;
                  field.mesh2d_z0urou = 2;
                     field.mesh2d_ssn = 3;
                     field.mesh2d_sst = 3;
                     field.mesh2d_sbn = 3;
                     field.mesh2d_sbt = 3;
                   field.mesh2d_sxtot = 3;
                   field.mesh2d_sytot = 3;
                  field.mesh2d_mor_bl = 2;
                  field.mesh2d_bodsed = 3;
                   field.mesh2d_dpsed = 2;

		field_C = fieldnames(field);
		for idx=1:length(field_C)
			obj1.map.(field_C{idx}) = cat(field.(field_C{idx}),obj1.map.(field_C{idx}),obj2.map.(field_C{idx}));
		end
end

