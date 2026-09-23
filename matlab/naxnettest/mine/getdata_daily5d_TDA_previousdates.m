%collect 1min data every weekend before they become unavailable
days_=29:-1:1;
d1='2020-05-';

symbols={'TLT','TNX','VIX','AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','NOW','SHOP','WMT','LITE','BYND','SHOP','MRNA','MSFT','NVDA','NFLX','F','GE', 'DIS','FB','EEM','GOOGL','INTC','KO','BSX','PENN','C','T','HPE','NOK','SAVE','WORK','INO','CRON','HAL','VZ','V','BABA','GLD','SLV','USO','SPY','OXY','IWM','UCO','UAL','SHIP','DAL','QQQ','SQQQ','M','$DJI','RUT','$A1CYC','$BCOMWH5T','COMP','$DWCRTS','DVG','FVX','FNMR:FTSE','JNUG','NUGT','LOVOL','MNX','NDX','OVX','PUT','$PCSP','$TICK','$ADD','$VOLD','TVIX'};

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;

for i=days_
date0=[d1 num2str(i,'%02.f')];

 date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd')
 date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd')
     
for i=1:numel(symbols)
    
   try
        name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbols{i}) ' daily 5d ' date0 '.mat'];
        
        if (~exist(name) && isbusday(datetime(date0)))
        symbols{i}
    [tw,jw] = getMarketDataViaTDAByPeriod( symbols{i}, periodType,date1,date2,frequencyType,frequency,apikey);
   if (~isempty(tw))
    % [tm,jm]=getMarketTimeData(tmfull);
 
  
   save(name,'tw','jw');
   
   else
       disp('coud not grab data.');
   end
        end
   
   catch
       
   end
end

end
%mm=table2timetable(tm)