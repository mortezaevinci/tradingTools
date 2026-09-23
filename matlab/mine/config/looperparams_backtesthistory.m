%looperEngine.symbols={'TLT','^TNX','^VIX','AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','NOW','SHOP','WMT','LITE','BYND','SHOP','MRNA','MSFT','NVDA','NFLX','F','GE', 'DIS','FB','EEM','GOOGL','INTC','KO','BSX','PENN','C','T','HPE','NOK','SAVE','WORK','INO','CRON','HAL','VZ','V','BABA',    'GLD','SLV','USO','SPY','OXY','IWM','UCO',    'UAL','SHIP','DAL','QQQ','SQQQ','M',    'XIU.TO','VCN.TO','XUU.TO','ZAG.TO','ZCN.TO','ZSP.TO','VFV.TO','HXT.TO','XEG.TO','HUV.TO','HUC.TO'};

contracts_yahoo;
looperEngine.contracts=contracts;

looperEngine.ui.runOnce=1;
looperEngine.graph.saveFigures=1;
looperEngine.graph.show=2; %1 show if signals, 2 alwways show
looperEngine.graph.pauseAfterGraph=1;
looperEngine.date=basedate;
looperEngine.data.getdatainit=1;
looperEngine.data.getalldatainrealtime=1;
looperEngine.data.updaterealtime=0;
looperEngine.graph.showlimit=-1;
looperEngine.process.limit=-1;

useparfor=0; %0 do not use, Inf use



looperEngine.graph.scalepercent=1.1;