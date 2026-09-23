looperEngine.directories.book='c:\temp\traderdata\book_ondemand\';
looperEngine.directories.data='c:\temp\traderdata\data\';
looperEngine.directories.nets='Z:\My files\Project trading\traderdata\nets\';
looperEngine.directories.figures='Z:\My files\Project trading\traderdata\figures\';
looperEngine.directories.PAP='Z:\My files\Project trading\traderdata\data_processed\priceactionprofile\';
looperEngine.directories.PMAT='Z:\My files\Project trading\traderdata\data_processed\indicatorprofile\';
looperEngine.directories.DTP='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
looperEngine.directories.options='Z:\My files\Project trading\traderdata\data\options\';

looperEngine.files.bookviewrunner='z:\My files\Project trading\repo\csharp\bookViewRunner\bookViewRunner\bin\release\bookviewrunner.exe';

sym0=input("symbol:",'s');
contracts_daily=genContractsFromSymbols(sym0);
contracts_main={};

looperEngine.mainDataEngine=1;%0 like before, 1 yahoo, 2 tda, 3 ib (not implemented)
looperEngine.contracts={contracts_daily{:},contracts_main{:}};
looperEngine.contracts=uniqueContracts(looperEngine.contracts,'FileSymbol');
looperEngine.sortContracts=0;

looperEngine.runIndices=1:numel(looperEngine.contracts);

looperEngine.ui.runOnce=1;
looperEngine.graph.saveFigures=0;
looperEngine.graph.show=2; %1 show if signals, 2 always show, 
looperEngine.graph.isfull=2; % 0 thumbnails, 1 is full, 2 reuse full
looperEngine.graph.pauseAfterGraph=0;
looperEngine.graph.figureSize=[0 .1 .8 0.85];
looperEngine.graph.showSections=[1,0,1,0,1,1,1,1,1,1];%book/profile,profilelevels,levels,profiletrend,strategy_entries,strategy_exists, net entries,book levels,candle,guides

looperEngine.book.runOnDemand=1;
looperEngine.process.useBookLevels=1;
    looperEngine.process.shiftBookLevelCrossing=5;
    
    
looperEngine.net.use=0;
looperEngine.net.setupId=3;

looperEngine.skipTrainingFromStart=1;% no need to skip for returns

basedate='today';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperEngine.date=basedate;
looperEngine.dateMinutesNextDay=minutenextday;

looperEngine.data.getdatainit=3; %2 does realtime, 3 does redo
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=0;
looperEngine.graph.showlimit=0;
looperEngine.graph.showlimitstep=0;
looperEngine.graph.showlimitmax=390;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.ui.backStudyPoints=0;
useparfor=inf;

looperEngine.ui.continueAfterInit=1;

looperEngine.performance.setupId=3;

looperEngine.process.type=0; %0=inrtdaday, 1=daily

looperEngine.graph.scalepercent=1.5;

looperEngine.IB.run=0;
looperEngine.IB.updateRealTimeBars=0;
looperEngine.IB.clientId=1;
looperEngine.IB.host='';
looperEngine.IB.port=7497;

