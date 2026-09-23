% pre-orders approach
% we have contract triggers
% We have an IBCD template (load it and fill it basically)
% for each contractTrigger
% Read template
% Set quantities of ALL orders to int(accountRisk/entrylevel)
base='Z:\My files\Project trading\traderdata\data_other\IB\';
conidmapfn=[base 'conids.mat'];
date0='2021-01-24';
tradedate='2021-01-25';

placeorders=1;
section=3;
method=1; 
ports=[4001];

base_trader='Z:\My files\Project trading\traderdata\algotrading\autoswing\trader_live\';

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order stp lmt template 6');

