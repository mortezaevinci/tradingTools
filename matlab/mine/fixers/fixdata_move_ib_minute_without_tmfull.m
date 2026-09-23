clear all

d='z:\My files\Project Trading\traderdata\data_other\IB\';
d2='z:\My files\Project Trading\traderdata\data_other\IB_tmonly\';
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
        if (  contains(files(i).name,' minute') && ~contains(files(i).name,'today'))
            isold=0;
            fn=files(i).name;
            src=[newd  fn];
            if (contains(fn,'2019') || contains(fn,'2018') || contains(fn,'2017')|| contains(fn,'2016') )
                isold=1;
            end
            if (isold==0)
            load(src);
            if (~exist('tmfull'))
               isold=1; 
            end
            end
            
            if (isold==1)
                %move file to d2
                d3=[d2 dirs(j).name '\'];
                if (~exist(d3))
                mkdir(d3);
                end
                des=[d3 fn];
                
                disp([src '->' des]);
                movefile(src,des);
                
            end
            
        end
        
        catch
            
        end
    end
    
end