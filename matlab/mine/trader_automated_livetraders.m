date0='2020-12-27';
tradedate='2020-12-28';

base='Z:\My files\Project trading\traderdata\data_other\IB\';
base_trader='Z:\My files\Project trading\traderdata\algotrading\autoswing\trader_live\';

conidmapfn=[base 'conids.mat'];

placeorders=1;
section=3;
method=1; 
ports=[4001];

fn=['Z:\My files\Project Trading\groups\livetraders\' 'newsletter ' date0 '.eml'];
contractTriggers=liveTraders2contractTriggers(fn,date0);

base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\';
ctfn=[base_profiling 'contractTriggers' ' ' 'livetraders-swing' ' ' date0 '.mat'];
save(ctfn,'contractTriggers');

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order stp lmt template 6');