clear all

d='z:\My files\Project Trading\traderdata\data_other\IB\';
dirs=dir(d);
dirs(~[dirs.isdir]) = [];
for j=1:numel(dirs)
   
    newd=[d dirs(j).name '\'];
    fd=fullfile(newd, '*minute 2022-05-*.mat');
    files = dir(fd);
    for i=1:numel(files)
        try
            clear version;
            clear tmfull;
            clear td;
            clear tm;
            fn=files(i).name;
            src=[newd  fn];
            
            ff = dir(src);
            dt0=datetime(ff.date);
            dtc=datetime("2022-05-04");
            dte=datetime("2022-05-31");
            if (dt0>dtc && dt0<dte)
            dt0
            if (  contains(fn,' minute') && ~contains(fn,'today'))
                
                   load(src);
                   if (~isempty(tmfull))
                       mm = 60*hour(tmfull.Date(1)) +  minute(tmfull.Date(1));
                       mm1 = 1 + 60*hour(tmfull.Date(end)) +  minute(tmfull.Date(end));
                       if ( mm == 60 || mm == 390 || mm1 == 780 || mm1 == 1020)
                       tmfull.Date=tmfull.Date+hours(3);
                       [tm,~]=getMarketTimeData(tmfull);
                       save(src,'tm','tmfull','version');
                       else
                           mm
                           mm1
                       end
                   else
                        disp('unexpected file.');
                    
                    return;
                   end

            end
            
            end
            
        catch exception
            
        end
    end
    
end