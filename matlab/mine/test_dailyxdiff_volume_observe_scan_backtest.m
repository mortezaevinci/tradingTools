method=1;
doalldates=1;
genfigsdaily=1;
[date0,tradedate]=PrevAndTradeDate();

contractTriggers=scanDailyXDiff(date0,method,doalldates,genfigsdaily);
method=2;
contractTriggers=scanDailyXDiff(date0,method,doalldates,genfigsdaily);
method=3;
contractTriggers=scanDailyXDiff(date0,method,doalldates,genfigsdaily);
method=4;
contractTriggers=scanDailyXDiff(date0,method,doalldates,genfigsdaily);

base='Z:\My files\Project trading\traderdata\data_other\IB\';
methods={'pre-comprehensive','pre-explosivevol','pre-aggresivevol','pre-xaggresivevol'};
method=1;
figures=['M:\temp\figures_rscan_' ' ' methods{method} ' ' date0 '\'];
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\backtest\';
ctfn=[base_profiling 'contractTriggers' ' ' methods{method} ' ' date0 '.mat'];
load(ctfn);
 jlist=[1,2,3];
 test_dailyxdiff_volume_observe_backtest_intraday;
 
 method=2;
figures=['M:\temp\figures_rscan_' ' ' methods{method} ' ' date0 '\'];
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\backtest\';
ctfn=[base_profiling 'contractTriggers' ' ' methods{method} ' ' date0 '.mat'];
load(ctfn);
 jlist=[1,2,3];
 test_dailyxdiff_volume_observe_backtest_intraday;
 
 method=3;
figures=['M:\temp\figures_rscan_' ' ' methods{method} ' ' date0 '\'];
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\backtest\';
ctfn=[base_profiling 'contractTriggers' ' ' methods{method} ' ' date0 '.mat'];
load(ctfn);
 jlist=[1,2,3];
 test_dailyxdiff_volume_observe_backtest_intraday;
 
 method=4;
figures=['M:\temp\figures_rscan_' ' ' methods{method} ' ' date0 '\'];
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\backtest\';
ctfn=[base_profiling 'contractTriggers' ' ' methods{method} ' ' date0 '.mat'];
load(ctfn);
 jlist=[1,2,3];
 test_dailyxdiff_volume_observe_backtest_intraday;
