clear all

d='z:\My files\Project Trading\traderdata\data_other\IB\';
dirs=dir(d);
dirs(~[dirs.isdir]) = [];
for j=1:numel(dirs)
   
    newd=[d dirs(j).name '\'];
    fd=fullfile(newd, '*.mat');
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
            dtc=datetime("2021-05-07");
            dte=datetime("2021-06-09");
            if (dt0>dtc && dt0<dte)
            dt0
            if (  contains(fn,' minute') && ~contains(fn,'today'))
                
                
                
                   load(src);
                   if (~isempty(tmfull))
                       tmfull.Date=tmfull.Date-hours(3);
                       [tm,~]=getMarketTimeData(tmfull);
                       save(src,'tm','tmfull','version');
                   else
                        disp('unexpected file.');
                    
                    return;
                   end

            end
            
            if (  contains(fn,' daily') && ~contains(fn,'today'))
                
                   load(src);
                   if (~isempty(td))
                       td.Date=td.Date-hours(td.Date(1).Hour);
                       save(src,'td','version');
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