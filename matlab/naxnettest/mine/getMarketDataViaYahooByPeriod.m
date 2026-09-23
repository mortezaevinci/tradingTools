function [data,jdata,requestObj,crumb] = getMarketDataViaYahooByPeriod(symbol,date1,date2, interval,requestObjIn,crumbin)
    % Downloads market data from Yahoo Finance for a specified symbol and 
    % time range.
    % 
    
    % get [t,j,rq,c]=getMarketDataViaYahooChart('AAPL', '1d', '1m',rq,c)
    % to establish communication
    % next times rq and c are already available
    
    %[tm,jm,rq,c]=getMarketDataViaYahooChart('AAPL', '5d', '1m',rq,c);
    %[td,jd,rq,c]=getMarketDataViaYahooChart('AAPL', '1mo', '1d',rq,c);
    %[tmo,jmo,rq,c]=getMarketDataViaYahooChart('AAPL', '1y', '1mo',rq,c);
    %to get real-time and append
    %[tm,jm,rq,c]=getMarketDataViaYahooChart('AAPL', '5m', '1m',rq,c); %gives
    %last 5 data in 1 min as a fast as possible for updating real-time
    
    
    % INPUT:
    % symbol    - is a ticker symbol i.e. 'AMD', 'BTC-USD'
    % startdate - the date from which the market data will be requested
    % enddate   - the market data will be requested till this date
    % interval  - the market data will be returned in this intervals
    % supported intervals are '1d', '5d', '1wk', '1mo', '3mo'
    %
    % Example: 
    %   data = getMarketDataViaYahoo('AMD', '1-Jan-2018', datetime('today'), '5d');
    % 
    % Author: Artem Lenskiy, PhD
    % Version: 0.91
    %
    % Special thanks to Patryk Dwórznik (https://github.com/dworznik) for
    % a hint on JavaScript processing. 
    %
    % Alternative approach is given here
    % https://stackoverflow.com/questions/50813539/user-agent-cookie-workaround-to-web-scraping-in-matlab
    
     %datestring='2020-06-02';
     startdate = posixtime(datetime(date1));
     enddate = posixtime(datetime(date2));

 if (startdate<0);startdate=0;end
     
     sd=num2str(uint64(startdate), '%.10g');
     ed=num2str(uint64(enddate), '%.10g');
    
    
    if (nargin()<=3)
        
    %% Construct an URL to obtain the crumb value that is linked to the session cookie. 
    % It could be important to request data for the same range, however to
    % save bandwidth and time, request data for one day.
   % uri = matlab.net.URI(['https://finance.yahoo.com/quote/', upper(symbol), '/history'],...
   uri = matlab.net.URI(['https://query1.finance.yahoo.com/v7/finance/chart/', upper(symbol)],...
          'period1',  sd,...
        'period2',  ed,...
        'interval', interval,...
        'frequency', interval,...
        'guccounter', 1);

    options = matlab.net.http.HTTPOptions('ConnectTimeout', 20, 'DecodeResponse', 1, 'Authenticate', 0, 'ConvertResponse', 0);
    %% Extract the crumb value 
    % The ideas is taken from here:
    % http://blog.bradlucas.com/posts/2017-06-02-new-yahoo-finance-quote-download-url/
    % The while loop is used to make sure that generated crumb value does
    % not contains '\', since requestObj.send does not correctly send URLs
    % with slash
    %;tic
    crumb = "\";
    cnt=0;
    while(contains(crumb, '\') && cnt<2)
        cnt=cnt+1;
        requestObj = matlab.net.http.RequestMessage();
         requestObj = requestObj.addFields(matlab.net.http.field.GenericField('User-Agent', 'Mozilla/68.0'));
        [response, ~, ~]  = requestObj.send(uri, options);
        ind = regexp(response.Body.Data, '"CrumbStore":{"crumb":"(.*?)"}');
        if(isempty(ind))
            %disp(['Possibly ', symbol ,' is not found']);
        else
        crumb = response.Body.Data.extractBetween(ind(1)+23, ind(1)+33);
        end
    end
    if (strcmp(crumb,"\"))
       crumb=[]; 
    end
    %;ticyahoocrumb=toc
    %% Find the session cookie
    % The idea is taken from here:
    % https://stackoverflow.com/questions/40090191/sending-session-cookie-with-each-subsequent-http-request-in-matlab?rq=1

    % It is important: 
    %       (1) to add session cookie that matches crumb values;
    %       (2) specify UserAgent
    if (isempty(ind))
        requestObj=[];
    else
        
    setCookieFields = response.getFields('Set-Cookie');
    setContentFields = response.getFields('Content-Type');
    if ~isempty(setCookieFields)
       cookieInfos = setCookieFields.convert(uri);
       contentInfos = setContentFields.convert();
       requestObj = requestObj.addFields(matlab.net.http.field.CookieField([cookieInfos.Cookie]));
       requestObj = requestObj.addFields(matlab.net.http.field.ContentTypeField(contentInfos));
       requestObj = requestObj.addFields(matlab.net.http.field.GenericField('User-Agent', 'Mozilla/68.0'));
    else
        disp('Check ticker symbol and that Yahoo provides data for it');
        data = [];
        jdata=[];
        return;
    end
    end
    else
        requestObj=requestObjIn;
        crumb=crumbin;
    end
 
%%
%https://query1.finance.yahoo.com/v7/finance/chart/AAPL?range=1d&interval=1m&indicators=quote&includeTimestamps=true&crumb=I.2cJh8rh.E


    %% Send a request for data
    % Construct an URL for the specific data
    if (isempty(crumb))
         uri = matlab.net.URI(['https://query1.finance.yahoo.com/v7/finance/chart/', upper(symbol) ],...
          'period1',  sd,...
        'period2',  ed,...
        'interval', interval,...
        'indicators','quote',...
        'includeTimestamps','true', ...  
        'literal');
    else
    uri = matlab.net.URI(['https://query1.finance.yahoo.com/v7/finance/chart/', upper(symbol) ],...
          'period1',  sd,...
        'period2',  ed,...
        'interval', interval,...
        'indicators','quote',...
        'includeTimestamps','true',...
        'crumb',    crumb,...
        'literal');
    end
    
    
    options = matlab.net.http.HTTPOptions('ConnectTimeout', 20,...
        'DecodeResponse', 1, 'Authenticate', 0, 'ConvertResponse', 0);

    if (isempty(requestObj))
       requestObj = matlab.net.http.RequestMessage(); 
        requestObj = requestObj.addFields(matlab.net.http.field.GenericField('User-Agent', 'Mozilla/68.0'));
    end
    
    [response, ~, ~]  = requestObj.send(uri, options);
    if(strcmp(response, 'NotFound'))
        disp('No data available');
        data = [];
        jdata=[];
    else
         jdata=response.Body.Data;
        data = formTableFromJson(jdata);%formTable(response.Body.Data);

        if (isempty(data))
disp([symbol ' at ' date1,' ',date2,' ' ,num2str(interval)])
        end
       %disp('Received data');
    end
end

%% Convert data to the table format
function procData = formTableFromJson(jdata)
try
    
    jdcr=jsondecode(jdata).chart.result;
    jdcq=jdcr.indicators.quote;
    dt=datestr(datetime(jdcr.timestamp, 'ConvertFrom', 'posixtime')-hours(4));
    procData=table(dt,jdcq.open,jdcq.high,jdcq.low,jdcq.close,jdcq.close,jdcq.volume,jdcr.timestamp-jdcr.timestamp(1),'VariableNames',{'Date','Open','High','Low','Close','AdjClose','Volume','Seconds'});
catch
    disp('Could not parse Yahoo chart data.');
    procData=[];
end
end
