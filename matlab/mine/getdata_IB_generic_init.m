rng('shuffle');

%% configs

%getdata_IB_generic_config_intraday;

ib_libraries;

%% constants
version='ib';
currentTicker = 1;

%% init

fn_skipper=[basedir 'skipperProfile_' setupname '.mat'];
if (~exist(fn_skipper))
    %initialize setup, and save it
    skipperProfile = containers.Map('KeyType','char','ValueType','int32');
    save(fn_skipper,'skipperProfile');
else
    load(fn_skipper);
end
             


FS = stoploop(setupname,{'Stop me for', setupname}) ; 

ib_ibWrapperSetup;

%IbErrorSummary=newIbErrorSummary();
ibDataHandler=IbDataHandler();

%% set handles
%all standard handles are available to signal matlab as well
events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerTick = addlistener(ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);
events.eventhandlerOrderStatus = addlistener(ibWrapper,'HandledOrderStatus',@HandledOrderStatusFcn);
events.eventhandlerPositions= addlistener(ibWrapper,'HandledPosition',@HandledPositionFcn);

events.eventhandlerHistoricalDataUpdate= addlistener(ibWrapper,'HandledHistoricalDataUpdate',@HandledHistoricalDataUpdateFcn);
events.eventhandlerHistoricalData= addlistener(ibWrapper,'HandledHistoricalData',@HandledHistoricalDataFcn);
events.eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@ibDataHandler.HandledHistoricalDataEnd_getarray_Fcn);

% this grabs base array data that is much better, but incompatible with
% IB's default ibClinet
events.eventhandlerHistoricalTicksLast= addlistener(ibWrapper,'HandledHistoricalTicksLast',@ibDataHandler.HandledHistoricalTicksLastFcn);
events.eventhandlerHistoricalTickBidAsk= addlistener(ibWrapper,'HandledHistoricalTickBidAsk',@ibDataHandler.HandledHistoricalTickBidAskFcn);

% other options, HandledHistoricalTickLast,
% other incompatible options, HandledHistoricalTicksEnd,
% HandledHistoricalTickEnd

%% connect
port=port(randperm(length(port)));
ibWrapper.ibClient.ClientId=floor(rand()*10)+baseclientid;
ibWrapper.allowedPorts=port;
isconnected=ibConnect(ibWrapper);