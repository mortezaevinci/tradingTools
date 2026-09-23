function [tm,rq,c] =getdata_realtime_func(FileSymbol,rq,c)
  
try
    if (isempty(c) || isempty(rq))
   [tm,jm,rq,c]=getMarketDataViaYahooChart(FileSymbol, '5m', '1m'); 
    else
     [tm,jm,rq,c]=getMarketDataViaYahooChart(FileSymbol, '5m', '1m',rq,c);   
    end
catch
   rq=[];
   c=[];
end
end