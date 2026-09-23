%% SETUP main

tempsymbol.params.contract=struct();%tempsymbol.params.contract.Symbol='AAPL'; %placeholder for yahoo crumb
%copied over, even though they could be set independetly
% tempsymbol.params.date=looperEngine.date;
% tempsymbol.params.getdatainit=looperEngine.data.getdatainit;
% tempsymbol.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
% tempsymbol.params.updaterealtime=looperEngine.data.updaterealtime;
% tempsymbol.params.graph=looperEngine.graph.show; 
% tempsymbol.params.showlimit=looperEngine.graph.showlimit;
% tempsymbol.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using


looperEngine.graph.scalepercent=1.1;


tempsymbol.params.lower_indicators={};%={{'rsi5','MACD'},{'RelativeStrength'}};





tempsymbol.params.upper_indicators={'BBupper','BBlower'};
%% SETUP sub
tempsymbol.params.doBookOnly=looperEngine.process.bookOnly;
tempsymbol.params.isGraphInit=0;

%tempsymbol.params.todayDataPeriod='1d';% '1d'; '5d'
tempsymbol.params.DirectionPredictionEnabled=[1;1;1;1;1;1];
tempsymbol.params.StopPredictionEnabled=[1;1;1;1;1;1];

tempsymbol.params.thresh.dcs.fight.min=1;
tempsymbol.params.thresh.avs.min=1.5;
tempsymbol.params.thresh.rvs.min=0.3; 
tempsymbol.params.thresh.dvs.open.min=0.1;
tempsymbol.params.thresh.dvs.close.min=0.1;
tempsymbol.params.thresh.dvs.total.min=0.1;
tempsymbol.params.thresh.dsma5.min=1/100*.75;
tempsymbol.params.thresh.dsma5settling.min=1/100*0;
tempsymbol.params.thresh.ddsma5.min=1/100*0.1;
tempsymbol.params.thresh.ret_sma5.min=1/100*.075;

tempsymbol.params.thresh.volumeBuzz.min=1.5;
tempsymbol.params.thresh.volumeBuzz.max=5;

tempsymbol.params.thresh.oversoldPercent.min=1/100*0;
tempsymbol.params.thresh.oversoldPercent.max=1/100*60;
tempsymbol.params.thresh.overboughtPercent.min=1/100*40;
tempsymbol.params.thresh.overboughtPercent.max=1/100*100;

tempsymbol.params.thresh.dcs.fight.max=10;
tempsymbol.params.thresh.avs.max=30;
tempsymbol.params.thresh.rvs.max=3; 
tempsymbol.params.thresh.dvs.open.max=50;
tempsymbol.params.thresh.dvs.close.max=50;
tempsymbol.params.thresh.dvs.total.max=50;
tempsymbol.params.thresh.dsma5.max=1/100*25;
tempsymbol.params.thresh.dsma5settling.max=1/100*3; %this could be cver by Bolinger bands as well
tempsymbol.params.thresh.ddsma5.max=1/100*15;
tempsymbol.params.thresh.ret_sma5.max=1/100*2.5;

tempsymbol.params.thresh.zerocrossing=0.1;

tempsymbol.params.thresh.minNextLvlByPercent=1/100*10;
tempsymbol.params.thresh.maxLastLvlByPercent=1/100*2.5;
tempsymbol.params.thresh.maxTooCloseByPercent=1/100*.75;

tempsymbol.params.lenPreviousDayPivots=2;
tempsymbol.params.localOptimaWidths=[10,21];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

%tempsymbol.params.graphExtras{1}.commontick='SPY'; %if empty, calculate on itself?
%tempsymbol.params.graphExtras{1}.practice=1; %1 being calculation of relative strength, this should go inside subindicators sometime later and become unified, where subindicators are all pre-done, but are only calculated if chosen

tempsymbol.params.thresh.ShortTermPerformance.min=0.1;

tempsymbol.params.thresh.futureGroundTruthHalfWindowSize_ShortTerm=10;
tempsymbol.params.thresh.futureGroundTruthHalfWindowSize_MidTerm=30;
tempsymbol.params.thresh.futureGroundTruthHalfWindowSize_LongTerm=60;

