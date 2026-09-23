% pre-orders approach
% we have contract triggers
% We have an IBCD template (load it and fill it basically)
% for each contractTrigger
% Read template
% Set quantities of ALL orders to int(accountRisk/entrylevel)
base_trader='Z:\My files\Project trading\traderdata\algotrading\autoswing\trader\';

[date0,tradedate]=PrevAndTradeDate();

placeorders=0;
section=1;
method=4; 
ports=[4004];

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order lmt template 6 premarket');

placeorders=0;
section=1;
method=4; 
ports=[4004];

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order lmt template 6 postmarket');


placeorders=0;
section=1;
method=3; 
ports=[4004];

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order lmt template 6 premarket');

placeorders=0;
section=1;
method=3; 
ports=[4004];

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order lmt template 6 postmarket');

placeorders=0;
section=2;
method=3; 
ports=[4004];

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order lmt template reg 6');

placeorders=1;
ports=[4002];
section=1;
method=1;

traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,'auto swing order lmt template swing 6');
