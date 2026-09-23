
date='2020-08-20';%datestr(datetime()-days(1),'yyyy-mm-dd');

for i=1:10
    h(i)=figure;
end

cnt=1;

for di=0:0;%60
    
    datedate=dbase-days(di)
    
    if (isbusday(datedate))
        date=datestr(datedate,'yyyy-mm-dd');
        %% init
        
      
        
        basedir='Z:\My files\Project trading\traderdata\data\';
        processdir='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
        
         contracts_nasdaq;
     
        ncontracts=numel(contracts);
        
      
        
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol;
            %disp(symbol);
            
            
            if (true)%exist(trendprofiflename))
               
                try
                    
                    fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];
                    if (exist(fn))
                    load(fn);
                    params.TimeTables.Day=table2timetable(td);
                    symbol
                    
                    figure(h(cnt));
                    cnt=cnt+1;
                    if (cnt>9)
                    cnt=1;
                    end
                 cndl5( params.TimeTables.Day);
                 ylim([min(params.TimeTables.Day.Low),max(params.TimeTables.Day.High)]);
title(symbol);
                 pause
                   
                    
                    end    
                    
                catch exception
                    dumpReport('error.log', exception)
                    
                 end
                
            else
                %disp('Does not exists');
                
            end
        end
      
       
        
        
    end
    
end