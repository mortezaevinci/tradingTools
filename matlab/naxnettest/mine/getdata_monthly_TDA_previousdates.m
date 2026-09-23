%collect 1min data every weekend before they become unavailable
month_=12:-1:1;
d1='2020-';

symbols={'TLT','TNX','VIX','AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','NOW','SHOP','WMT','LITE','BYND','SHOP','MRNA','MSFT','NVDA','NFLX','F','GE', 'DIS','FB','EEM','GOOGL','INTC','KO','BSX','PENN','C','T','HPE','NOK','SAVE','WORK','INO','CRON','HAL','VZ','V','BABA','GLD','SLV','USO','SPY','OXY','IWM','UCO','UAL','SHIP','DAL','QQQ','SQQQ','M','$DJI','N225.JP','$HSI','RUT','$A1CYC','$BCOMWH5T','COMP','$DWCRTS','DVG','FVX','FNMR:FTSE','FTMX','JNUG','NUGT','LOVOL','MNX','NDX','OVX','PUT','$PCSP','$TICK','$ADD','$VOLD','TVIX'};

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='year';
period=1;
frequencyType='monthly';
frequency=1;

currentmonth=datetime().Month;


for i=month_
    if (i<=currentmonth)
        
date0=[d1 num2str(i,'%02.f') '-01'];

 date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd');
 date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');
     
for i=1:numel(symbols)
    
   try
        name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbols{i}) ' monthly ' date0(1:7) '.mat'];
        
        if ((~exist(name) || i==currentmonth) )
        symbols{i}
    [tmo,jmo] = getMarketDataViaTDAByPeriod( symbols{i}, periodType,date1,date2,frequencyType,frequency,apikey);
   if (~isempty(tmo))
    % [tm,jm]=getMarketTimeData(tmfull);
 
  
   save(name,'tmo','jmo');
   
   else
       disp('coud not grab data.');
   end
        end
   
   catch
       
   end
end

    end

end
%mm=table2timetable(tm)