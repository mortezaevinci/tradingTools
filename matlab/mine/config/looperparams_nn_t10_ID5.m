looperEngine.directories.book='Z:\My files\Project trading\traderdata\book_ondemand\';
looperEngine.directories.data='Z:\My files\Project trading\traderdata\data\';
looperEngine.directories.nets='Z:\My files\Project trading\traderdata\nets\';
looperEngine.directories.figures='Z:\My files\Project trading\traderdata\figures\';
looperEngine.directories.PAP='Z:\My files\Project trading\traderdata\data_processed\priceactionprofile\';
looperEngine.directories.PMAT='Z:\My files\Project trading\traderdata\data_processed\indicatorprofile\';
looperEngine.directories.DTP='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
looperEngine.directories.options='Z:\My files\Project trading\traderdata\data\options\';
looperEngine.files.bookviewrunner='C:\temp\tradingTools\csharp\bookViewRunner\bookViewRunner\bin\release\bookviewrunner.exe';

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

looperEngine.sortContracts=0;
looperEngine.runIndices=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];
if (numel(looperEngine.runIndices)>numel(looperEngine.contracts))
  looperEngine.runIndices=looperEngine.runIndices(1:numel(looperEngine.contracts));
end

looperEngine.mainDataEngine=0;

looperEngine.book.runOnDemand=0;

basedate='2020-06-08';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperEngine.date=basedate;
looperEngine.dateMinutesNextDay=minutenextday;

looperEngine.data.getdatainit=1; %1 initis all, 2 only for today
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=0;

looperEngine.graph.showlimit=60;
looperEngine.graph.showlimitstep=60;
looperEngine.graph.showlimitmax=390;
looperEngine.graph.scalepercent=1.15;
looperEngine.graph.saveFigures=0;
looperEngine.graph.pauseAfterGraph=0;
looperEngine.graph.show=0; %1 show if signals, 2 always show
looperEngine.graph.isfull=0;
looperEngine.graph.figureSize=[0 .1 0.9 0.85];
looperEngine.graph.showSections=[1,0,1,0,1,1,1,1,1,1];%book/profile,profilelevels,levels,profiletrend,strategy_entries,strategy_exists, net entries,book levels,candle,guides

looperEngine.process.useBookLevels=0;
looperEngine.process.shiftBookLevelCrossing=5;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.process.type=0; %0=inrtdaday, 1=daily

looperEngine.ui.runOnce=1;
looperEngine.ui.backStudyPoints=0;
looperEngine.ui.continueAfterInit=1;

looperEngine.train=1;

looperEngine.TDA.apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';

useparfor=inf;

looperEngine.skipTrainingFromStart=22;

looperEngine.net.hiddenLayerSize=8000;
looperEngine.net.trainRatio=0.9;
looperEngine.net.valRatio=0.05;
looperEngine.net.testRatio=0.05;

looperEngine.net.trainParam.epochs = 1000; %3000
looperEngine.net.trainParam.goal = 1e-13; %1e-15
looperEngine.net.trainParam.min_grad = 1e-13; %1e-15
looperEngine.net.trainParam.max_fail = 500; %500
looperEngine.net.trainParam.Sigma=1e-7; %
looperEngine.makeNetDataOnlyIfTheyDoNotExist=1;

looperEngine.performance.setupId=3;

looperEngine.net.setupId=5;
looperEngine.net.use=0;

looperEngine.process.type=0; %0=inrtdaday, 1=daily


looperEngine.IB.run=0;
looperEngine.IB.updateRealTimeBars=0;
looperEngine.IB.clientId=1;
looperEngine.IB.host='';
looperEngine.IB.port=[7497,4002];