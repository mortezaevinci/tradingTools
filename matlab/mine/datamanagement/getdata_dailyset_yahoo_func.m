function getdata_dailyset_yahoo_func(basedir,contracts,date0,ndays,inname)

date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd')
date1=datestr(datetime(date2)-days(ndays),'yyyy-mm-dd')

c=[];
rq=[];
version='yahoo';
for i=1:numel(contracts)
    
    try
        name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' daily ' inname ' ' date0 '.mat'];
        
        if (~exist(name) && isbusday(datetime(date0)))
            disp( [contracts{i}.Symbol version ' from ' datestr(date1) ' to ' datestr(date2)]);
            
            [td,jd,rq,c]=getMarketDataViaYahooByPeriod(contracts{i}.Symbol, date1,date2, '1d',rq,c);
            if (~isempty(td))
                
                directory_=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\'];
                if (~exist(directory_))
                    mkdir(directory_);
                end
                
                save(name,'td','jd','version');
                
            else
                disp('could not grab data.');
                
                pause(0.05);
            end
        end
        
    catch exception
        
    end
end


end