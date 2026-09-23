looperEngine.contracts={genContract([],'AAL'),...
genContract([],'AAPL'),...
genContract([],'AMD'),...
genContract([],'AMZN'),...
genContract([],'BAC'),...
genContract([],'BA'),...
genContract([],'TSLA'),...
genContract([],'BYND'),...
genContract([],'WMT'),...
genContract([],'SHOP'),...
genContract([],'MSFT','MSFT','STK','SMART','NASDAQ'),...
genContract([],'NVDA'),...
genContract([],'NFLX'),...
genContract([],'DIS'),...
genContract([],'FB'),...
genContract([],'SPY')
};
%looperEngine.symbols={'AAL','AAPL','AMD','AMZN','BAC','BA','BYND','DIS','FB','MSFT','NVDA','NFLX','WMT','SHOP','TSLA','SPY'};
looperEngine.ui.runOnce=0;
looperEngine.graph.saveFigures=0;
looperEngine.graph.show=2; %1 show if signals, 2 always show
looperEngine.graph.isfull=0;
looperEngine.graph.pauseAfterGraph=0;
looperEngine.graph.figureSize=[0 .1 1 0.9];
looperEngine.graph.showSections=[1,1,1,1,1,1,1,1,1,1];%book/profile,profilelevels,levels,profiletrend,strategy_entries,strategy_exists, net entries,book levels,candle

looperEngine.process.useBookLevels=1;

looperEngine.net.use=1;
looperEngine.net.setupId=3;

basedate='today';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperEngine.date=basedate;
looperEngine.dateMinutesNextDay=minutenextday;

looperEngine.data.getdatainit=0;
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=1;
looperEngine.graph.showlimit=60;
looperEngine.graph.showlimitstep=60;
looperEngine.graph.showlimitmax=390;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.ui.backStudyPoints=0;
useparfor=inf;

looperEngine.ui.continueAfterInit=0;

looperEngine.skipTrainingFromStart=1;% no need to skip for returns

looperEngine.process.type=0; %0=inrtdaday, 1=daily


looperEngine.graph.scalepercent=1.1;