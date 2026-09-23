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
looperEngine.graph.isfull=1;
looperEngine.graph.pauseAfterGraph=1;
looperEngine.graph.figureSize=[0 .1 1 0.9];
looperEngine.graph.showSections=[1,1,1,1,1,1,1,1,1,1];%book/profile,profilelevels,levels,profiletrend,strategy_entries,strategy_exists, net entries,book levels,candle

looperEngine.process.useBookLevels=1;
looperEngine.net.use=1;
looperEngine.net.setupId=3;

looperEngine.skipTrainingFromStart=1;% no need to skip for returns

basedate='2020-07-01';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperEngine.date=basedate;
looperEngine.dateMinutesNextDay=minutenextday;

looperEngine.data.getdatainit=1;
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=0;
looperEngine.graph.showlimit=0;
looperEngine.graph.showlimitstep=60;
looperEngine.graph.showlimitmax=390;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.ui.backStudyPoints=300;
useparfor=inf;

looperEngine.ui.continueAfterInit=1;

looperEngine.performance.setupId=3;

looperEngine.process.type=0; %0=inrtdaday, 1=daily

looperEngine.graph.scalepercent=1.1;


looperEngine.IB.run=0;
looperEngine.IB.updateRealTimeBars=0;
looperEngine.IB.clientId=1;
looperEngine.IB.host='';
looperEngine.IB.port=7497;