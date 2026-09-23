
     contracts_TDA;
     looperEngine.contracts=contracts;

     clear contracts
     
looperEngine.ui.runOnce=1;
looperEngine.graph.saveFigures=0;
looperEngine.graph.show=0; %1 show if signals, 2 always show
looperEngine.graph.isfull=0;

looperEngine.process.useBookLevels=0;

basedate='2020-06-08';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperEngine.date=basedate;
looperEngine.dateMinutesNextDay=minutenextday;

looperEngine.data.getdatainit=0; %1 initis all, 2 only for today
looperEngine.data.getalldatainrealtime=0;
looperEngine.data.updaterealtime=0;
looperEngine.graph.showlimit=0;
looperEngine.process.limit=0;
looperEngine.process.bookOnly=0;
looperEngine.ui.backStudyPoints=0;

looperEngine.train=1;

looperEngine.TDA.apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';

useparfor=inf;



looperEngine.skipTrainingFromStart=22;

looperEngine.net.hiddenLayerSize=16000;
looperEngine.net.trainRatio=0.7;
looperEngine.net.valRatio=0.15;
looperEngine.net.testRatio=0.15;

looperEngine.net.trainParam.epochs = 2000;
looperEngine.net.trainParam.goal = 1e-12;
looperEngine.net.trainParam.min_grad = 1e-12;
looperEngine.net.trainParam.max_fail = 500;
looperEngine.net.trainParam.Sigma=1e-9;

looperEngine.performance.setupId=3;

looperEngine.net.setupId=3;
looperEngine.net.use=0;

looperEngine.process.type=0; %0=inrtdaday, 1=daily


looperEngine.graph.scalepercent=1.1;