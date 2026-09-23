% pre-orders approach
% we have contract triggers
% We have an IBCD template (load it and fill it basically)
% for each contractTrigger
% Read template
% Set quantities of ALL orders to int(accountRisk/entrylevel)

[date0,tradedate]=PrevAndTradeDate();

placeorders=1;
section=0;
method=0; 
ports=[4002];

traderPreorder_portfolio(ports,date0,tradedate,placeorders,section,method,'template 6 portfolio');