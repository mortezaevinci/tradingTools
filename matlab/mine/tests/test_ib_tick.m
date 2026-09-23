
asmp1 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\Release\CSharpAPI.dll'));
asmp2 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\Release\IBBackEnd.dll'));
asmp3 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\Release\IBControlDefinition.dll'));

asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import IBApi.*;

%% constants


        currentTicker = 0;


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

events.eventhandlerHistoricalDataUpdate= addlistener(ibWrapper,'HandledHistoricalDataUpdate',@HandledHistoricalDataUpdateFcn);
events.eventhandlerHistoricalData= addlistener(ibWrapper,'HandledHistoricalData',@HandledHistoricalDataFcn);
events.eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@HandledHistoricalDataEndFcn);


%% simplified order/contract manamagement for auto trading

IBCD=MHA.IBControlDefinition;

xmlfilename='z:\My files\Project Trading\matlab\mine\IB\t20.xml';
IBCD.loadXML(xmlfilename);
IBCD.orderWatchlists.Item(0)


 %% connect
 
 
ibClient.ClientId=3;

ibWrapper.Connect('', 4002, 2);
                  
ibClient.ClientSocket.IsConnected()

%  ibClient.ClientSocket.reqMarketDataType(1); %1 for realtime 2 frozen, 2 delayd frozen, 3 delayed
% pause(.5);



     
%% request market data

 contract=  genContract([],'AAPL');%  MHA.IBControlDefinition.Tools.Contracts.getGenericContract("AAPL");
 ibcontract=getGenericContract(contract);
currentTicker=currentTicker+1;
nextReqId = ibWrapper.TICK_ID_BASE + (currentTicker);
% wrapped this to avoid list<tagvalue>
ibWrapper.reqMktData(nextReqId, ibcontract, '', false, false, NET.createArray('IBApi.TagValue',0));
  
pause(1); %get some sample data

%ibWrapper.ExtendedTickPriceMessages

%% cancel market data

ibClient.ClientSocket.cancelMktData(ibWrapper.TICK_ID_BASE+currentTicker);
   currentTicker=currentTicker-1;
   %this will clean ALL the queue
 ibWrapper.CleanUpTickPrices();
 
 %% request market data

 contract=  genContract([],'AMD');%  MHA.IBControlDefinition.Tools.Contracts.getGenericContract("AAPL");
 ibcontract=getGenericContract(contract);
currentTicker=currentTicker+1;
nextReqId = ibWrapper.TICK_ID_BASE + (currentTicker);
% wrapped this to avoid list<tagvalue>
ibWrapper.reqMktData(nextReqId, ibcontract, '', false, false, NET.createArray('IBApi.TagValue',0));
  
pause(1); %get some sample data

%ibWrapper.ExtendedTickPriceMessages

%% cancel market data

ibClient.ClientSocket.cancelMktData(ibWrapper.TICK_ID_BASE+currentTicker);
   currentTicker=currentTicker-1;
   %this will clean ALL the queue
 ibWrapper.CleanUpTickPrices();

  
%% disconnect  
                  
ibWrapper.Disconnect();
  
ibClient.ClientSocket.IsConnected()
  
    
     