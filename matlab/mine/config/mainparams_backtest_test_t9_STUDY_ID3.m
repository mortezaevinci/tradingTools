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



%tempsymbol.params.lower_indicators={{'ret_sma5_close'},{'dret_sma5_close'}};
%tempsymbol.params.lower_indicators={{'tradeStrategyBreakoutT8_signals'},{'tradeStrategyBreakoutT8_return'}};%{{'ShortTermPerformance'},{'BullBearCandleDiff'}};%={{'rsi5','MACD'},{'RelativeStrength'}};'tradeGroundTruth_signals'}

%tempsymbol.params.lower_indicators={{'net_yRemapped'},{'totalConditions'}};
tempsymbol.params.lower_indicators={};
tempsymbol.params.upper_indicators={'EMA9','EMA20'};%{'BBupper','BBlower'};
%tempsymbol.params.eval_indicators={{'tradeGroundTruth_signals','ShortTermPerformance'},{'uptotalConditions','dntotalConditions'}};
tempsymbol.params.eval_indicators={};
%% SETUP sub
tempsymbol.params.doBookOnly=looperEngine.process.bookOnly;
tempsymbol.params.isGraphInit=0;

%tempsymbol.params.todayDataPeriod='1d';
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
tempsymbol.params.thresh.ddsma5.min=1/100*.1;
tempsymbol.params.thresh.ret_sma5.min=1/100*.075;


tempsymbol.params.thresh.volumeBuzz.min=1.5;
tempsymbol.params.thresh.volumeBuzz.max=8;

tempsymbol.params.thresh.volumeBuzzBuySellDiff.min=.2;
tempsymbol.params.thresh.volumeBuzzBuySellDiff.max=8;


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

tempsymbol.params.thresh.futureGroundTruthHalfWindowSize_ShortTerm=10;
tempsymbol.params.thresh.futureGroundTruthHalfWindowSize_MidTerm=30;
tempsymbol.params.thresh.futureGroundTruthHalfWindowSize_LongTerm=60;

tempsymbol.params.thresh.zerocrossing=0.1;

tempsymbol.params.thresh.minNextLvlByPercent=1/100*5;
tempsymbol.params.thresh.maxLastLvlByPercent=1/100*2;
tempsymbol.params.thresh.maxTooCloseByPercent=1/100*0.75;

tempsymbol.params.lenPreviousDayPivots=30;
tempsymbol.params.localOptimaWidths=[5,9,20];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

tempsymbol.params.graphExtras{1}.commontick=[]; %if empty, calculate on itself?
tempsymbol.params.graphExtras{1}.practice=0; %1 being calculation of relative strength, this should go inside subindicators sometime later and become unified, where subindicators are all pre-done, but are only calculated if chosen

tempsymbol.params.thresh.ShortTermPerformance.min=0.1;


% tempsymbol.params.Strategies.Manual.Conditions.Entry{1,1}=[1 ,2 ,3 ,15,11,23,21,28,29]; %upward
% tempsymbol.params.Strategies.Manual.Conditions.Entry{1,2}=[20,4 ,5 ,10,16,24,22,27,30]; 
tempsymbol.params.Strategies.Manual.Conditions.Entry{1,1}=[1 ,2 ,3 ,15,23,21,28,29,42]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{1,2}=[20,4 ,5 ,10,24,22,27,30,41]; 
tempsymbol.params.Strategies.Manual.Conditions.Entry{2,1}=[1 ,31,8 ,9 ,10,11,21,29,33,42]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{2,2}=[20,32,14,15,16,9 ,22,30,34,41];
tempsymbol.params.Strategies.Manual.Conditions.Entry{3,1}=[1,6,17,8,19,10,11,29];  %upward
tempsymbol.params.Strategies.Manual.Conditions.Entry{3,2}=[20,12,18,14,19,15,16,30];

%  tempsymbol.params.Strategies.Manual.Conditions.Entry{1,1}=[1,2,3,48]; %upward
%  tempsymbol.params.Strategies.Manual.Conditions.Entry{1,2}=[4,5,20,48]; 

