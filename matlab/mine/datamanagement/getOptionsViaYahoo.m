function [data,jdata,requestObj,crumb] = getOptionsViaYahooLast(symbol,requestObjIn,crumbin)
    
       data = [];
       jdata = [];
   
    
    if (nargin()<=1)
        
    %% Construct an URL to obtain the crumb value that is linked to the session cookie. 

     uri = matlab.net.URI(['https://query2.finance.yahoo.com/v7/finance/options/', upper(symbol)]);

    options = matlab.net.http.HTTPOptions('ConnectTimeout', 20, 'DecodeResponse', 1, 'Authenticate', 0, 'ConvertResponse', 0);
    %% Extract the crumb value 
   
    %%tic
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
    %%ticyahoocrumb=toc
    %% Find the session cookie
   
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
         uri = matlab.net.URI(['https://query2.finance.yahoo.com/v7/finance/options/', upper(symbol) ],'literal');
    else
    uri = matlab.net.URI(['https://query2.finance.yahoo.com/v7/finance/options/', upper(symbol) ],...
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
        data = yahooOptionsFromJson(jdata);%formTable(response.Body.Data);
       %disp('Received data');
    end
end
