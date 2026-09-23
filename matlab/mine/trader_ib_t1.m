% two processes should run together
% ReqId would be in sets of BASE+10000*i+contractindex
% substract from base, then remainder of 10000, would give symbol name
% for most of this, symbol name does not matter, and all work can be done
% by index

% preparation:
% from previous daily data, the following needs to be calculated:
% At best: new PAP (Price Action Profile) that also includes afterhours
% volume separated
% At minimum: SMA of separated afterhours volume, and SMA of price
% Afterhours volume can be obtained from usbstracting volume of dailyx1y
% and daily 1y
% hence, we will have an array of contract index, SMA of close, SMA of
% after hour volume...

% intialize a market data array (MDA) of rows=no contracts, cols=max default
% ticker indexes of IB (A scan code to get last data was done before. refer
% to that)

% threaded process1 (DAQ):
% handles for grabbing data must be listened to.
% the main process, sends maximum 100 snapshot requests for market data
% that means some 11ms delay between each request.
% It basically keeps going. Once one round of contracts are finished.
% It adds 10000 to base of reqid, and keeps going.

% handles:
% The handles keep updating a large array
% reqid gets converted to contract index, and ticker index is also knwon
% row=contract, col=ticker, value=ticker value (size or price)

% NOTE: One issue with the handle is that a large array should be evaled
% into the function, and assigned back to base. Need a way to update
% instead.
% ONE IDEA: Instead evalin base, a replacement, that is ['MDA(' row
% ',' col ')=' value ';'];
% BETTER IDEAS: USE CLASS HANDLE <<<<

% threade process 2 (Evaluation):
% This one basically goes through all indexes of MDA, and once proper values
% exist (minimum last and volume are above zero), it compares them to SMA
% of each. If larger than a multiplier (Maybe 2 for price, and 2 for
% volume), then SIGNAL

% Signalling GUI:
% Most basic is that now it grabs the symbol name, and displays it and logs
% it.

% that should be the scan to evaluate.

ib_libraries;
ib_ibWrapperSetup;

%contracts_penniesm2_trade;%grab from contract triggers instead
% they need to match exactly
%ctdate='2020-12-24';
%ctfn=['Z:\My files\Project Trading\traderdata\data_other\IB\contractTriggers ' ctdate '.mat'];
%load(ctfn);
contracts_penniesm2_trade;
ncontracts=numel(contracts);
nmarketdata=15; %max tick type indexes
nprocesseddata=1; %for now only doing max high

threadManagers.requestSnapshots=ThreadManager();
threadManagers.connectIb=ThreadManager();
threadManagers.GUI=ThreadManager();
threadManagers.manageOrders=ThreadManager();

ibDataHandler=IbDataHandler();
ibDataHandler.SetMarketData(ncontracts,nmarketdata);
ibDataHandler.SetProcessFunctions(ncontracts,{@ProcessFcnMaxHigh}); %this is perhaps not needed because high of the day tick already exists
ibDataHandler.cycleRemainder=10000;

ibSetup.ConnectIb=IbSetupConnectIb;
ibSetup.ConnectIb.name='ConnectIb';
ibSetup.ConnectIb.ibWrapper=ibWrapper;
ibSetup.ConnectIb.ports=[4002];

ibSetup.RequestSnapshot.name='RequestSnapshot';
ibSetup.RequestSnapshot.contracts=contracts;
%ibsetup.RequestSnapshot.contractTriggers=contractTriggers;
ibSetup.RequestSnapshot.cycleRemainder=ibDataHandler.cycleRemainder;
ibSetup.RequestSnapshot.ibWrapper=ibWrapper;
ibSetup.RequestSnapshot.genericTickTypes='';

ibSetup.GUI.name='GUI';
ibSetup.GUI.ibDataHandler=ibDataHandler;
% spmd
% ThreadConnectIb(threadManagers.connectIb,ibSetup.ConnectIb);
% end

j=batch(@ThreadConnectIb, 0,{threadManagers.connectIb,ibSetup.ConnectIb}, 'pool', 1);

C_threadManagers_connectIb = parallel.pool.Constant(threadManagers.connectIb);
C_ibSetup_ConnectIb = parallel.pool.Constant(ibSetup.ConnectIb);
F2 = parfevalOnAll(@loadIbLibraries,0);

parfcallConnectIb=parfeval(@ThreadConnectIb, 0,C_threadManagers_connectIb,C_ibSetup_ConnectIb);

% afterEach(parfcallConnectIb, @(parfcallConnectIb) disp(parfcallConnectIb.Diary), 0, 'PassFuture', true);

%wait for first connection
while(~ibWrapper.ibClient.ClientSocket.IsConnected())
    disp('Waiting for connection...');
    pause(1);
end
% run rest of system
parfeval(@ThreadRequestSnapshots, 0,threadManagers.requestSnapshots,ibSetup.RequestSnapshot);


% this one runs at frontend
ThreadGUI(threadManagers,ibSetup.GUI);