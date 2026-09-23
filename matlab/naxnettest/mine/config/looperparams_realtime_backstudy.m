looperParams.symbols={'AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','GE','WMT','SHOP','MSFT','NVDA','NFLX','DIS','FB','SPY'};
looperParams.runOnce=0;
looperParams.graph.saveFigures=0;
looperParams.graph.show=2; %1 show if signals, 2 always show
looperParams.graph.isfull=0;

basedate='2020-06-01';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
minutenextday=datestr(datetime(basedate)+days(1),'yyyy-mm-dd');%   'tomorrow'; %this will be the day up to which minute data are gathered, 'tomorrow' can work for real-time, while, it has to be date for other base dates

looperParams.date=basedate;
looperParams.dateMinutesNextDay=minutenextday;
looperParams.getdatainit=1; %1 initis all, 2 only for today
looperParams.getalldatainrealtime=0;
looperParams.updaterealtime=0;
looperParams.graph.showlimit=390;
looperParams.processlimit=0;
looperParams.doBookOnly=0;
looperParams.backStudyPoints=389; %389 for a day. 0 for not doing it
useparfor=inf;