di=1;
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,1}=[1 ,2 ,3 ,9 ,15,11,23,21,28,29]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,2}=[20,4 ,5 ,9 ,10,16,24,22,27,30];  di=di+1;
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,1}=[1 ,2 ,3 ,9 ,15,23,21,28,29,42]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,2}=[20,4 ,5 ,9 ,10,24,22,27,30,41];  di=di+1;
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,1}=[1 ,31,8 ,9 ,10,11,21,29,33,42]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,2}=[20,32,14,15,16,9 ,22,30,34,41]; di=di+1;
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,1}=[1,6,17,8,9, 19,10,11,29];  %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{di,2}=[20,12,18,9 ,14,19,15,16,30]; di=di+1;

di=1;
% tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[35,37]; %upward
% tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[36,38]; 
% di=di+1;
%tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[8,31 ,30,33]; %upward
%tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[14,32,29,34]; 
%di=di+1;
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[3];%,43,45]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[5];%,44,46]; 

%second trend, do cumulative trend
        tempsymbol.params.Strategies.TotalConditions.Conditions.Entry{1}=  1.04*[0.565861087060274,0.193049923668335,0.176931786291271,0.152740977276242,0.101193955253341,0.576591743163044,0.207466069124653,0.507804340338937,0.696242346236176,0.320127353026965,0.497128617019908,0.669077649563920,0.169563857192852,0.429695659661063,0.322685505318235,0.359311054819081,0.261786229145133,0.131699645061467,0.745947452148549,0.786419483476214,0.388801048842657,0.240812941949790,0.380924212734423,0.420558327552852,0.348175639364982,0.256441140146174,0.405118906419972,0.600437681996918,0.910183934411877,0.891980269105872,0.532381093580028,0.337062318003082,0.411418774718896,0.402444146892282,0.257489993955128,0.293487920001694,0.440371382980092,0.578188945180919,0.462005552384842,0.475494447615158,0.641994837612276,0.615971281734858,0.00142045454545455,0.0103490259740260,0.0227783748989106,0.0586231105204320,0]';
     tempsymbol.params.Strategies.TotalConditions.Conditions.Entry{2}=[0.650260493363584,0.141409382586481,0.0974339450750833,0.177660539458347,0.142225567489546,0.779486964703964,0.201116178516408,0.354801198294488,0.678121510188560,0.423474805181214,0.294093897478708,0.549901442870565,0.225527392071256,0.645198801705513,0.184403716798478,0.543801483209511,0.214707045853664,0.197274700937560,0.755716694393913,0.793495550189876,0.195494083394702,0.390654380887508,0.313036383719025,0.561113309278973,0.262805277999808,0.345210440358061,0.566715106383085,0.542082914401515,0.993673793413377,0.921430432674872,0.433284893616915,0.457917085598485,0.430185700679990,0.412896658747031,0.263219163913574,0.288636484706723,0.705906102521292,0.456198516790489,0.498064245210285,0.501935754789716,0.505647635822480,0.791664267419709,0.0113153594771242,0.00710784313725490,0.0503705328285160,0.0301879084967320,0]';

     
     tempsymbol.params.thresh.totalConditions.min=1.9;
     tempsymbol.params.thresh.totalConditions.max=50;
     
% to remove all conditions
%tempsymbol.params.Strategies.Manual.Conditions.Entry={47,47};
%tempsymbol.params.Strategies.Manual.Conditions.Exit={47,47};

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
 'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent',...
 'ret_sma5_close','ret_sma5_open'};

% tempsymbol.params.net.lower_indicators.inputs={'rsi5','rsi10','rsi21','NVI','PVI','ADO','PriceVolumeTrend','OnBalanceVolume','ChaikinVolatility','dsma5','ddsma5',...
%  'dcs1_fight','dcs1_open','dcs1_close','dcs1_total',...
%  'rvs1','avs1',...
%  'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent'};

tempsymbol.params.net.upper_indicators.inputs={};%'nsma10','nsma21','nsma50'};
tempsymbol.params.net.lower_indicators.targets={'tradeGroundTruth_signals'};


