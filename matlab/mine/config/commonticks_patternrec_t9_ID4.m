cindex=1;

commonticks{cindex}.params.contract=genContract([],'SPY');

%% SETUP main

%copied over, even though they could be set independetly
commonticks{cindex}.params.date=looperEngine.date;
commonticks{cindex}.params.getdatainit=looperEngine.data.getdatainit;
commonticks{cindex}.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
commonticks{cindex}.params.updaterealtime=looperEngine.data.updaterealtime;
commonticks{cindex}.params.graph=looperEngine.graph.show; 
commonticks{cindex}.params.showlimit=looperEngine.graph.showlimit;
commonticks{cindex}.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using
commonticks{cindex}.params.scalepercent=1.1;
commonticks{cindex}.params.lower_indicators={};%cell(1,2);
commonticks{cindex}.params.upper_indicators={};
%% SETUP sub

commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'

commonticks{cindex}.params.StopPredictionEnabled=[1;1;1];
commonticks{cindex}.params.DirectionPredictionEnabled=[1;1;1];
commonticks{cindex}.params.thresh=default_threshold();

commonticks{cindex}.params.lenPreviousDayPivots=2;
commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

commonticks{cindex}.params.Strategies.Manual.Conditions.Entry={47,47};
commonticks{cindex}.params.Strategies.Manual.Conditions.Exit={47,47};

  % commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=[0.5 1 1 0 0 0 1 1 0.5 0 1 0 0 0 1 0 1 0 0.5 0   0.5 0.5 1 0 1 0 0 1 0.5 0   1 0 0 0 0 0 0 1 0 0 0.5 0 0 0 0 0 0]';
   %  commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0   0 0 1 1 0 0 0 0.5 1 0 0 1 1 0 1 0 1 0.5 0.5 0.5 0.5 0 1 0 1 1 0 0   0.5 0 1 0 0 0 0 1 0 0 0 0 0.5 0 0 0 0 0]';
 %    commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=  1.04*[0.565861087060274,0.193049923668335,0.176931786291271,0.152740977276242,0.101193955253341,0.576591743163044,0.207466069124653,0.507804340338937,0.696242346236176,0.320127353026965,0.497128617019908,0.669077649563920,0.169563857192852,0.429695659661063,0.322685505318235,0.359311054819081,0.261786229145133,0.131699645061467,0.745947452148549,0.786419483476214,0.388801048842657,0.240812941949790,0.380924212734423,0.420558327552852,0.348175639364982,0.256441140146174,0.405118906419972,0.600437681996918,0.910183934411877,0.891980269105872,0.532381093580028,0.337062318003082,0.411418774718896,0.402444146892282,0.257489993955128,0.293487920001694,0.440371382980092,0.578188945180919,0.462005552384842,0.475494447615158,0.641994837612276,0.615971281734858,0.00142045454545455,0.0103490259740260,0.0227783748989106,0.0586231105204320,0]';
  %   commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0.650260493363584,0.141409382586481,0.0974339450750833,0.177660539458347,0.142225567489546,0.779486964703964,0.201116178516408,0.354801198294488,0.678121510188560,0.423474805181214,0.294093897478708,0.549901442870565,0.225527392071256,0.645198801705513,0.184403716798478,0.543801483209511,0.214707045853664,0.197274700937560,0.755716694393913,0.793495550189876,0.195494083394702,0.390654380887508,0.313036383719025,0.561113309278973,0.262805277999808,0.345210440358061,0.566715106383085,0.542082914401515,0.993673793413377,0.921430432674872,0.433284893616915,0.457917085598485,0.430185700679990,0.412896658747031,0.263219163913574,0.288636484706723,0.705906102521292,0.456198516790489,0.498064245210285,0.501935754789716,0.505647635822480,0.791664267419709,0.0113153594771242,0.00710784313725490,0.0503705328285160,0.0301879084967320,0]';

     %commonticks{cindex}.params.net.lower_indicators.inputs={'tick2ret','ret_sma5_close'};%,'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent'};%,'ret_sma5_low','ret_sma5_high','ret_sma5_open'};%,'BullBearCandleDiff','totalConditions'};
