%% libraries

asmp1 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\Release\CSharpAPI.dll'));
asmp2 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\Release\IBBackEnd.dll'));
asmp3 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\Release\IBControlDefinition.dll'));

asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import IBApi.*;



%% constants
trade_all=0;
trade_win=0;


version='ib';
currentTicker = 0;

%%  %date


dtt=datetime();
date='2020-08-21';%datestr(datetime()-days(1),'yyyy-mm-dd');

dbase=datetime(date);
for di=0:0
    
    datedate=dbase-days(di)
    
    if (isbusday(datedate))
        date=datestr(datedate,'yyyy-mm-dd');
        %% init
        
        signal=EReaderMonitorSignal;
        ibClient=IBClient(signal);
        ibWrapper=IBWrapper(ibClient,signal);
        
        %% set handles
        
        %all standard handles are available to signal matlab as well
        
        eventhandlerError= addlistener(ibWrapper,'HandledError',@HandledErrorFcn);      
        eventhandlerTick = addlistener(ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);

        % % connect
        port=4002;
        
        ibClient.ClientId=floor(rand()*999)+1001;
        
        contracts_ib;
          
        ncontracts=numel(contracts);
        
       cnt=0;
       tic;
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol;
            disp(symbol);
           
          
              sub_dailytrend_grabpremarketbyIB;
          cnt=cnt+1;
          pause(0.02);
         %toc/cnt
        end
        pause(10); %to complete acquisition
        ibWrapper.Disconnect();
        
       
        
    end
    
end