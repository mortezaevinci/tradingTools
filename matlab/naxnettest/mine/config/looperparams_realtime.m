looperParams.symbols={'AAL','AAPL','AMD','AMZN','BAC','BA','BYND','DIS','FB','MSFT','NVDA','NFLX','WMT','SHOP','TSLA','SPY'};
looperParams.runOnce=0;
looperParams.graph.saveFigures=0;
looperParams.graph.show=2; %1 show if signals, 2 always show
looperParams.graph.isfull=0;

basedate='today';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperParams.date=basedate;
looperParams.dateMinutesNextDay=minutenextday;

looperParams.getdatainit=1;
looperParams.getalldatainrealtime=0;
looperParams.updaterealtime=1;
looperParams.graph.showlimit=60;
looperParams.processlimit=0;
looperParams.doBookOnly=0;
looperParams.backStudyPoints=0;
useparfor=inf;