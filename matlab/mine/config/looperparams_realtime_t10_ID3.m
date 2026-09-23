looperEngine.directories.book='Z:\My files\Project trading\traderdata\book_ondemand\';
looperEngine.directories.data='Z:\My files\Project trading\traderdata\data\';
looperEngine.directories.nets='Z:\My files\Project trading\traderdata\nets\';
looperEngine.directories.figures='Z:\My files\Project trading\traderdata\figures\';
looperEngine.directories.PAP='Z:\My files\Project trading\traderdata\data_processed\priceactionprofile\';
looperEngine.directories.PMAT='Z:\My files\Project trading\traderdata\data_processed\indicatorprofile\';
looperEngine.directories.DTP='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
looperEngine.directories.options='Z:\My files\Project trading\traderdata\data\options\';
looperEngine.files.bookviewrunner='C:\temp\tradingTools\csharp\bookViewRunner\bookViewRunner\bin\release\bookviewrunner.exe';

%08-17, contracts_daily=genContractsFromSymbols('NVDA,PRNB,OSTK,TDOC,PDD,HD,JD,QGEN,TCDA,WMT,AAPL,NVAX,JPM,DVA,YNDX,TSLA,TCDA,XBIT');
%8-18, contracts_daily=genContractsFromSymbols('SE,SPOT,DOCU,BABA,PDD,YNDX,QGEN,TCDA,LCA,AMZN,PSTX,HTB,KSS,MRNA,BIG');
%8-25,contracts_daily=genContractsFromSymbols('IMVT,AAL,CRM,TNA,BA,UAL,AMGN,SBUX,BABA');
%8-28,contracts_daily=genContractsFromSymbols('SURF,HIBB,GRWG,PTON,WMT,ZM,DELL,ULTA');

%8-31,contracts_daily=genContractsFromSymbols('ULTA,ZM,BYND,UAL,BABA,YNDX,SQ,ROKU');
%9-2,contracts_daily=genContractsFromSymbols('sq,wmt,kodk,pton,roku,amzn,mcd,mrna,bntx,bb,pstv,amrn,amtx');
%contracts_daily=genContractsFromSymbols('DKNG,JD,SQ,PYPL,RKT,GES,AMD,GSX,HOME,NVAX,BILL,NOW,M,FMCI,SPAQ,NNVC,PTON,NVDA');
%20-09-11, contracts_daily=genContractsFromSymbols('ADBE,CCL,ORCL,DPHC,FB,HOLX,ITCI,MNOV,NLOK,OSTK,PLAN,PTON,TSLA,VBLT,VRM,ZM');
%2020-09-14,contracts_daily=genContractsFromSymbols('NVDA,TSLA,SGEN,SGMS,ORCL,UPS,BNTX,QCOM,LEN,CCL,VXRT,DAL,NNOX,PTON,GILD');
%2020-09-15,contracts_daily=genContractsFromSymbols('mrns,ipob,eq,nvax,nnox,ostk,ipoc,zm,nvus');
%2020-09-18,contracts_daily=genContractsFromSymbols('DLR,TPR,AAPL,ADBE,CBRL,CMCSA,FDX,PAYC');
contracts_daily=genContractsFromSymbols('levi,lly,sq,nflx,baba,nvda,peck,spce');
 contracts_main={
 genContract([],'SPY'),...genContract([],'COST'),...genContract([],'DDOG'),...
 genContract([],'QQQ'),...
 };

% contracts_daily=genContractsFromSymbols('');
% contracts_main={
% genContract([],'SPY'),...genContract([],'COST'),...genContract([],'DDOG'),...
% genContract([],'QQQ'),...
% genContract([],'AAL'),...
% genContract([],'AAPL'),...
% genContract([],'AMD'),...
% genContract([],'AMZN'),...
% genContract([],'BA'),...
% genContract([],'TSLA'),...
% genContract([],'BYND'),...
% genContract([],'MSFT','MSFT','STK','SMART','NASDAQ'),...
% genContract([],'BABA'),...
% genContract([],'NVDA'),...
% genContract([],'NFLX'),...
% genContract([],'FB'),...
% genContract([],'DIS'),...
% genContract([],'DELL'),...
% genContract([],'C'),...
% genContract([],'NIO'),...genContract([],'SHIP'),...genContract([],'AVGO'),...
% genContract([],'T'),...
% genContract([],'SNAP'),...genContract([],'ZM'),...
% genContract([],'CCL'),...genContract([],'GNUS'),...
% genContract([],'WMT'),...
% genContract([],'UBER'),...genContract([],'NOW'),...genContract([],'F'),...
% genContract([],'BILI'),...
% genContract([],'SNAP'),...genContract([],'GILD'),...genContract([],'NET'),...genContract([],'UAL'),...
% genContract([],'ROKU'),...
% genContract([],'BAC'),...
% genContract([],'INO'),...
% genContract([],'DAL'),...
% };


looperEngine.contracts={contracts_daily{:},contracts_main{:}};
looperEngine.contracts=uniqueContracts(looperEngine.contracts,'FileSymbol');
looperEngine.sortContracts=0;

looperEngine.runIndices=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];
if (numel(looperEngine.runIndices)>numel(looperEngine.contracts))
  looperEngine.runIndices=looperEngine.runIndices(1:numel(looperEngine.contracts));
end

looperEngine.mainDataEngine=0;

looperEngine.book.runOnDemand=1;
looperEngine.net.use=0;
looperEngine.net.setupId=3;
looperEngine.skipTrainingFromStart=1;% no need to skip for returns

basedate='today';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates
looperEngine.date=basedate;
looperEngine.dateMinutesNextDay=minutenextday;

looperEngine.data.getdatainit=1;
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=1;

looperEngine.graph.showlimit=60;
looperEngine.graph.showlimitstep=60;
looperEngine.graph.showlimitmax=390;
looperEngine.graph.scalepercent=1.15;
looperEngine.graph.saveFigures=0;
looperEngine.graph.pauseAfterGraph=0;
looperEngine.graph.show=2; %1 show if signals, 2 always show
looperEngine.graph.isfull=0;
looperEngine.graph.figureSize=[0 .1 0.9 0.85];
looperEngine.graph.showSections=[1,0,1,0,1,1,1,1,1,1];%book/profile,profilelevels,levels,profiletrend,strategy_entries,strategy_exists, net entries,book levels,candle,guides

looperEngine.process.useBookLevels=1;
looperEngine.process.shiftBookLevelCrossing=5;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.process.type=0; %0=inrtdaday, 1=daily

useparfor=inf;

looperEngine.ui.runOnce=0;
looperEngine.ui.backStudyPoints=0;
looperEngine.ui.continueAfterInit=0;

looperEngine.performance.setupId=3;

looperEngine.IB.run=0;
looperEngine.IB.updateRealTimeBars=0;
looperEngine.IB.clientId=1;
looperEngine.IB.host='';
looperEngine.IB.port=[7497,4002];

