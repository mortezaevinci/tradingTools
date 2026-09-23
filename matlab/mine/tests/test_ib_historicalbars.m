
asmp1 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\release\CSharpAPI.dll'));
asmp2 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\release\IBBackEnd.dll'));
asmp3 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\release\IBControlDefinition.dll'));

asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import IBApi.*;

%% constants


        currentTicker = 1;
%         HISTORICAL_ID_BASE = 30000000;
%         ACCOUNT_ID_BASE = 50000000;
%         TICK_ID_BASE = 10000000;
%         ACCOUNT_SUMMARY_ID = ACCOUNT_ID_BASE + 1;
%         ACCOUNT_SUMMARY_TAGS = "AccountType,NetLiquidation,TotalCashValue,SettledCash,AccruedCash,BuyingPower,EquityWithLoanValue,PreviousEquityWithLoanValue,GrossPositionValue,ReqTEquity,ReqTMargin,SMA,InitMarginReq,MaintMarginReq,AvailableFunds,ExcessLiquidity,Cushion,FullInitMarginReq,FullMaintMarginReq,FullAvailableFunds,FullExcessLiquidity,LookAheadNextChange,LookAheadInitMarginReq ,LookAheadMaintMarginReq,LookAheadAvailableFunds,LookAheadExcessLiquidity,HighestSeverity,DayTradesRemaining,Leverage";
% 





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


 

 %% connect
 
 
ibClient.ClientId=3;
ibClient.ClientSocket.IsConnected()
ibWrapper.Connect('', 4002, 1);
isconnected=ibClient.ClientSocket.IsConnected()          

if (isconnected)

 ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
pause(1);

  %% setup


  
              enddatetime = ""; %//empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false
             duration = "1 D"; % //S,D,W,M,Y
             barsize = "1 min";
         
                 keepuptodate = true;
                 whattoshow="TRADES";

%% get historical data

%and put it in some timetable
 tm=genNanTimeTable(datetime('2020-06-17 09:30:00')+minutes((0:389)'));
   

disp('requesting data...');
ibWrapper.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time
   contract=  genContract([],'AAPL');
   timetablename{currentTicker}='tm';
            reqid = ibWrapper.HISTORICAL_ID_BASE + currentTicker;
            currentTicker=currentTicker+1;
            
                
            ibWrapper.reqHistoricalData(reqid, contract, enddatetime, duration, barsize,whattoshow , 0, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
    
waitUnlessError(ibWrapper);
disp('grabbed all');

% IB misses data , so do it two times

disp('Correcting missing data...');
ibWrapper.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time

            reqid = ibWrapper.HISTORICAL_ID_BASE + currentTicker;
            currentTicker=currentTicker+1;

                 RTHonly=1; % during market time
            ibWrapper.reqHistoricalData(reqid, contract, enddatetime, duration, barsize,whattoshow , RTHonly, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
    
waitUnlessError(ibWrapper);
disp('grabbed all');

 filename='Z:\My files\Project trading\traderdata\data\IB\' filefriendlysymbol(contract.FileSymbol) '\' filefriendlysymbol(contract.FileSymbol) ' minute ' 

%% disconnect  
                  
ibWrapper.Disconnect();
else
    disp('did not connect');
end

  
ibClient.ClientSocket.IsConnected()
  
    
     