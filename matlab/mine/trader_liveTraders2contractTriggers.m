date0='2021-01-24';
base='Z:\My files\Project trading\traderdata\data_other\IB\';
fn=['Z:\My files\Project Trading\groups\livetraders\' 'newsletter ' date0 '.eml'];
contractTriggers=liveTraders2contractTriggers(fn,date0);

base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\';
ctfn=[base_profiling 'contractTriggers' ' ' 'livetraders-swing' ' ' date0 '.mat'];
save(ctfn,'contractTriggers');