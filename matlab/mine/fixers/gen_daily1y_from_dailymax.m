clear all
%  doesn't really work because the SMART exchange thingy gets results from
%  different exchanges depending on length of historical data
ftype='daily max';
fdes='daily 1y';
d='z:\My files\Project Trading\traderdata\data_other\IB\';
dirs=dir(d);
dirs(~[dirs.isdir]) = [];


for j=1:numel(dirs)
    fsymbol=dirs(j).name;
    newd=[d dirs(j).name '\'];
    fd=fullfile(newd, ['*' ftype '*.mat']);
    files = dir(fd);
    ismatch=0;
    for i=1:numel(files)
        try
            fn=files(i).name;
            src=[newd  fn];
            
            load(src);
            td1=td;
            ntd=size(td1,1);
            for k=ntd:-1:253
                date0=datestr(td1.Date(k),'yyyy-mm-dd');
                
                td=td1((k-251):k,:);
                fn=[newd fsymbol ' ' fdes ' ' date0 '.mat'];
                if (ismatch)
                if (~exist(fn))
                    version='ibproc';
                    save(fn,'td','version');
                end
                else
                    if (exist(fn))
                        tdb=td;
                        load(fn);
                        if (sum(tdb.Volume-td.Volume)==0)
                            ismatch=1;
                        end 
                    end
                end
                
            end
            
        catch exception
            exception
        end
    end
    
end