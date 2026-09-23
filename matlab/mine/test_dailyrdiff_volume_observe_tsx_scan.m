doalldates=0;
genfigsdaily=0;
[date0,tradedate]=PrevAndTradeDate();
contracts_tsx;

base='Z:\My files\Project trading\traderdata\data\';
if (doalldates==0)
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\tsx\triggers\';
else
  base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\tsx\triggers\backtest\';  
end
if (~exist(base_profiling))
    mkdir (base_profiling);
end

method=4;
contractTriggers=scanDailyRDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);

method=3;
contractTriggers=scanDailyRDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);

method=1;
contractTriggers=scanDailyRDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);

method=2;
contractTriggers=scanDailyRDiff(base,base_profiling,contracts,date0,method,doalldates,genfigsdaily);
