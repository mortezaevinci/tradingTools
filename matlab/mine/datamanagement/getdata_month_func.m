function [failed,rq,c]=getdata_month_func(looperEngine,params,rq,c)
  try  
      version='yahoo';
          date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
         
  % [tmo,jmo,~,~]=getMarketDataViaYahooChart(symbol, '1y', '1mo',rq,c); 
     [tmo,jmo,rq,c]=getMarketDataViaYahooByPeriod(params.contract.Symbol, date1,date2, '1mo',rq,c);    
   if (isempty(tmo))
        failed=1;
    else
   
   save(name,'tmo','jmo','version');
   end
   catch exception
        disp([params.contract.Symbol ' monthly data not downloaded properly.']);
        failed=1;
  end
     
end