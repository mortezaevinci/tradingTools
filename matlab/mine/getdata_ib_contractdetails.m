ib_libraries;

base='Z:\My files\Project trading\traderdata\data_other\IB\';
cdmapfn=[base 'contractdetails.mat'];
if (exist(cdmapfn))
    load(cdmapfn);
else
    contractDetailsMap=struct();
end
%% init

ib_ibWrapperSetup;

ibDataHandler=IbDataHandler;


%% set handles

%all standard handles are available to signal matlab as well
hsrc=struct();
events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerContractDetails= addlistener(ibWrapper,'HandledContractDetails',@ibDataHandler.HandledContractDetailsFcn);

isconnected=ibClient.ClientSocket.IsConnected();
if ( isconnected ==0)
    ports=[4002 4004 4001 7497 7496];
    ibClient.ClientId=floor(rand()*10)+1200;
    isconnected=ibConnect(ibWrapper,ports);
end

if (isconnected)
    reqid = ibWrapper.CONTRACT_DETAILS_ID;
    contracts_ib;
    getdata_ib_contractdetails_process;
    save(cdmapfn,'contractDetailsMap');
    
    contracts_penniesm2;
    getdata_ib_contractdetails_process;
    save(cdmapfn,'contractDetailsMap');
    
    contracts_nasdaq;
    getdata_ib_contractdetails_process;
    save(cdmapfn,'contractDetailsMap');
    
    contracts_yahoo;
    getdata_ib_contractdetails_process;
    save(cdmapfn,'contractDetailsMap');
%     contracts=genContractsFromSymbols('VXX');
%     getdata_ib_contractdetails_process;
    ibWrapper.Disconnect();
    
end
