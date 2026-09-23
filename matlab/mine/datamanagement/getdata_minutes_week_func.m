function [failed,rq,c]=getdata_minutes_week_func(looperEngine,params,rq,c)

 try
     version='yahoo';
     date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
    
     
     dates=datetime(date1):datetime(date2);
     for i=1:numel(dates)-1
     
        % istoday_loop=datetoday.Day==dates(i).Day & datetoday.Month==dates(i).Month & datetoday.Year==dates(i).Year ;
         date1s=datestr(dates(i),'yyyy-mm-dd');
         date2s=datestr(dates(i+1),'yyyy-mm-dd');
         isweekday=isbusday(dates(i));
         
         name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' date1s '.mat'];
         if (((~dateistoday) && ~exist(name)) && (isweekday))
          disp(['getting prev days ' datestr(date1s) ]);
         %disp(name);
    [tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(params.contract.Symbol, date1s,date2s, '1m',rq,c);  
   
   
    if (~isempty(tmfull))
        [tm,jm]=getMarketTimeData(tmfull);
       save(name,'tm','tmfull','jm','jmfull','version');
       
    else
        failed=1;
    end
    
     end
    
     end
    
    
     catch
        disp([symbol ' minute weekly data not downloaded.']);
        failed=1;
 end
    
end