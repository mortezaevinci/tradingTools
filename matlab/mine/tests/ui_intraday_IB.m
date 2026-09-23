
asmp1 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\release\CSharpAPI.dll'));
asmp2 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\release\IBBackEnd.dll'));
asmp3 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\release\IBControlDefinition.dll'));

asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import IBApi.*;

%% constants

 version='ib';
        currentTicker = 1;

%% init

signal=EReaderMonitorSignal;
ibClient=IBClient(signal);
ibWrapper=IBWrapper(ibClient,signal);

%% set handles

%all standard handles are available to signal matlab as well

events.eventhandlerError= addlistener(ibWrapper,'HandledError',@HandledErrorFcn);

events.eventhandlerTick = addlistener(ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);
events.eventhandlerOrderStatus = addlistener(ibWrapper,'HandledOrderStatus',@HandledOrderStatusFcn);
events.eventhandlerPositions= addlistener(ibWrapper,'HandledPosition',@HandledPositionFcn);

events.eventhandlerHistoricalDataUpdate= addlistener(ibWrapper,'HandledHistoricalDataUpdate_test',@HandledHistoricalDataUpdateFcn);
events.eventhandlerHistoricalData= addlistener(ibWrapper,'HandledHistoricalData',@HandledHistoricalDataFcn);
events.eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@HandledHistoricalDataEnd_getarray_Fcn);

 
 %% connect
 port=[4002 4001 7497 7496];
ibClient.ClientId=floor(rand()*10)+baseclientid;

isconnected=ibConnect(ibWrapper,port);    

if (isconnected)

%ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
%pause(1);

  %% setup
    basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
  
contracts_ib;
ibcontractmanager.DataProvider.Historical={'ib'};
ibcontractmanager.DataProvider.RealTime={'ib'};
 contract=genContract(ibcontractmanager,'AAPL');
 
    duration = "1 D"; % //S,D,W,M,Y
     barsize = "1 min";

     keepuptodate = true;
     whattoshow="TRADES";
                 
    RTHonly=1; % during market time
  
ibcontract=getGenericContract(contract);

    disp(contract.Symbol);
   
%% get historical data

%and put it in some timetable
 tm=[];
 interruptisdone=0;
 
 if (ibClient.ClientSocket.IsConnected()==0)
isconnected=ibConnect(ibWrapper,port); 
currentTicker=1;
 end
 
if (ibClient.ClientSocket.IsConnected()==1)

disp('ib clean up...');
ibWrapper.CleanUpHistoricalData(); 
ibWrapper.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time
  disp('requesting data...');
 timetablename{1}='tm';
 reqid = ibWrapper.HISTORICAL_ID_BASE + currentTicker;
            
ibWrapper.reqHistoricalData(reqid, ibcontract, "", duration, barsize,whattoshow , 1, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
currentTicker=currentTicker+1;
disp('waiting for ibwrapper...');
skippedbyerror=waitUnlessError(ibWrapper,5);
if (skippedbyerror==0)
disp('waiting for interrupt...');
d0=datetime();
while(interruptisdone==0)
    pause(.05);
    d1=datetime();
    if (seconds(d1-d0)>5)
        break
    end
end
end

disp('grabbed all');
if (~isempty(tm))
 tt=table2timetable(tm);
 cndl5(tt);
end

end


%% disconnect  
                  
ibWrapper.Disconnect();
else
    disp('did not connect');
end

  
ibClient.ClientSocket.IsConnected()
  
    
     