% tempsymbol.params.Strategies.Manual.Conditions.Entry{1,1}=[2]; %upward
% tempsymbol.params.Strategies.Manual.Conditions.Entry{1,2}=[4]; 
 %tempsymbol.params.Strategies.Manual.Conditions.Entry{2,1}=[1 ,31,8 ,9 ,10,11,21,29,33,42]; %upward
 %tempsymbol.params.Strategies.Manual.Conditions.Entry{2,2}=[20,32,14,15,16,9 ,22,30,34,41];

 tempsymbol.params.Strategies.DailyManual.Conditions.Entry{1,1}=[1,5,7,9]; %upward
 tempsymbol.params.Strategies.DailyManual.Conditions.Entry{1,2}=[2,6,8,10]; 
 

di=1;
% tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[35,37]; %upward
% tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[36,38]; 
% di=di+1;
%tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[8,31 ,30,33]; %upward
%tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[14,32,29,34]; 
%di=di+1;
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,1}=[3];%,43,45]; %upward
tempsymbol.params.Strategies.Manual.Conditions.Exit{di,2}=[5];%,44,46]; 

     
    % tempsymbol.params.Strategies.TotalConditions.Conditions.Entry{1}= [0.451653042511156,0.567028105957832,0.582790791964688,0.381291273668112,0.381842221474774,0.421090840476891,0.484627301725702,0.564251974261861,0.457562424970982,0.326009596501603,0.579434686851653,0.551165412832884,0.474362641487756,0.412109741100415,0.632128946248894,0.384112920792884,0.478129831100805,0.443145026674426,0.450103418704481,0.511763321464801,0.597080822978258,0.372148211585808,0.575055389378402,0.382309050867818,0.546676022571394,0.391078606907422,0.463537533071320,0.510509902911337,0.477843347228048,0.496368050495317,0.519656881907795,0.445146203783842,0.486371998026921,0.484341663864229,0.476129991288740,0.498877359495112,0.422411716688989,0.557344099155145,0.472319940804442,0.499812588532182,0.529421573502529,0.443129629339072,0,0,0.0748123260858804,0.182996363871382,0];
    % tempsymbol.params.Strategies.TotalConditions.Conditions.Entry{2}= [0.521680290822177,0.352971894042168,0.366098096924201,0.516486504109666,0.553713334080782,0.556686937300887,0.477594920496520,0.420192470182584,0.393548686140129,0.631768181276175,0.402787535370570,0.431056809389338,0.478970691845577,0.572334703344029,0.327871053751106,0.591442634762672,0.484092391121417,0.510188306658908,0.396563247962186,0.470458900757421,0.387363621466187,0.607851788414192,0.407166832843820,0.597690949132182,0.437768421873051,0.588921393092578,0.520906911373125,0.473934541533108,0.506601097216397,0.488076393949127,0.464787562536649,0.532631573993935,0.491405779750856,0.491213891691326,0.492758897600149,0.463344862727110,0.562032727755455,0.427100345289300,0.509902281417780,0.482409633690040,0.452800648719694,0.539092592883151,0,0,0.196298785025231,0.0658925250175071,0];


      tempsymbol.params.thresh.totalConditions.min=0;%1.1e-3;
      tempsymbol.params.thresh.totalConditions.max=100;%2.5e-3;
%    
%xxxmor, this would be laoded from indicator profile files

