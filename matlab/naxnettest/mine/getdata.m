function [tm,jm,td,jd,tmo,jmo]=getdata(symbol)

try
[tm,jm,rq,c]=getMarketDataViaYahooChart(symbol, '1d', '1m');
[td,jd,~,~]=getMarketDataViaYahooChart(symbol, '1mo', '1d',rq,c); 
[tmo,jmo,~,~]=getMarketDataViaYahooChart(symbol, '1y', '1mo',rq,c); 
catch exception
getReport(exception,'extended','hyperlinks','off')
tm=[];jm='';
td=[];jd='';
tmo=[];jmo='';
end
end