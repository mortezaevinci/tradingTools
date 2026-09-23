%% SETUP main

tempsymbol.params.symbol='AAPL'; %placeholder for yahoo crumb
%copied over, even though they could be set independetly
%tempsymbol.params.date=looperParams.date;
%tempsymbol.params.getdatainit=looperParams.getdatainit;
%tempsymbol.params.getalldatainrealtime=looperParams.getalldatainrealtime;
%tempsymbol.params.updaterealtime=looperParams.updaterealtime;
%tempsymbol.params.graph=looperParams.graph.show; 
%tempsymbol.params.showlimit=looperParams.graph.showlimit;
%tempsymbol.params.processlimit=looperParams.processlimit;  %this may malfunction in some studies, try not using

%% specific parameters

tempsymbol.params.scalepercent=1.1;
tempsymbol.params.lower_indicators={{'rsi7'},{'buysellsignals'}};%={{'rsi7','MACD'},{'RelativeStrength'}};
tempsymbol.params.upper_indicators={'BBupper','BBlower'};
%% SETUP sub
tempsymbol.params.doBookOnly=looperParams.doBookOnly;
tempsymbol.params.isGraphInit=0;

%tempsymbol.params.todayDataPeriod='1d';
tempsymbol.params.enabled=[1;1;1];

tempsymbol.params.thresh.dcs.fight.min=1.1;
tempsymbol.params.thresh.avs.min=2;
tempsymbol.params.thresh.rvs.min=0.3; 
tempsymbol.params.thresh.dvs.open.min=0.3;
tempsymbol.params.thresh.dvs.close.min=0.2;
tempsymbol.params.thresh.dvs.total.min=0.2;
tempsymbol.params.thresh.dsma5.min=0.03;
tempsymbol.params.thresh.dsma5settling.min=0;
tempsymbol.params.thresh.ddsma5.min=0.02;

tempsymbol.params.thresh.dcs.fight.max=10;
tempsymbol.params.thresh.avs.max=40;
tempsymbol.params.thresh.rvs.max=3; 
tempsymbol.params.thresh.dvs.open.max=50;
tempsymbol.params.thresh.dvs.close.max=50;
tempsymbol.params.thresh.dvs.total.max=50;
tempsymbol.params.thresh.dsma5.max=5;
tempsymbol.params.thresh.dsma5settling.max=2;
tempsymbol.params.thresh.ddsma5.max=5;

tempsymbol.params.thresh.minNextLvlByPercent=0.05;


% tempsymbol.params.thresh.minNextLvlByPercent=0.05;

tempsymbol.params.lenPreviousDayPivots=1;
tempsymbol.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

tempsymbol.params.graphExtras{1}.commontick='SPY'; %if empty, calculate on itself?
tempsymbol.params.graphExtras{1}.practice=1; %1 being calculation of relative strength, this should go inside subindicators sometime later and become unified, where subindicators are all pre-done, but are only calculated if chosen


%'dcs2_fight','dcs2_open','dcs2_close','dcs2_total',...
%'dvs2_fight','dvs2_open','dvs2_close','dvs2_total',...
%'rvs2','avs2',...
%'dvs1_fight','dvs1_open','dvs1_close','dvs1_total',...
%
 tempsymbol.params.net.lower_indicators.inputs={'tick2ret','rsi7','rsi14','rsi21','ChaikinVolatility','dsma5','ddsma5',...
 'dcs1_fight','dcs1_open','dcs1_close','dcs1_total',...
 'fromUpperLevelPercent','fromLowerLevelPercent'};

% tempsymbol.params.net.lower_indicators.inputs={'rsi7','rsi14','rsi21','NVI','PVI','ADO','PriceVolumeTrend','OnBalanceVolume','ChaikinVolatility','dsma5','ddsma5',...
%  'dcs1_fight','dcs1_open','dcs1_close','dcs1_total',...
%  'rvs1','avs1',...
%  'fromUpperLevelPercent','fromLowerLevelPercent'};

tempsymbol.params.net.upper_indicators.inputs={};%'NSMA7','NSMA14','NSMA21'};
tempsymbol.params.net.lower_indicators.targets={'buysellsignals'};

