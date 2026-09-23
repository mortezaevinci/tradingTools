function [data,jdata] = getMarketDataViaTDA(symbol, periodType,period,frequencyType,frequency,apikey)
  %periodType=day month year ytd
%period number
%frequencyType=minute daily weekly monthly
%frequency 1 5 10 15 30
%endDate
   %https://api.tdameritrade.com/v1/marketdata/AAPL/pricehistory?apikey=9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS&periodType=day&period=1&frequencyType=minute&frequency=1

  
    uri = matlab.net.URI(['https://api.tdameritrade.com/v1/marketdata/', upper(symbol) '/pricehistory?'],...
        'apikey',apikey,...
        'periodType', periodType,...
        'period',period,...
        'frequencyType',frequencyType, ...  
        'frequency',frequency);
    
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
end

%% Convert data to the table format
function procData = formTableFromJson(jdata)
try
    
    jdcr=jsondecode(jdata);
    jct=struct2table(jdcr.candles);
   
jct.datetime = datetime(jct.datetime/1000, 'convertfrom', 'posixtime', 'Format', 'MM/dd/yy HH:mm:ss.SSS','TimeZone','America/New_York');

   % dt=datestr(datetime(jdcr.timestamp, 'ConvertFrom', 'posixtime')-hours(4));
    procData=table(jct.datetime,jct.open,jct.high,jct.low,jct.close,jct.close,jct.volume,jct.datetime-jct.datetime(1),'VariableNames',{'Date','Open','High','Low','Close','AdjClose','Volume','Seconds'});
catch
    disp('Could not parse Yahoo chart data.');
    procData=[];
end
end
