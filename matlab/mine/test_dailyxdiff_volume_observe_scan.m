doalldates=0;
genfigsdaily=0;
[date0,tradedate]=PrevAndTradeDate();

contracts_penniesm2_trade;
base='Z:\My files\Project trading\traderdata\data_other\IB\';
if (doalldates==0)
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\';
else
  base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\backtest\';  
end
if (~exist(base_profiling))
    mkdir (base_profiling);
end

method=4;
contractTriggers=scanDailyXDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);

method=3;
contractTriggers=scanDailyXDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);

method=1;
contractTriggers=scanDailyXDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);

method=2;
contractTriggers=scanDailyXDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);
