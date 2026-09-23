%collect 1min data every weekend before they become unavailable
days_=8;%30:-1:1;
d1='2020-06-';

symbols={'TLT','TNX','VIX','AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','NOW','SHOP','WMT','LITE','BYND','SHOP','MRNA','MSFT','NVDA','NFLX','F','GE', 'DIS','FB','EEM','GOOGL','INTC','KO','BSX','PENN','C','T','HPE','NOK','SAVE','WORK','INO','CRON','HAL','VZ','V','BABA','GLD','SLV','USO','SPY','OXY','IWM','UCO','UAL','SHIP','DAL','QQQ','SQQQ','M','$DJI','RUT','$A1CYC','$BCOMWH5T','COMP','$DWCRTS','DVG','FVX','FNMR:FTSE','JNUG','NUGT','LOVOL','MNX','NDX','OVX','PUT','$PCSP','$TICK','$ADD','$VOLD','TVIX'};
symbols={'AAPL'};

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='day';
period=1;
frequencyType='minute';
frequency=1;

for i=days_
date1=[d1 num2str(i,'%02.f')]
date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd')

%startmarkettime =(datetime([datestring ' 9:30:00']));
%endmarkettime =(datetime([datestring ' 16:00:00']));

for i=1:numel(symbols)
   
   try
        name=['Z:\My files\Project trading\traderdata\data\TDA\' filefriendlysymbol(symbols{i}) ' minute ' date1 '.mat'];
       if (~exist(name) && isbusday(date1))
        symbols{i}
       
    [tmfull,jmfull] = getMarketDataViaTDAByPeriod( symbols{i}, periodType,date1,date2,frequencyType,frequency,apikey);
   if (~isempty(tmfull))
     [tm,jm]=getMarketTimeData(tmfull);
 
  
   save(name,'tm','tmfull','jmfull');
   
   else
       disp('coud not grab data.');
   end
   
       end
   catch
       
   end
end

end
%mm=table2timetable(tm)