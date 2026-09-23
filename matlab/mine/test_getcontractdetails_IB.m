
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

base='Z:\My files\Project trading\traderdata\data_other\IB\';
cdmapfn=[base 'contractdetails.mat'];

%% init

signal=EReaderMonitorSignal;
ibClient=IBClient(signal);
ibWrapper=IBWrapper(ibClient,signal);

ibDataHandler=IbDataHandler;

contractDetailsMap=containers.Map('KeyType','char','ValueType','struct');

%% set handles

%all standard handles are available to signal matlab as well
hsrc=struct();
events.eventhandlerError= addlistener([ibWrapper hsrc],'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerContractDetails= addlistener(ibWrapper,'HandledContractDetails',@ibDataHandler.HandledContractDetailsFcn);

isconnected=ibClient.ClientSocket.IsConnected();
if ( isconnected ==0)
    ports=[4002 4004 4001 7497 7496];
    ibClient.ClientId=floor(rand()*10)+1500;
    isconnected=ibConnect(ibWrapper,ports);
end

if (isconnected)
    reqid = ibWrapper.CONTRACT_DETAILS_ID;
    contracts_ib;
    getdata_ib_contractdetails_process;
    
    %save map
    save(cdmapfn,'contractDetailsMap');
    
    ibWrapper.Disconnect();
    
end
