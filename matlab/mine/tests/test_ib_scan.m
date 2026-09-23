
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
baseclientid=350;
version='ib';

%% init

signal=EReaderMonitorSignal;
ibClient=IBClient(signal);
ibWrapper=IBWrapper(ibClient,signal);

%% set handles

%all standard handles are available to signal matlab as well

events.eventhandlerError= addlistener(ibWrapper,'HandledError',@HandledErrorFcn);
events.eventhandlerTick = addlistener(ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);
events.eventhandlerOrderStatus = addlistener(ibWrapper,'HandledOrderStatus',@HandledOrderStatusFcn);
events.eventhandlerFundamentalData = addlistener(ibWrapper,'HandledFundamentaldData',@HandledFundamentalDataFcn);
events.eventhandlerScannerData = addlistener(ibWrapper,'HandledScannerData',@HandledScannerDataFcn);
events.eventhandlerScannerDataEnd = addlistener(ibWrapper,'HandledScannerDataEnd',@HandledScannerDataEndFcn);

% 
% priceAbove	5
% volumeAbove 100000
% AFTERHRSCHANGEPERC 2
% marketCapAbove1e6	200
% 
% 
% afterHoursChangePercAbove
% changePercAbove
% changePercBelow
% 
% scancode doesn't matter, just add something that shows all
% Maybe
% ALL_SYMBOLS_ASC
% MOST_ACTIVE
% 
% STK
% ALL
% STK.US.MAJOR

%parameters

%     t1 = IBApi.TagValue("usdMarketCapAbove", "10000");
%     t2 = IBApi.TagValue("optVolumeAbove", "0");
%     t3 = IBApi.TagValue("avgVolumeAbove", "1000000");
    tv{1} = IBApi.TagValue("marketCapAbove1e6", "200");
    tv{2} = IBApi.TagValue("volumeAbove", "100000");
    tv{3} = IBApi.TagValue("priceAbove", "5");
    tv{4} = IBApi.TagValue("changePercAbove", "0.5");
    
    tvs = NET.createGeneric('System.Collections.Generic.List',{'IBApi.TagValue'},numel(tv));
    for i=1:numel(tv)
    tvs.Add(tv{i});
    end
    
 tvsscanner=NET.createGeneric('System.Collections.Generic.List',{'IBApi.TagValue'},0);
            
 subscription = IBApi.ScannerSubscription;
 subscription.ScanCode = 'HOT_BY_PRICE';
 subscription.Instrument = 'STK';
 subscription.LocationCode = 'STK.US.MAJOR';
 subscription.StockTypeFilter = 'ALL';
 subscription.NumberOfRows = 100;    


 %% connect
 port=[4002 4001 7497 7496];
ibClient.ClientId=floor(rand()*10)+baseclientid;

isconnected=ibConnect(ibWrapper,port);     

if (isconnected)

%prepare
ibscan=[];
timetablename{1}='ibscan';
interruptisdone=0;
hasmajorerror=0;
currentTicker=1;
    disp('ib clean up...');
pause(.1);
ibWrapper.CleanUpScannerData(); 
pause(.1);
%request   
reqid=ibWrapper.SCANNER_BASE+currentTicker;
ibClient.ClientSocket.reqScannerSubscription(reqid, subscription,[] , tvs);

disp('waiting for ibwrapper...');
skippedbyerror=waitUnlessError(ibWrapper,10);
if (skippedbyerror==0)
disp('waiting for interrupt...');
d0=datetime();
while(interruptisdone==0 && ibWrapper.RequestEnded==false)
    pause(.1);
    d1=datetime();
    if (seconds(d1-d0)>10)
        break
    end
end
pause(0.5);
end

if (~isempty(ibscan))
    for i=1:numel(ibscan)
        fprintf('%s,', ibscan{i}.contract.Symbol);
    end
    disp(' ');
end

ibClient.ClientSocket.cancelScannerSubscription(reqid);

%% disconnect  
                  
ibWrapper.Disconnect();
else
    disp('did not connect');
end
     