% tempsymbol.params.Strategies.TotalIndicators.Conditions.Entry{1}.mean =[0.514577243730776,0.518173039959021,0.498670052644958,5.17267109903626e-05,5.47125852975713e-05,4.48475564636060e-05,3.46390063156431e-05,NaN,NaN,NaN,0.00375311394899577,-0.000246218093883460,0.468491498876677,100.352814351666,99.8848383274214,NaN,56601.9834347154,78333.4622973925,77018.4681081427,75195.3030468279,4.55436472442833e-05,3.51260901594072e-05,6.56052014685841e-05,6.90757025344664e-05,-2.23766613190092,54.2763898477318,NaN,NaN,-0.0526520548705629,0.0760018902074487,0.0233498353368859,0.0496758627721555,-0.0246494404418143,0.0675550656620486,0.0429056252202343,0.0552303454411371,0.00965714446363966,0.0513620467937877,0.0610191912574273,0.0561906190255988,0.0408505998889216,0.176101667619839,0.216952267508760,0.0496758627721555,1.47013332187932e-06,1.31583103150274e-06,1.74332393812224e-06,1.57741899566974e-06,-7.80614015561139e-08,-1.71347398468374e-07,1.20214401065145e-07,1.73504614787378e-07,NaN,NaN,0.0318094568972448,0.0627368118598970,0.00932715903761512,0.0400044395963178,0.0275394267364159,0.0588970407905093,0.00373740730575473,0.0348404635778515,0.0209626873862932,0.0527914195763136,-0.00292457709835181,0.0284958883576360,0.00925540949258852,0.0412643219523417,-0.0160947853658240,0.0158098322703995,-0.00959430727576496,0.0232572512000872,-0.0389143352607209,-0.00659088093162857,0.00427003016082898,0.00383977106938775,0.00558975173186035,0.00516397601846628,0.0108467695109516,0.00994539228358343,0.0122517361359669,0.0115085512386818,0.0225540474046563,0.0214724899075553,0.0254219444034391,0.0241946073259183,0.0414037641730098,0.0394795606598098,0.0482414942983360,0.0465953205279464,NaN,0.276967762638721,0.00176180408738547,5916.05471905977,NaN,NaN,0.651855012952929,0,100.671130004416,0.0381792521294331,0.0705452047110302,0.133604901854282,0.0828319760638919,0.127081276109680,0.0730838203069117,0.127558426651634,0.140816774303310,0.0793355379185888,0.0366749062745946,0.0294924665064392,-0.000808712584594262,0,0.0197322057787174,99.7972130136918];    
% tempsymbol.params.Strategies.TotalIndicators.Conditions.Entry{1}.range=[7.02494184435692,9.89455533757913,11.7038248366339,8189.46726798120,9788.58208951674,11924.6224633288,26767.3277463792,NaN,NaN,NaN,133.136895659863,1173.49061706652,2.03121642444829,42.3577946242993,-4.67803790402130,NaN,-0.0356200747389952,-4.93045264717184e-05,-4.22435221487741e-05,-3.77277047925463e-05,7003.69297043732,7444.25708523005,7491.30886026745,8248.75809953169,-0.339827806547094,0.0566349429148793,NaN,NaN,7.79135488020305,13.5420961730002,4.94581382274020,7.24545786481234,14.5746739365839,12.8804718321030,6.83764998677817,8.93311836304121,25.5076338546692,17.1731649907588,10.2633225375308,12.8481265037019,-95.7074293158963,3.62404010583197,3.76666807382213,7.24545786481234,287549.500899519,279820.521306158,285403.099849640,269184.117492823,1850631.74576725,2643798.58806517,2835872.75484510,6306661.44034409,NaN,NaN,-6.86252139441595,-7.64243100416978,-6.66862125236003,-7.38631430482615,-6.34446131206793,-6.99895359810781,-6.18016550798785,-6.77174554810950,-5.93866833215835,-6.47798875407567,-5.76877886856708,-6.24997207779552,-5.34751907623937,-5.76414125400783,-5.18088042574425,-5.55041691132217,-4.88943302195760,-5.21360244855739,-4.65404759667750,-4.94405179483209,84.0423784298870,83.1249387640089,84.3744464560293,81.3875428322570,44.1133337634739,42.5161334491339,42.7517108062152,40.6253125729707,24.2227114951931,23.4532780835573,23.2226801167007,22.3308361212939,17.0057455044154,16.4048618846316,15.4057810818457,14.9526598170884,NaN,8.28021229567921,2.05503258508327,0.000587475376935765,NaN,NaN,9.46093245363000,1,-4.04910375024099,6.51067430535558,35.3504458371581,28.3125826532188,41.9265065219723,31.5710893741376,193.657478178149,22.9907483869781,54.0264551985675,25.3327064782255,72.3582748492564,100.398326411673,99.6891936518384,Inf,19.9859154929577,11.2291997147597]; 
% excludeindexes=[8,9,10,14,15,16,17,27,28,91,92,98,99,100,100:110,112,113,114];
% tempsymbol.params.indicatorsProfile=fixpconditionbased(tempsymbol.params.indicatorsProfile,excludeindexes);

     tempsymbol.params.thresh.totalIndicators.min=0; %bypass
     tempsymbol.params.thresh.totalIndicators.max=150000; %500

  %tempsymbol.params.Strategies.IndicatorsCount.Conditions.Entry{1}.above=[0.65,nan,nan,0,0,0,0,nan,nan,nan,0,0,nan,nan,nan,nan,nan,nan,nan,nan,0,0,0,0,nan,nan,nan,nan,nan,nan,0,0,nan,nan,0,0,nan,nan,nan,nan,nan,0,0,0,0,0,0,0,0,0,0,0,nan,nan,nan(1,20),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,nan,nan,0,nan,nan,nan,1,nan(size(98:107))];
  %tempsymbol.params.Strategies.IndicatorsCount.Conditions.Entry{1}.below=[0.35,nan,nan,0,0,0,0,nan,nan,nan,0,0,nan,nan,nan,nan,nan,nan,nan,nan,0,0,0,0,nan,nan,nan,nan,nan,nan,0,0,nan,nan,0,0,nan,nan,nan,nan,nan,0,0,0,0,0,0,0,0,0,0,0,nan,nan,nan(1,20),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,nan,nan,0,nan,nan,nan,1,nan(size(98:107))];
  %tempsymbol.params.thresh.IndicatorsCount.min=10; %40
  %  tempsymbol.params.thresh.IndicatorsCount.max=2000; %500


