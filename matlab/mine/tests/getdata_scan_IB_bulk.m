basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=51;

contracts_ib;

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
% contracts={genContract(ibcontractmanager,'AAPL')};

%% libraries

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

%events.eventhandlerHistoricalDataUpdate= addlistener(ibWrapper,'HandledHistoricalDataUpdate',@HandledHistoricalDataUpdateFcn);
%events.eventhandlerHistoricalData= addlistener(ibWrapper,'HandledHistoricalData',@HandledHistoricalDataFcn);
%events.eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@HandledHistoricalDataEnd_getarray_Fcn);


%% connect
port=[4002 4001 7497 7496];
ibClient.ClientId=floor(rand()*10)+baseclientid;

isconnected=ibConnect(ibWrapper,port);

if (isconnected)
    
    %ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
    %pause(1);
    
    %% setup
    
    duration = "60 S"; % //S,D,W,M,Y
    barsize = "1 min";
    
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=0; % during market time
    
    for ds=0
        date_=datetime()-days(ds);
        if (isbusday(date_))
            date0=datestr(date_,'yyyy-mm-dd');
            dateib=datestr(date_,'yyyymmdd hh:MM:ss');
            enddatetime = [dateib];
            disp(enddatetime);
            
            disp('ib clean up...');
            %pause(.1);
            ibWrapper.CleanUpHistoricalData();
            ibWrapper.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time
            %pause(.1);
            
            cnt=0;
            tic;
            for si=1:numel(contracts)
                try
                    contract=  contracts{si};
                    
                    ibcontract=getGenericContract(contract);
                    
                    if (true)
                        disp(contract.Symbol);
                        
                        %% get historical data
                        
                        %and put it in some timetable
                        tm=[];
                        interruptisdone=0;
                        hasmajorerror=0;
                        if (ibClient.ClientSocket.IsConnected()==0)
                            ibClient.ClientId=floor(rand()*10)+baseclientid;
                            isconnected=ibConnect(ibWrapper,port);
                            currentTicker=1;
                        end
                        if (ibClient.ClientSocket.IsConnected()==1)
                            
                            disp('requesting data...');
                            timetablename{1}='tm';
                            reqid = ibWrapper.HISTORICAL_ID_BASE + currentTicker;
                            
                            ibWrapper.reqHistoricalData(reqid, ibcontract, enddatetime, duration, barsize,whattoshow , 1, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
                            currentTicker=currentTicker+1;
                            
                        end
                        cnt=cnt+1;
                        disp([num2str(cnt) '->' num2str(ibWrapper.HistoricalDataMessages.Count)]);
                        pause (0.02);
                    end
                catch exception
                    dumpReport('error.log', exception)
                end
            end
        end
    end
    
    %% disconnect
    
    ibWrapper.Disconnect();
else
    disp('did not connect');
end

ibClient.ClientSocket.IsConnected()


