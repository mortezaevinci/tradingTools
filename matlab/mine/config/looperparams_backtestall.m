looperEngine.directories.book='Z:\My files\Project trading\traderdata\book\';
looperEngine.directories.data='Z:\My files\Project trading\traderdata\data\';
looperEngine.directories.nets='Z:\My files\Project trading\traderdata\nets\';
looperEngine.directories.figures='Z:\My files\Project trading\traderdata\figures\';
looperEngine.directories.PAP='Z:\My files\Project trading\traderdata\data_processed\priceactionprofile\';
looperEngine.directories.PMAT='Z:\My files\Project trading\traderdata\data_processed\indicatorprofile\';
looperEngine.directories.DTP='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
looperEngine.directories.options='Z:\My files\Project trading\traderdata\data\options\';

contracts_daily=genContractsFromSymbols('');

contracts_main={
genContract([],'AAL'),...
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
looperEngine.contracts={contracts_daily{:},contracts_main{:}};
looperEngine.contracts=uniqueContracts(looperEngine.contracts,'FileSymbol');
looperEngine.sortContracts=0;

looperEngine.runIndices=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];


looperEngine.graph.showSections=[1,1,1,1,1,1,1,1,1,1];%book/profile,profilelevels,levels,profiletrend,strategy_entries,strategy_exists, net entries,book levels,candle


looperEngine.process.useBookLevels=1;

looperEngine.net.use=1;
looperEngine.net.setupId=1;
looperEngine.skipTrainingFromStart=22;
.
looperEngine.ui.runOnce=1;
looperEngine.graph.saveFigures=1;
looperEngine.graph.show=2; %1 show if signals, 2 alwways show
looperEngine.graph.isfull=1;
looperEngine.graph.pauseAfterGraph=1;
looperEngine.date=basedate;
looperEngine.data.getdatainit=1; %2 is only for otday
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=0;
looperEngine.graph.showlimit=390;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.ui.backStudyPoints=0;


looperEngine.graph.showlimitstep=60;
looperEngine.graph.showlimitmax=390;

useparfor=0; %0 do not use, Inf use

looperEngine.ui.continueAfterInit=1;


looperEngine.graph.scalepercent=1.1;