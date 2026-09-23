%% SETUP main

tempsymbol.params.contract=struct();%tempsymbol.params.contract.Symbol='AAPL'; %placeholder for yahoo crumb
%copied over, even though they could be set independetly
%tempsymbol.params.date=looperEngine.date;
%tempsymbol.params.getdatainit=looperEngine.data.getdatainit;
%tempsymbol.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
%tempsymbol.params.updaterealtime=looperEngine.data.updaterealtime;
%tempsymbol.params.graph=looperEngine.graph.show; 
%tempsymbol.params.showlimit=looperEngine.graph.showlimit;
%tempsymbol.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using

%% specific parameters

looperEngine.graph.scalepercent=1.1;
tempsymbol.params.lower_indicators={{'tradeStrategyBreakoutT8_signals'},{'tradeStrategyBreakoutT8_return'}};%{{'ShortTermPerformance'},{'BullBearCandleDiff'}};%={{'rsi5','MACD'},{'RelativeStrength'}};'tradeGroundTruth_signals'}
tempsymbol.params.upper_indicators={'BBupper','BBlower'};%{'BBupper','BBlower'};
%% SETUP sub
tempsymbol.params.doBookOnly=looperEngine.process.bookOnly;
tempsymbol.params.isGraphInit=0;

%tempsymbol.params.todayDataPeriod='1d';
tempsymbol.params.DirectionPredictionEnabled=[1;1;1];
tempsymbol.params.StopPredictionEnabled=[1;1;1];

tempsymbol.params.thresh.dcs.fight.min=.5;
tempsymbol.params.thresh.avs.min=.5;
tempsymbol.params.thresh.rvs.min=0.1; 
tempsymbol.params.thresh.dvs.open.min=0.1;
tempsymbol.params.thresh.dvs.close.min=0.1;
tempsymbol.params.thresh.dvs.total.min=0.1;
tempsymbol.params.thresh.dsma5.min=1/100*0.25;
tempsymbol.params.thresh.dsma5settling.min=1/100*0;
tempsymbol.params.thresh.ddsma5.min=1/100*0.25;

tempsymbol.params.thresh.dcs.fight.max=20;
tempsymbol.params.thresh.avs.max=80;
tempsymbol.params.thresh.rvs.max=5; 
tempsymbol.params.thresh.dvs.open.max=50;
tempsymbol.params.thresh.dvs.close.max=50;
tempsymbol.params.thresh.dvs.total.max=50;
tempsymbol.params.thresh.dsma5.max=1/100*50;
tempsymbol.params.thresh.dsma5settling.max=1/100*5; %this could be cver by Bolinger bands as well
tempsymbol.params.thresh.ddsma5.max=1/100*30;


tempsymbol.params.thresh.minNextLvlByPercent=1/100*4;
tempsymbol.params.thresh.maxLastLvlByPercent=1/100*1;
tempsymbol.params.thresh.maxTooCloseByPercent=1/100*0.25;

% tempsymbol.params.thresh.minNextLvlByPercent=1/100*0.05;

tempsymbol.params.lenPreviousDayPivots=30;
tempsymbol.params.localOptimaWidths=[10,21];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

tempsymbol.params.graphExtras{1}.commontick='SPY'; %if empty, calculate on itself?
tempsymbol.params.graphExtras{1}.practice=1; %1 being calculation of relative strength, this should go inside subindicators sometime later and become unified, where subindicators are all pre-done, but are only calculated if chosen


%'dcs2_fight','dcs2_open','dcs2_close','dcs2_total',...
%'dvs2_fight','dvs2_open','dvs2_close','dvs2_total',...
%'rvs2','avs2',...
%'dvs1_fight','dvs1_open','dvs1_close','dvs1_total',...
%
 tempsymbol.params.net.lower_indicators.inputs={'tick2ret','ChaikinVolatility',...
     'sma10ret','sma21ret',...
    'PercentileBollingerBW',... %'BBlowerret','BBupperret'
     'PriceVolumeTrend',...
 'dcs_fight','dcs_total','dcs_open','dcs_close',...
  'dvs_fight','dvs_total',...
  'BullBearCandleDiff',...
 'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent'};

% tempsymbol.params.net.lower_indicators.inputs={'rsi5','rsi10','rsi21','NVI','PVI','ADO','PriceVolumeTrend','OnBalanceVolume','ChaikinVolatility','dsma5','ddsma5',...
%  'dcs1_fight','dcs1_open','dcs1_close','dcs1_total',...
%  'rvs1','avs1',...
%  'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent'};

tempsymbol.params.net.upper_indicators.inputs={};%'nsma10','nsma21','nsma50'};
tempsymbol.params.net.lower_indicators.targets={'tradeGroundTruth_signals'};

