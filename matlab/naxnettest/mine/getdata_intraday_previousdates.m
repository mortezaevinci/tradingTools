%collect 1min data every weekend before they become unavailable
days_=5;5:-1:1;
d1='2020-06-';

symbols={'TLT','^TNX','^VIX','AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','NOW','SHOP','WMT','LITE','BYND','SHOP','MRNA','MSFT','NVDA','NFLX','F','GE', 'DIS','FB','EEM','GOOGL','INTC','KO','BSX','PENN','C','T','HPE','NOK','SAVE','WORK','INO','CRON','HAL','VZ','V','BABA',    'GLD','SLV','USO','SPY','OXY','IWM','UCO','UAL','SHIP','DAL','QQQ','SQQQ','M','XIU.TO','VCN.TO','XUU.TO','ZAG.TO','ZCN.TO','ZSP.TO','VFV.TO','HXT.TO','XEG.TO','HUV.TO','HUC.TO','^DJI','^IXIC','N225','^HSI','^FTSE','^RUT','A1CYC','AXJO','^BCOMWH5T','^COMP','^DWCRTS','^DVG','^FVX','^FNMR','^FTMX','JNUG','NUGT','^HSIL','^LOVOL','^MNX','^NDX','^OVX','^PUT'};
rq=[];
c=[];


for i=days_

date1=[d1 num2str(i,'%02.f')];
date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');

for i=1:numel(symbols)
	try

	 name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbols{i}) ' minute ' date1 '.mat'];
if (~exist(name) && isbusday(date1))

    symbols{i}
   [tm,jm,rq,c]=getMarketDataViaYahooByPeriod(symbols{i}, date1,date2, '1m',rq,c); 
   if (~isempty(tm))
  
   save(name,'tm','jm');
   end
end
   catch 

   end
end

end
%mm=table2timetable(tm)