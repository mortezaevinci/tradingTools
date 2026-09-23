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
%looperEngine.symbols={'AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','GE','WMT','SHOP','MSFT','NVDA','NFLX','DIS','FB','SPY'};
looperEngine.ui.runOnce=1;
looperEngine.graph.saveFigures=1;
looperEngine.graph.show=2; %1 show if signals, 2 always show
looperEngine.graph.isfull=1;
looperEngine.graph.pauseAfterGraph=1;
looperEngine.graph.figureSize=[0 .1 1 .9];
looperEngine.graph.showSections=[1,1,1,1,1,1,1,1,1,1];%book/profile,profilelevels,levels,profiletrend,strategy_entries,strategy_exists, net entries,book levels,candle

looperEngine.process.useBookLevels=1;
looperEngine.net.use=1;
looperEngine.net.setupId=3;

looperEngine.skipTrainingFromStart=22;

basedate='2020-05-08';%'2020-06-01';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperEngine.date=basedate;
looperEngine.dateMinutesNextDay=minutenextday;

looperEngine.data.getdatainit=1; %1 initis all, 2 only for today
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=0;
looperEngine.graph.showlimit=0;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.ui.backStudyPoints=0;

looperEngine.TDA.apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';

useparfor=inf;


looperEngine.process.type=0; %0=inrtdaday, 1=daily

looperEngine.ui.continueAfterInit=1;

