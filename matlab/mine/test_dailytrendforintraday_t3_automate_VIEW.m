%% libraries

asmp1 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\Release\CSharpAPI.dll'));
asmp2 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\Release\IBBackEnd.dll'));
asmp3 = NET.addAssembly(('C:\temp\tradingTools\matlab\mine\bin\Release\IBControlDefinition.dll'));

asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import IBApi.*;

%% constants

dtt=datetime();
date='2020-08-17';%datestr(datetime()-days(1),'yyyy-mm-dd');

version='ib';
  currentTicker = 0;

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
events.eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@HandledHistoricalDataEnd_getarray_Fcn);

 
 %% connect
 port=4002;

ibClient.ClientId=floor(rand()*10)+101;



annualinflationrate=0.025;

basedir='Z:\My files\Project trading\traderdata\data\';
processdir='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';

%contracts_nasdaq;
contracts_yahoo;
%contracts_main;
% 

%  1×5 cell array
%     {'ACE'}    {'GS'}    {'BKNG'}    {'TVIX'}    {'RE'}
% bullishList_over1 =
%   1×30 cell array
%   Columns 1 through 7
%     {'AMGN'}    {'VRTX'}    {'HD'}    {'BIDU'}    {'EMC'}    {'MA'}    {'V'}
%   Columns 8 through 13
%     {'ZM'}    {'TSLA'}    {'NVDA'}    {'DOCU'}    {'^IXIC'}    {'A1CYC'}
%   Columns 14 through 19
%     {'^NDX'}    {'QQQ'}    {'TQQQ'}    {'NVAX'}    {'BGNE'}    {'OSTK'}
%   Columns 20 through 25
%     {'FNV.TO'}    {'CP.TO'}    {'CMG'}    {'CLX'}    {'DPZ'}    {'EL'}
%   Columns 26 through 30   
%     {'JKHY'}    {'NVR'}    {'ORLY'}    {'RMD'}    {'SNPS'}


    ibcontractmanager.DataProvider.Historical={'ib'};
    ibcontractmanager.DataProvider.RealTime={'ib'};
     contracts={genContract(ibcontractmanager,'TVIX')};

ncontracts=numel(contracts);




trade_all=0;
trade_win=0;

for ci=1:ncontracts
symbol=contracts{ci}.FileSymbol;
disp(symbol);
trendprofiflename=[processdir 'PDTP1 ' symbol ' ID' '3' '.mat'];

if (exist(trendprofiflename))
load(trendprofiflename);
try

fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];load(fn);
params.TimeTables.Day=table2timetable(td);

if (size(params.TimeTables.Day.Date)<10)
    continue;
end

%will need next open
% get minute in the morning, and attach it to .Day

%sub_dailytrend_grabpremarketbyIB;


%% process

sub_dailytrendprocess;

allgoodconditions{1}='gapdn & strategy_superposition_main_bearish>2';
allgoodconditions{2}='gapup & strategy_superposition_main_bullish>2';


if (isempty(allgoodconditions{1}))
    bearish=0;
else
bearish=eval(allgoodconditions{1});
end

if (isempty(allgoodconditions{2}))
    bullish=0;
else
bullish=eval(allgoodconditions{2});
end
disp(['bearish days:' num2str(sum(bearish)) ' bullish days:' num2str(sum(bullish))]);
hFig=figure;
hFig.WindowState = 'maximized';
  sub_dailytrendplot;
 




catch exception
   dumpReport('error.log', exception) 
    
end
else
%disp('Does not exists');

end
end

ibWrapper.Disconnect();
