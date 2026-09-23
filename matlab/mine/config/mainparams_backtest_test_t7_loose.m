%% SETUP main

tempsymbol.params.contract=struct();%tempsymbol.params.contract.Symbol='AAPL'; %placeholder for yahoo crumb
%copied over, even though they could be set independetly
tempsymbol.params.date=looperEngine.date;
tempsymbol.params.getdatainit=looperEngine.data.getdatainit;
tempsymbol.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
tempsymbol.params.updaterealtime=looperEngine.data.updaterealtime;
tempsymbol.params.graph=looperEngine.graph.show; 
tempsymbol.params.showlimit=looperEngine.graph.showlimit;
tempsymbol.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using
looperEngine.graph.scalepercent=1.1;
tempsymbol.params.lower_indicators={{'rsi5'},{'tradeGroundTruth_signals'}};%={{'rsi5','MACD'},{'RelativeStrength'}};
tempsymbol.params.upper_indicators={};%{'BBupper','BBlower'};
%% SETUP sub
tempsymbol.params.doBookOnly=looperEngine.process.bookOnly;
tempsymbol.params.isGraphInit=0;

%tempsymbol.params.todayDataPeriod='1d';% '1d'; '5d'
tempsymbol.params.DirectionPredictionEnabled=[1;1;1];
tempsymbol.params.thresh.dcs.fight.min=1.1;
tempsymbol.params.thresh.avs.min=2;
tempsymbol.params.thresh.rvs.min=0.3; 
tempsymbol.params.thresh.dvs.open.min=0.3;
tempsymbol.params.thresh.dvs.close.min=0.2;
tempsymbol.params.thresh.dvs.total.min=0.2;
tempsymbol.params.thresh.dsma5.min=1/100*0.03;
tempsymbol.params.thresh.dsma5settling.min=1/100*0;
tempsymbol.params.thresh.ddsma5.min=1/100*0.02;

tempsymbol.params.thresh.dcs.fight.max=10;
tempsymbol.params.thresh.avs.max=40;
tempsymbol.params.thresh.rvs.max=3; 
tempsymbol.params.thresh.dvs.open.max=50;
tempsymbol.params.thresh.dvs.close.max=50;
tempsymbol.params.thresh.dvs.total.max=50;
tempsymbol.params.thresh.dsma5.max=1/100*5;
tempsymbol.params.thresh.dsma5settling.max=1/100*2;
tempsymbol.params.thresh.ddsma5.max=1/100*5;


tempsymbol.params.thresh.minNextLvlByPercent=1/100*0.05;

tempsymbol.params.thresh.ShortTermPerformance.min=0.05;


%tempsymbol.params.Strategies.Manual.Conditions.Entry{1,1}=[1 ,2 ,3 ,15,11,23,21,28,29]; %upward
%tempsymbol.params.Strategies.Manual.Conditions.Entry{1,2}=[20,4 ,5 ,10,16,24,22,27,30]; 
tempsymbol.params.Strategies.Manual.Conditions.Entry{1,1}=[1 ,2 ,3 ,15,23,21,28,29,42]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{1,2}=[20,4 ,5 ,10,24,22,27,30,41]; 
tempsymbol.params.Strategies.Manual.Conditions.Entry{2,1}=[1 ,31,8 ,9 ,10,11,21,29,33,42]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{2,2}=[20,32,14,15,16,9 ,22,30,34,41];
%tempsymbol.params.Strategies.Manual.Conditions.Entry{3,1}=[1,6,17,8,19,10,11,29];  %upward
%tempsymbol.params.Strategies.Manual.Conditions.Entry{3,2}=[20,12,18,14,19,15,16,30];

di=1;
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[35,37]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[36,38]; 
di=di+1;
%tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[8,31 ,30,33]; %upward
%tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[14,32,29,34]; 
%di=di+1;
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[3,43,45]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[5,44,46]; 


tempsymbol.params.lenPreviousDayPivots=2;
tempsymbol.params.localOptimaWidths=[10,21];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

tempsymbol.params.graphExtras{1}.commontick='SPY'; %if empty, calculate on itself?
tempsymbol.params.graphExtras{1}.practice=1; %1 being calculation of relative strength, this should go inside subindicators sometime later and become unified, where subindicators are all pre-done, but are only calculated if chosen