%'dcs2_fight','dcs2_open','dcs2_close','dcs2_total',...
%'dvs2_fight','dvs2_open','dvs2_close','dvs2_total',...
%'rvs2','avs2',...
%'dvs1_fight','dvs1_open','dvs1_close','dvs1_total',...
%'ret_sma5_close','ret_sma5_open','ret_sma5_low','ret_sma5_high'
%'ret_sma21_close','ret_sma10_close',...
%'tick2ret'
%'dcs_fight','dcs_total','dcs_open','dcs_close',...
% 'totalConditions'
%
 tempsymbol.params.net.lower_indicators.inputs={'rvs','avs','dcs_fight10','dcs_open10','dcs_close10','dcs_total10',...
     'relativeQuote','relativeQuote5','relativeQuote10','relativeQuote21','relativeQuote50',...
     'OnBalanceVolume10','OnBalanceVolume21',...
     'ChaikinVolatility','PercentileBollingerBW',...
     'PriceVolumeTrend',...
  'BullBearCandleDiff',...
  'VolumeBuzzRatio','SellVolumeBuzzRatio','BuyVolumeBuzzRatio',...
 'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent'};

% tempsymbol.params.net.lower_indicators.inputs={'rsi5','rsi10','rsi21','NVI','PVI','ADO','PriceVolumeTrend','OnBalanceVolume','ChaikinVolatility','dsma5','ddsma5',...
%  'dcs1_fight','dcs1_open','dcs1_close','dcs1_total',...
%  'rvs1','avs1',...
%  'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent'};

tempsymbol.params.net.upper_indicators.inputs={};%'nsma10','nsma21','nsma50'};
tempsymbol.params.net.eval_indicators.inputs={};
tempsymbol.params.net.lower_indicators.targets={};
tempsymbol.params.net.upper_indicators.targets={};
tempsymbol.params.net.eval_indicators.targets={'tradeGroundTruth_signals'};

