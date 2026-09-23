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
            clear tm;
            if (  contains(files(i).name,' 5sec') && ~contains(files(i).name,'today'))
                fn=files(i).name;
                src=[newd  fn];
                
                p1 = split(fn,'5sec ');
                if (numel(p1)~=2)
                    disp('warning bad split');
                    
                    return;
                end
                p2=split(p1{2},'.m');
                if (numel(p2)~=2)
                    disp('warning bad split');
                    
                    return;
                end
                date0=(p2{1});
                
                
                dates=datetime(date0,'TimeZone','America/New_York');
                [dt,~] = tzoffset(dates);             
                gmcbad=(-hours(dt)==5);
                
                if (gmcbad)
                   load(src);
                   if (~isempty(tm))
                       tm.Date=tm.Date-hours(1);
                    
                       save(src,'tm','version');
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