commonticks{cindex}.params.net.lower_indicators.inputs={'rsi5','VolumeBuzzRatio','SellVolumeBuzzRatio','BuyVolumeBuzzRatio',...
    'relativeQuote','relativeQuote5','relativeQuote10','relativeQuote21','relativeQuote50',...
    'dcs_close10','dcs_total10','dcs_close','dcs_total','ChaikinVolatility',...
    'BullBearCandleDiff',...
'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent',...
'OpenFromUpperLevelPercent','OpenFromLowerLevelPercent'};

%commonticks{cindex}.params.net.lower_indicators.inputs={'tick2ret','sma10ret','sma21ret'};
commonticks{cindex}.params.net.upper_indicators.inputs={};%'nsma10'};%,'nsma21','nsma50'};
commonticks{cindex}.params.net.eval_indicators.inputs={};

%% next one
cindex=cindex+1;

commonticks{cindex}.params.contract=genContract([],'$VOLD');

%% SETUP main

%copied over, even though they could be set independetly
commonticks{cindex}.params.date=looperEngine.date;
commonticks{cindex}.params.getdatainit=looperEngine.data.getdatainit;
commonticks{cindex}.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
commonticks{cindex}.params.updaterealtime=looperEngine.data.updaterealtime;
commonticks{cindex}.params.graph=looperEngine.graph.show; 
commonticks{cindex}.params.showlimit=looperEngine.graph.showlimit;
commonticks{cindex}.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using
commonticks{cindex}.params.scalepercent=1.1;
commonticks{cindex}.params.lower_indicators={};%cell(1,2);
commonticks{cindex}.params.upper_indicators={};
%% SETUP sub

commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'

commonticks{cindex}.params.StopPredictionEnabled=[1;1;1];
commonticks{cindex}.params.DirectionPredictionEnabled=[1;1;1];
commonticks{cindex}.params.thresh=default_threshold();

commonticks{cindex}.params.lenPreviousDayPivots=2;
commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

commonticks{cindex}.params.Strategies.Manual.Conditions.Entry={47,47};
commonticks{cindex}.params.Strategies.Manual.Conditions.Exit={47,47};

  % commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=[0.5 1 1 0 0 0 1 1 0.5 0 1 0 0 0 1 0 1 0 0.5 0   0.5 0.5 1 0 1 0 0 1 0.5 0   1 0 0 0 0 0 0 1 0 0 0.5 0 0 0 0 0 0]';
   %  commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0   0 0 1 1 0 0 0 0.5 1 0 0 1 1 0 1 0 1 0.5 0.5 0.5 0.5 0 1 0 1 1 0 0   0.5 0 1 0 0 0 0 1 0 0 0 0 0.5 0 0 0 0 0]';
   %  commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=  1.04*[0.565861087060274,0.193049923668335,0.176931786291271,0.152740977276242,0.101193955253341,0.576591743163044,0.207466069124653,0.507804340338937,0.696242346236176,0.320127353026965,0.497128617019908,0.669077649563920,0.169563857192852,0.429695659661063,0.322685505318235,0.359311054819081,0.261786229145133,0.131699645061467,0.745947452148549,0.786419483476214,0.388801048842657,0.240812941949790,0.380924212734423,0.420558327552852,0.348175639364982,0.256441140146174,0.405118906419972,0.600437681996918,0.910183934411877,0.891980269105872,0.532381093580028,0.337062318003082,0.411418774718896,0.402444146892282,0.257489993955128,0.293487920001694,0.440371382980092,0.578188945180919,0.462005552384842,0.475494447615158,0.641994837612276,0.615971281734858,0.00142045454545455,0.0103490259740260,0.0227783748989106,0.0586231105204320,0]';
  %   commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0.650260493363584,0.141409382586481,0.0974339450750833,0.177660539458347,0.142225567489546,0.779486964703964,0.201116178516408,0.354801198294488,0.678121510188560,0.423474805181214,0.294093897478708,0.549901442870565,0.225527392071256,0.645198801705513,0.184403716798478,0.543801483209511,0.214707045853664,0.197274700937560,0.755716694393913,0.793495550189876,0.195494083394702,0.390654380887508,0.313036383719025,0.561113309278973,0.262805277999808,0.345210440358061,0.566715106383085,0.542082914401515,0.993673793413377,0.921430432674872,0.433284893616915,0.457917085598485,0.430185700679990,0.412896658747031,0.263219163913574,0.288636484706723,0.705906102521292,0.456198516790489,0.498064245210285,0.501935754789716,0.505647635822480,0.791664267419709,0.0113153594771242,0.00710784313725490,0.0503705328285160,0.0301879084967320,0]';

