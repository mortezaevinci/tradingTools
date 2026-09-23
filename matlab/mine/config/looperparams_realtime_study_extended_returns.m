%looperEngine.symbols={'ATNM','AXAS','BIOC','BORR','BOXL','BTE','CDEV','CETX','CHFS','CRC','DGLY','DS','EMAN','FCEL','GCI','GNC','CPE','ACST','ADMS','AIM','CIDM','FRSX','GNUS','TTOO','ADBE','JPM','JNJ','MA','MRK','PFE','PG','ZM','UNH','XOM','BAK','GNW','MNLO','SFIX','TXN','UBER','UXIN','IRM','UNA','TLT','TNX','VIX','AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','NOW','SHOP','WMT','LITE','BYND','SHOP','MRNA','MSFT','NVDA','NFLX','F','GE', 'DIS','FB','EEM','GOOGL','INTC','KO','BSX','PENN','C','T','HPE','NOK','SAVE','WORK','INO','CRON','HAL','VZ','V','BABA','GLD','SLV','USO','SPY','OXY','IWM','UCO','UAL','SHIP','DAL','QQQ','SQQQ','M','JNUG','NUGT','OVX','TVIX'};

contracts_yahoo;
looperEngine.contracts=contracts;

looperEngine.ui.runOnce=1;
looperEngine.graph.saveFigures=0;
looperEngine.graph.show=0; %1 show if signals, 2 always show
looperEngine.graph.isfull=0;
looperEngine.graph.pauseAfterGraph=0;
looperEngine.graph.figureSize=[0 .1 .2 .2];

basedate='2020-06-11';%the use of this is now extended, this is now the day, data are analyzed, this could be 'today' for 'today'
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



looperEngine.graph.scalepercent=1.1;