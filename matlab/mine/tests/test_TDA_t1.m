symbol='AAPL';
apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='day';
period=1;
frequencyType='minute';
frequency=1;

%[tm,jm] = getMarketDataViaTDA(symbol, periodType,period,frequencyType,frequency,apikey);


datestring='2020-06-02';

[tmfull,jmfull] = getMarketDataViaTDAByPeriod(symbol, periodType,datestring,frequencyType,frequency,apikey);

 startmarkettime =(datetime([datestring ' 9:30:00']));
 endmarkettime =(datetime([datestring ' 16:00:00']));
 
 inds=find(tmfull.Date>=startmarkettime & tmfull.Date<endmarkettime);
  tm=tmfull(inds,:);