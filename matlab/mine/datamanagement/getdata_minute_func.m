function [failed,rq,c]=getdata_minute_func(looperEngine,params,name,rq,c)

        try
         version='yahoo';
       % [tm,jm,rq,c]=getMarketDataViaYahooChart(symbol, params.todayDataPeriod, '1m',rq,c);   
        [tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(params.contract.Symbol, looperEngine.date,looperEngine.dateMinutesNextDay, '1m',rq,c);   
        
    currentdatetime=datetime();
    refdatetime=datetime([datestr(currentdatetime(),'yyyy-mm-dd') ' 09:30:00']);
    if (~isempty(tmfull) || (dateistoday && currentdatetime<refdatetime)) %or is pre-market of today
        [tm,jm]=getMarketTimeData(tmfull);
           %xxxmor, temporary solution for real-time data not including
            %previous day if not asked for
             if (dateistoday)
                 try  %just to bypass empty tm
                  dd=datetime(looperEngine.date);
                 tm(tm.Date<dd,:)=[];
                 catch
                 end
             end
 
      save(name,'tm','tmfull','jm','jmfull','version');
       
    else
        failed=1;
    end
  
        catch 
           disp('Could not recieve intraday.') 
        end
        
end