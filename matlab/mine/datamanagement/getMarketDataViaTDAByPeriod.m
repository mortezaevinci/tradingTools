function [data,jdata] = getMarketDataViaTDAByPeriod(symbol, periodType,date1,date2,frequencyType,frequency,apikey)
  %periodType=day month year ytd
%period number
%frequencyType=minute daily weekly monthly
%frequency 1 5 10 15 30
%endDate
   %https://api.tdameritrade.com/v1/marketdata/AAPL/pricehistory?apikey=9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS&periodType=day&period=1&frequencyType=minute&frequency=1
jdata=[];
dta=[];
   try
    % startdate =1000* posixtime(datetime([datestring ' 11:30:00']));
    % enddate =1000* posixtime(datetime([datestring ' 20:00:00']));
     
    t1=datetime(date1,'TimeZone','America/New_York');
    [dt,~] = tzoffset(t1);
    hh=-hours(dt);
     startdate = 1000* posixtime(datetime(date1)+hours(hh));
     enddate =1000*  posixtime(datetime(date2));%+hours(4));
     
     if (startdate<0);startdate=0;end
     
     sd=num2str(uint64(startdate));
     ed=num2str(uint64(enddate));
  
    uri = matlab.net.URI(['https://api.tdameritrade.com/v1/marketdata/', upper(symbol) '/pricehistory?'],...
        'periodType',periodType,...
        'apikey',apikey,...
        'startDate',sd,...
        'endDate',ed,...
        'frequencyType',frequencyType, ...  
        'frequency',frequency,...
        'needExtendedHoursData','true');
    
    options = matlab.net.http.HTTPOptions('ConnectTimeout', 20,...
        'DecodeResponse', 1, 'Authenticate', 0, 'ConvertResponse', 0);


    requestObj = matlab.net.http.RequestMessage(); 
    requestObj = requestObj.addFields(matlab.net.http.field.GenericField('User-Agent', 'Mozilla/68.0'));
    
    
    [response, ~, ~]  = requestObj.send(uri, options);
    if(strcmp(response, 'NotFound'))
        disp('No data available');
        data = [];
        jdata=[];
    else
         jdata=response.Body.Data;
        data = formTableFromJson(jdata);
    end
   catch
        disp('Could not receive TDA data.');
        data=[];
        jdata=[];
   end
end

%% Convert data to the table format
function procData = formTableFromJson(jdata)
try
    
    jdcr=jsondecode(jdata);
    jct=struct2table(jdcr.candles);
   
jct.datetime = datetime(jct.datetime/1000, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SSS','TimeZone','America/New_York');

%setfirstmarkettime
dm=datetime([datestr(jct.datetime(1),'yyyy-mm-dd') ' 09:30:00'],'TimeZone','America/New_York');


   % dt=datestr(datetime(jdcr.timestamp, 'ConvertFrom', 'posixtime')-hours(4));
    procData=table(jct.datetime,jct.open,jct.high,jct.low,jct.close,jct.close,jct.volume,seconds(jct.datetime-dm),'VariableNames',{'Date','Open','High','Low','Close','AdjClose','Volume','Seconds'});
catch
    disp('Could not parse TDA data.');
    procData=[];
end
end
