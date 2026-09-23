%collect 1min data every weekend before they become unavailable

symbols={'TLT','^TNX','^VIX','AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','NOW','SHOP','WMT','LITE','BYND','MRNA','MSFT','NVDA','NFLX','F','GE', 'DIS','FB','EEM','GOOGL','INTC','KO','BSX','PENN','C','T','HPE','NOK','SAVE','WORK','INO','CRON','HAL','VZ','V','BABA',    'GLD','SLV','USO','SPY','OXY','IWM','UCO',    'UAL','SHIP','DAL','QQQ','SQQQ','M',    'XIU.TO','VCN.TO','XUU.TO','ZAG.TO','ZCN.TO','ZSP.TO','VFV.TO','HXT.TO','XEG.TO','HUV.TO','HUC.TO','^DJI','^IXIC','N225','^HSI','^FTSE','^RUT','A1CYC','AXJO','^BCOMWH5T','^COMP','^DWCRTS','^DVG','^FVX','^FNMR','^FTMX','JNUG','NUGT','^HSIL','^LOVOL','^MNX','^NDX','^OVX','^PUT'};

[t,j,rq,c]=getMarketDataViaYahooChart('AAPL', '5d', '1d');

for i=1:numel(symbols)
    symbols{i}
   [td,jd,~,~]=getMarketDataViaYahooChart(symbols{i}, '5d', '1d',rq,c); 
   name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbols{i}) ' daily 5d ' datestr(datetime(),"yyyy-mm-dd") '.mat'];
   save(name,'td','jd');
end