commonticks{cindex}.params.net.lower_indicators.inputs={'relativeQuote','relativeQuote5','relativeQuote10','relativeQuote21','relativeQuote50'};
commonticks{cindex}.params.net.upper_indicators.inputs={};
commonticks{cindex}.params.net.eval_indicators.inputs={};

% % next one
% 
% cindex=cindex+1;
% 
% commonticks{cindex}.params.contract=genContract([],'$TICK');
% 
% %% SETUP main
% 
% %copied over, even though they could be set independetly
% commonticks{cindex}.params.date=looperEngine.date;
% commonticks{cindex}.params.getdatainit=looperEngine.data.getdatainit;
% commonticks{cindex}.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
% commonticks{cindex}.params.updaterealtime=looperEngine.data.updaterealtime;
% commonticks{cindex}.params.graph=looperEngine.graph.show; 
% commonticks{cindex}.params.showlimit=looperEngine.graph.showlimit;
% commonticks{cindex}.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using
% commonticks{cindex}.params.scalepercent=1.1;
% commonticks{cindex}.params.lower_indicators={};%cell(1,2);
% commonticks{cindex}.params.upper_indicators={};
% %% SETUP sub
% 
% commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'
% 
% commonticks{cindex}.params.StopPredictionEnabled=[1;1;1];
% commonticks{cindex}.params.DirectionPredictionEnabled=[1;1;1];
% commonticks{cindex}.params.thresh=default_threshold();
% 
% commonticks{cindex}.params.lenPreviousDayPivots=2;
% commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];
% 
% commonticks{cindex}.params.Strategies.Manual.Conditions.Entry={47,47};
% commonticks{cindex}.params.Strategies.Manual.Conditions.Exit={47,47};
% 
%   % commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=[0.5 1 1 0 0 0 1 1 0.5 0 1 0 0 0 1 0 1 0 0.5 0   0.5 0.5 1 0 1 0 0 1 0.5 0   1 0 0 0 0 0 0 1 0 0 0.5 0 0 0 0 0 0]';
%    %  commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0   0 0 1 1 0 0 0 0.5 1 0 0 1 1 0 1 0 1 0.5 0.5 0.5 0.5 0 1 0 1 1 0 0   0.5 0 1 0 0 0 0 1 0 0 0 0 0.5 0 0 0 0 0]';
%      commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=  1.04*[0.565861087060274,0.193049923668335,0.176931786291271,0.152740977276242,0.101193955253341,0.576591743163044,0.207466069124653,0.507804340338937,0.696242346236176,0.320127353026965,0.497128617019908,0.669077649563920,0.169563857192852,0.429695659661063,0.322685505318235,0.359311054819081,0.261786229145133,0.131699645061467,0.745947452148549,0.786419483476214,0.388801048842657,0.240812941949790,0.380924212734423,0.420558327552852,0.348175639364982,0.256441140146174,0.405118906419972,0.600437681996918,0.910183934411877,0.891980269105872,0.532381093580028,0.337062318003082,0.411418774718896,0.402444146892282,0.257489993955128,0.293487920001694,0.440371382980092,0.578188945180919,0.462005552384842,0.475494447615158,0.641994837612276,0.615971281734858,0.00142045454545455,0.0103490259740260,0.0227783748989106,0.0586231105204320,0]';
%      commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0.650260493363584,0.141409382586481,0.0974339450750833,0.177660539458347,0.142225567489546,0.779486964703964,0.201116178516408,0.354801198294488,0.678121510188560,0.423474805181214,0.294093897478708,0.549901442870565,0.225527392071256,0.645198801705513,0.184403716798478,0.543801483209511,0.214707045853664,0.197274700937560,0.755716694393913,0.793495550189876,0.195494083394702,0.390654380887508,0.313036383719025,0.561113309278973,0.262805277999808,0.345210440358061,0.566715106383085,0.542082914401515,0.993673793413377,0.921430432674872,0.433284893616915,0.457917085598485,0.430185700679990,0.412896658747031,0.263219163913574,0.288636484706723,0.705906102521292,0.456198516790489,0.498064245210285,0.501935754789716,0.505647635822480,0.791664267419709,0.0113153594771242,0.00710784313725490,0.0503705328285160,0.0301879084967320,0]';
% 
% 
% commonticks{cindex}.params.net.lower_indicators.inputs={'tick2ret','relativeQuote','deltaQuote5','deltaQuote10','deltaQuote21','deltaQuote50'};
% commonticks{cindex}.params.upper_indicators={};

