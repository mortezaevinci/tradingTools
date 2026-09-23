function ibEngine(mainticks,commonticks,looperEngine)


try
 looperEngine.IB.Engine.ibWrapper.ibClient.ClientId=floor(rand*10+1);
isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);

% request stuff here... they will need to be redone if disconnected
    if (isconnected)
     looperEngine.IB.Engine.currentTicker.realtimebars = 1;
    looperEngine.IB.Engine.currentTicker.historicaldata = 1;
        
        %% request realtime bars
%         barsize = 1; % this mighe be the number of 1 min bars to provide
%         whattoshow="TRADES";
%         useRTH=1;
%         
%         contractsdone='';
%         
%         ncontracts=numel(mainticks);
%         for ci=1:ncontracts
%            ibcontract= getGenericContract(mainticks{ci}.contract);
%            reqid=looperEngine.IB.Engine.ibWrapper.RT_BARS_ID_BASE+looperEngine.IB.Engine.currentTicker.realtimebars;
%            looperEngine.IB.Engine.ibWrapper.reqRealTimeBars(reqid, ibcontract, barsize,whattoshow ,useRTH, NET.createArray('IBApi.TagValue',0));
%            looperEngine.IB.Engine.currentTicker.realtimebars=looperEngine.IB.Engine.currentTicker.realtimebars+1;
%            contractsdone=[contractsdone '.' mainticks{ci}.contract.Symbol];
%            pause (.2);
%         end
%         ncontracts=numel(commonticks);
%         for ci=1:ncontracts
%            ibcontract= getGenericContract(commonticks{ci}.contract);
%            notalreadydone=~contains(contractsdone,commonticks{ci}.contract.Symbol);
%            if (notalreadydone)
%            reqid=looperEngine.IB.Engine.ibWrapper.RT_BARS_ID_BASE+looperEngine.IB.Engine.currentTicker.realtimebars;
%            looperEngine.IB.Engine.ibWrapper.reqRealTimeBars(reqid, ibcontract, barsize,whattoshow ,useRTH, NET.createArray('IBApi.TagValue',0));
%            contractsdone=[contractsdone '.' mainticks{ci}.contract.Symbol];
%            pause (.2);
%            else
%                
%            end
%            looperEngine.IB.Engine.currentTicker.realtimebars=looperEngine.IB.Engine.currentTicker.realtimebars+1;
%         end
        
        
        %% request historical data (for the purpose of updating last bar)
        
         duration = "600 S"; % //S,D,W,M,Y
         barsize = "1 min";
         keepuptodate = true;
         whattoshow="TRADES";
         RTHonly=0; % during market time
         enddatetime="";
        
         looperEngine.IB.Engine.ibWrapper.CleanUpHistoricalData(); 
         looperEngine.IB.Engine.ibWrapper.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time
            
        contractsdone_h='';
       
         ncontracts=numel(mainticks);
        for ci=1:ncontracts
           ibcontract= getGenericContract(mainticks{ci}.params.contract);
           notalreadydone=~contains(contractsdone_h,commonticks{ci}.params.contract.Symbol);
           if (notalreadydone)
           reqid=looperEngine.IB.Engine.ibWrapper.HISTORICAL_ID_BASE+looperEngine.IB.Engine.currentTicker.historicaldata;
           looperEngine.IB.Engine.ibWrapper.reqHistoricalData(reqid, ibcontract, enddatetime, duration, barsize,whattoshow , RTHonly, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
           looperEngine.IB.Engine.currentTicker.historicaldata=looperEngine.IB.Engine.currentTicker.historicaldata+1;
           contractsdone_h=[contractsdone_h '.' mainticks{ci}.params.contract.Symbol];
           pause (.2);
           else
               
           end
        end
        
         ncontracts=numel(commonticks);
        for ci=1:ncontracts
           ibcontract= getGenericContract(commonticks{ci}.params.contract);
           notalreadydone=~contains(contractsdone_h,commonticks{ci}.params.contract.Symbol);
           if (notalreadydone)
           reqid=looperEngine.IB.Engine.ibWrapper.HISTORICAL_ID_BASE+looperEngine.IB.Engine.currentTicker.historicaldata;
           looperEngine.IB.Engine.ibWrapper.reqHistoricalData(reqid, ibcontract, enddatetime, duration, barsize,whattoshow , RTHonly, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
           contractsdone_h=[contractsdone_h '.' mainticks{ci}.params.contract.Symbol];
           pause (.2);
           else
               
           end
           looperEngine.IB.Engine.currentTicker.historicaldata=looperEngine.IB.Engine.currentTicker.historicaldata+1;
        end
    
    end

     
catch exception
fileID = fopen('error.log','w');
fprintf(fileID,'%s',exception.message);
for i=1:numel(exception.stack)
fprintf(fileID,'%s %s  %s',exception.message,exception.stack(i).file,exception.stack(i).name,num2str(exception.stack(i).line));
end
for j=1:numel(exception.cause)
    exp=exception.cause{j};
fprintf(fileID,'%s',exp.message);
for i=1:numel(exp.stack)
fprintf(fileID,'%s %s  %s',exp.message,exp.stack(i).file,exp.stack(i).name,num2str(exp.stack(i).line));
end

end

fclose(fileID);
end

end
