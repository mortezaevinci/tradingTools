
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
% 
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


%% simplified order/contract manamagement for auto trading

IBCD=MHA.IBControlDefinition;

xmlfilename='z:\My files\Project Trading\matlab\mine\IB\t20.xml';
IBCD.loadXML(xmlfilename);
IBCD.orderWatchlists.Item(0)


 %% connect
 
 
ibClient.ClientId=3;
ibClient.ClientSocket.IsConnected()
ibWrapper.Connect('', 4002, 1);
                  
ibClient.ClientSocket.IsConnected()

 ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
pause(.5);



%% get account summary with message queue

 ibWrapper.CleanUpSummary();
 ibClient.ClientSocket.reqAccountSummary(ibWrapper.ACCOUNT_SUMMARY_ID, "All", ibWrapper.ACCOUNT_SUMMARY_TAGS);
 
  
 while(ibWrapper.RequestEnded == false)
     pause(0.2);
 end
 
 sm=ibWrapper.SummaryMessages;
 sme= ibWrapper.SummaryEndMessages;
  for  i=0:sm.Count-1
         disp([sm.Item(i).Account.char  ' of ' sm.Item(i).Tag.char    '='      sm.Item(i).Value.char]);
  end

    
 %% place a sample order
 
            contract = IBCD.orderWatchlists.Item(0).contractDefinitions.Item(0).contract;
            order = IBCD.orderWatchlists.Item(0).orderDefinitions.Item(0).order;
            order.OrderId = 0; %//set to new order, my xml is by default 0

            ibWrapper.CleanUpOrders();
            if (order.OrderId ~= 0)
            
                %//replace order
                ibClient.ClientSocket.placeOrder(order.OrderId, contract, order);
            
            else
            
                %//add new order
                ibClient.ClientSocket.placeOrder(ibClient.NextOrderId, contract, order);
                currentorderid=ibClient.NextOrderId
                ibClient.NextOrderId=ibClient.NextOrderId+1;
            end

    pause(.5);
    
%% request open orders

 ibWrapper.CleanUpOrders();
ibClient.ClientSocket.reqAllOpenOrders();

 waitUnlessError(ibWrapper);
 
 
oo=ibWrapper.OpenOrders;
 for  i=0:oo.Count-1
  
     disp(['ORDER '  oo.Item(i).Contract.ToString().char ' ordered as ', oo.Item(i).Order.Action.char, ' ', oo.Item(i).Order.OrderType.char, ' ',num2str(oo.Item(i).Order.LmtPrice), ' status ', oo.Item(i).OrderState.Status.char]);
 end
 
 
 %% cancel order
 
  ibClient.ClientSocket.cancelOrder(currentorderid);
   ibClient.NextOrderId=ibClient.NextOrderId-1;
 
%% request market data

 contract=  genContract([],'AAPL');%  MHA.IBControlDefinition.Tools.Contracts.getGenericContract("AAPL");
currentTicker=currentTicker+1;
nextReqId = ibWrapper.TICK_ID_BASE + (currentTicker);
% wrapped this to avoid list<tagvalue>
ibWrapper.reqMktData(nextReqId, contract, '', false, false, NET.createArray('IBApi.TagValue',0));
  

%% get historical data

   contract=  genContract([],'AAPL');
            reqid = ibWrapper.HISTORICAL_ID_BASE + currentTicker;
            currentTicker=currentTicker+1;

            enddatetime = ""; %//empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false
             duration = "1 D"; % //S,D,W,M,Y
             barsize = "1 min";
         
                 keepuptodate = true;
                 whattoshow="TRADES";
                 
            ibWrapper.reqHistoricalData(reqid, contract, enddatetime, duration, barsize,whattoshow , 0, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
    



%do stuff
pause(5);


%% cancel market data

ibClient.ClientSocket.cancelMktData(TICK_ID_BASE+currentTicker);
currentTicker=currentTicker-1;
   
   %this will clean ALL the queue
 ibWrapper.CleanUpTickPrices();

 
 
 
%% disconnect  
                  
ibWrapper.Disconnect();
  
ibClient.ClientSocket.IsConnected()
  
    
     