% %% next one
% 
% cindex=cindex+1;
% 
% commonticks{cindex}.params.contract=genContract([],'GLD');
% 
% %% SETUP main
% 
% %copied over, even though they could be set independetly
% commonticks{cindex}.params.date=looperEngine.date;
% commonticks{cindex}.params.getdatainit=looperEngine.data.getdatainit;
% commonticks{cindex}.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
% commonticks{cindex}.params.updaterealtime=looperEngine.data.updaterealtime;
% commonticks{cindex}.params.graph=looperEngine.graph.show; 
% commonticks{cindex}.params.showlimit=looperEngine.graph.showlimit;
% commonticks{cindex}.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using
% commonticks{cindex}.params.scalepercent=1.1;
% commonticks{cindex}.params.lower_indicators={};%cell(1,2);
% commonticks{cindex}.params.upper_indicators={};
% %% SETUP sub
% 
% commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'
% commonticks{cindex}.params.StopPredictionEnabled=[1;1;1];
% commonticks{cindex}.params.DirectionPredictionEnabled=[1;1;1];
% commonticks{cindex}.params.thresh=default_threshold();
% 
% commonticks{cindex}.params.lenPreviousDayPivots=2;
% commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];
% 
% commonticks{cindex}.params.net.lower_indicators.inputs={'relativeQuote','deltaQuote5','deltaQuote10','deltaQuote21','deltaQuote50'};
% 
% 
% %commonticks{cindex}.params.net.lower_indicators.inputs={'sma10ret','sma21ret'};
% commonticks{cindex}.params.net.upper_indicators.inputs={};
% 
% 
% commonticks{cindex}.params.Strategies.Manual.Conditions.Entry={47,47};
% commonticks{cindex}.params.Strategies.Manual.Conditions.Exit={47,47};
% 
% 
%     % commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=[0.5 1 1 0 0 0 1 1 0.5 0 1 0 0 0 1 0 1 0 0.5 0   0.5 0.5 1 0 1 0 0 1 0.5 0   1 0 0 0 0 0 0 1 0 0 0.5 0 0 0 0 0 0]';
%    %  commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0   0 0 1 1 0 0 0 0.5 1 0 0 1 1 0 1 0 1 0.5 0.5 0.5 0.5 0 1 0 1 1 0 0   0.5 0 1 0 0 0 0 1 0 0 0 0 0.5 0 0 0 0 0]';
%      commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=  1.04*[0.565861087060274,0.193049923668335,0.176931786291271,0.152740977276242,0.101193955253341,0.576591743163044,0.207466069124653,0.507804340338937,0.696242346236176,0.320127353026965,0.497128617019908,0.669077649563920,0.169563857192852,0.429695659661063,0.322685505318235,0.359311054819081,0.261786229145133,0.131699645061467,0.745947452148549,0.786419483476214,0.388801048842657,0.240812941949790,0.380924212734423,0.420558327552852,0.348175639364982,0.256441140146174,0.405118906419972,0.600437681996918,0.910183934411877,0.891980269105872,0.532381093580028,0.337062318003082,0.411418774718896,0.402444146892282,0.257489993955128,0.293487920001694,0.440371382980092,0.578188945180919,0.462005552384842,0.475494447615158,0.641994837612276,0.615971281734858,0.00142045454545455,0.0103490259740260,0.0227783748989106,0.0586231105204320,0]';
%      commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0.650260493363584,0.141409382586481,0.0974339450750833,0.177660539458347,0.142225567489546,0.779486964703964,0.201116178516408,0.354801198294488,0.678121510188560,0.423474805181214,0.294093897478708,0.549901442870565,0.225527392071256,0.645198801705513,0.184403716798478,0.543801483209511,0.214707045853664,0.197274700937560,0.755716694393913,0.793495550189876,0.195494083394702,0.390654380887508,0.313036383719025,0.561113309278973,0.262805277999808,0.345210440358061,0.566715106383085,0.542082914401515,0.993673793413377,0.921430432674872,0.433284893616915,0.457917085598485,0.430185700679990,0.412896658747031,0.263219163913574,0.288636484706723,0.705906102521292,0.456198516790489,0.498064245210285,0.501935754789716,0.505647635822480,0.791664267419709,0.0113153594771242,0.00710784313725490,0.0503705328285160,0.0301879084967320,0]';
% 
%      %% next one
% 
% cindex=cindex+1;
% 
% commonticks{cindex}.params.contract=genContract([],'NDAQ','','IND');
% 
% %% SETUP main
% 
% %copied over, even though they could be set independetly
% commonticks{cindex}.params.date=looperEngine.date;
% commonticks{cindex}.params.getdatainit=looperEngine.data.getdatainit;
% commonticks{cindex}.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
% commonticks{cindex}.params.updaterealtime=looperEngine.data.updaterealtime;
% commonticks{cindex}.params.graph=looperEngine.graph.show; 
% commonticks{cindex}.params.showlimit=looperEngine.graph.showlimit;
% commonticks{cindex}.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using
% commonticks{cindex}.params.scalepercent=1.1;
% commonticks{cindex}.params.lower_indicators={};%cell(1,2);
% commonticks{cindex}.params.upper_indicators={};
% %% SETUP sub
% 
% commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'
% commonticks{cindex}.params.StopPredictionEnabled=[1;1;1];
% commonticks{cindex}.params.DirectionPredictionEnabled=[1;1;1];
% commonticks{cindex}.params.thresh=default_threshold();
% 
% commonticks{cindex}.params.lenPreviousDayPivots=2;
% commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];
% 
% commonticks{cindex}.params.net.lower_indicators.inputs={'relativeQuote','deltaQuote5','deltaQuote10','deltaQuote21','deltaQuote50'};
% 
% 
% %commonticks{cindex}.params.net.lower_indicators.inputs={'sma10ret','sma21ret'};
% commonticks{cindex}.params.net.upper_indicators.inputs={};
% 
% 
% commonticks{cindex}.params.Strategies.Manual.Conditions.Entry={47,47};
% commonticks{cindex}.params.Strategies.Manual.Conditions.Exit={47,47};
% 
% 
%     % commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=[0.5 1 1 0 0 0 1 1 0.5 0 1 0 0 0 1 0 1 0 0.5 0   0.5 0.5 1 0 1 0 0 1 0.5 0   1 0 0 0 0 0 0 1 0 0 0.5 0 0 0 0 0 0]';
%    %  commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0   0 0 1 1 0 0 0 0.5 1 0 0 1 1 0 1 0 1 0.5 0.5 0.5 0.5 0 1 0 1 1 0 0   0.5 0 1 0 0 0 0 1 0 0 0 0 0.5 0 0 0 0 0]';
%      commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=  1.04*[0.565861087060274,0.193049923668335,0.176931786291271,0.152740977276242,0.101193955253341,0.576591743163044,0.207466069124653,0.507804340338937,0.696242346236176,0.320127353026965,0.497128617019908,0.669077649563920,0.169563857192852,0.429695659661063,0.322685505318235,0.359311054819081,0.261786229145133,0.131699645061467,0.745947452148549,0.786419483476214,0.388801048842657,0.240812941949790,0.380924212734423,0.420558327552852,0.348175639364982,0.256441140146174,0.405118906419972,0.600437681996918,0.910183934411877,0.891980269105872,0.532381093580028,0.337062318003082,0.411418774718896,0.402444146892282,0.257489993955128,0.293487920001694,0.440371382980092,0.578188945180919,0.462005552384842,0.475494447615158,0.641994837612276,0.615971281734858,0.00142045454545455,0.0103490259740260,0.0227783748989106,0.0586231105204320,0]';
%      commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0.650260493363584,0.141409382586481,0.0974339450750833,0.177660539458347,0.142225567489546,0.779486964703964,0.201116178516408,0.354801198294488,0.678121510188560,0.423474805181214,0.294093897478708,0.549901442870565,0.225527392071256,0.645198801705513,0.184403716798478,0.543801483209511,0.214707045853664,0.197274700937560,0.755716694393913,0.793495550189876,0.195494083394702,0.390654380887508,0.313036383719025,0.561113309278973,0.262805277999808,0.345210440358061,0.566715106383085,0.542082914401515,0.993673793413377,0.921430432674872,0.433284893616915,0.457917085598485,0.430185700679990,0.412896658747031,0.263219163913574,0.288636484706723,0.705906102521292,0.456198516790489,0.498064245210285,0.501935754789716,0.505647635822480,0.791664267419709,0.0113153594771242,0.00710784313725490,0.0503705328285160,0.0301879084967320,0]';
