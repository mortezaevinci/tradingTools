function [failed,rq,c]=getdata_daily_func(looperEngine,params,name,rq,c)

 try      
    date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays

   % [td,jd,rq,c]=getMarketDataViaYahooChart(symbol, '1y', '1d',rq,c);   
   
    [td,jd,rq,c]=getMarketDataViaYahooByPeriod(params.contract.Symbol, date1,date2, '1d',rq,c);    
    if (isempty(td))
        failed=1;
    else
   %name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 1y ' looperEngine.date '.mat'];

   save(name,'td','jd','version');
    end
     catch
        disp([params.contract.Symbol ' daily data not downloaded properly.']);
        failed=1;
 end
     
end