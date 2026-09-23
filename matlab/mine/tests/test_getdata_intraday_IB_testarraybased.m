
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

looperEngine.IB.Engine.currentTicker = 1;

%% init

looperEngine.IB.signal=EReaderMonitorSignal;
looperEngine.IB.ibClient=IBClient(looperEngine.IB.signal);
looperEngine.IB.Engine.ibWrapper=IBWrapper(looperEngine.IB.ibClient,looperEngine.IB.signal);

%% set handles

%all standard handles are available to signal matlab as well

looperEngine.IB.events.eventhandlerError= addlistener(looperEngine.IB.Engine.ibWrapper,'HandledError',@HandledErrorFcn);

looperEngine.IB.events.eventhandlerTick = addlistener(looperEngine.IB.Engine.ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);
looperEngine.IB.events.eventhandlerOrderStatus = addlistener(looperEngine.IB.Engine.ibWrapper,'HandledOrderStatus',@HandledOrderStatusFcn);
looperEngine.IB.events.eventhandlerPositions= addlistener(looperEngine.IB.Engine.ibWrapper,'HandledPosition',@HandledPositionFcn);

looperEngine.IB.events.eventhandlerHistoricalDataUpdate= addlistener(looperEngine.IB.Engine.ibWrapper,'HandledHistoricalDataUpdate',@HandledHistoricalDataUpdateFcn);
%no need to listen here, only slows thins down
%looperEngine.IB.events.eventhandlerHistoricalEndData=addlistener(looperEngine.IB.Engine.ibWrapper,'HandledHistoricalData',@HandledHistoricalDataFcn);
looperEngine.IB.events.eventhandlerHistoricalEndData= addlistener(looperEngine.IB.Engine.ibWrapper,'HandledHistoricalDataEnd',@HandledHistoricalDataEnd_getarray_Fcn);


 
 %% connect
 
  if (looperEngine.IB.ibClient.ClientSocket.IsConnected()  ==0)
looperEngine.IB.ibClient.ClientId=1;
looperEngine.IB.Engine.ibWrapper.Connect('', 4002, looperEngine.IB.ibClient.ClientId);
  end
looperEngine.IB.isconnected=looperEngine.IB.ibClient.ClientSocket.IsConnected()      

if (looperEngine.IB.isconnected)

%looperEngine.IB.ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
%pause(1);

  %% setup

 symbols={'AAPL'};
 
 
   duration = "1 D"; % //S,D,W,M,Y
             barsize = "1 min";
         
                 keepuptodate = false;
                 whattoshow="TRADES";
                 
     RTHonly=1; % during market time
  
year_=2020;
months_=6
days_=26
date0=[num2str(year_) '-' num2str(months_,'%02.f') '-' num2str(days_,'%02.f')]
dateib=[num2str(year_) num2str(months_,'%02.f') num2str(days_,'%02.f')];
enddatetime = [dateib ' 22:00:00']; %//empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false

    
si=1
symbol=symbols{si}
contract=  genContract([],symbol);     

filename=['Z:\My files\Project trading\traderdata\data\IB\'  filefriendlysymbol(symbol)  '\' filefriendlysymbol(symbol) ' minute ' date0 '.mat'];
    
%% get historical data

%and put it in some timetable

% looperEngine.IB.ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
%pause(1);
    
disp('requesting data...');
looperEngine.IB.Engine.ibWrapper.CleanUpHistoricalData(); 
looperEngine.IB.Engine.ibWrapper.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time
  
   timetablename{1}='tmfull';
            reqid = looperEngine.IB.Engine.ibWrapper.HISTORICAL_ID_BASE + looperEngine.IB.Engine.currentTicker;
            looperEngine.IB.Engine.currentTicker=looperEngine.IB.Engine.currentTicker+1;
 looperEngine.IB.Engine.ibWrapper.reqHistoricalData(reqid, contract, enddatetime, duration, barsize,whattoshow , 0, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
    
waitUnlessError(looperEngine.IB.Engine.ibWrapper);
disp('grabbed all');
 
tmfull.Date=tmfull.Date-hours(4);

 [tm,~]=getMarketTimeData(tmfull);
 
%      if (size(tm,1)<390 && size(tm,1)>385)
%          [tm2,success]=fixMinuteDataMissingPoint(tm);
%         if (success)
%             tm=tm2;
%         end
%         disp(['size was less than 390 syhthetic data injection success=' num2str(success)]);
%         
%      end

 save(filename,'tm','tmfull');


%% disconnect  
                  
looperEngine.IB.Engine.ibWrapper.Disconnect();

end
  