function [tm,rq,c] =getdata_realtime_func(symbol,rq,c)
  
try
    if (isempty(c) || isempty(rq))
   [tm,jm,rq,c]=getMarketDataViaYahooChart(symbol, '5m', '1m'); 
    else
     [tm,jm,rq,c]=getMarketDataViaYahooChart(symbol, '5m', '1m',rq,c);   
    end
catch
   rq=[];
   c=[];
end
end