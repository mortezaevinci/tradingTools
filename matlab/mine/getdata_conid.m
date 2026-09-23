% pre-orders approach
% we have contract triggers
% We have an IBCD template (load it and fill it basically)
% for each contractTrigger
% Read template
% Set quantities of ALL orders to int(accountRisk/entrylevel)
base='Z:\My files\Project trading\traderdata\data_other\IB\';
IBCDTemplate='Z:\My files\Project Trading\traderdata\algotrading\autoswing\trader\auto swing order lmt template2.xml';
conidmapfn=[base 'conids.mat'];

if (exist(conidmapfn))
    load(conidmapfn);
else
    conIdMap = containers.Map('KeyType','char','ValueType','uint32');
end
ibDataHandler=IbDataHandler;

ib_libraries;
ib_ibWrapperSetup;
events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerError= addlistener(ibWrapper,'ResolvedContractsReady',@ibDataHandler.ResolvedContractsReadyFcn);

ports=[4002 4004];
ibClient.ClientId=floor(rand()*10)+1510;
isconnected=ibConnect(ibWrapper,ports);
IBCD=MHA.IBControlDefinition;
IBCD.loadXML(IBCDTemplate);

if (isconnected)
     contracts_penniesm2_trade;
     getdata_conid_process;
%      contracts_ib;
%      getdata_conid_process;
%      contracts_nasdaq;
%      getdata_conid_process;
%      contracts_yahoo;
%      getdata_conid_process;
else
    disp('ib did not connect');
end
disp('disconnecting...');
ibWrapper.Disconnect();
