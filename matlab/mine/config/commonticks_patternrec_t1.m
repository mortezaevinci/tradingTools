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

commonticks{cindex}.params.net.lower_indicators.inputs={'tick2ret','sma10ret','sma21ret'};
commonticks{cindex}.params.net.upper_indicators.inputs={};%'nsma10'};%,'nsma21','nsma50'};

commonticks{cindex}.params.Strategies.Manual.Conditions.Entry={47,47};
commonticks{cindex}.params.Strategies.Manual.Conditions.Exit={47,47};

   commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=[0.5 1 1 0 0 0 1 1 0.5 0 1 0 0 0 1 0 1 0 0.5 0   0.5 0.5 1 0 1 0 0 1 0.5 0   1 0 0 0 0 0 0 1 0 0 0.5 0 0 0 0 0 0]';
     commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0   0 0 1 1 0 0 0 0.5 1 0 0 1 1 0 1 0 1 0.5 0.5 0.5 0.5 0 1 0 1 1 0 0   0.5 0 1 0 0 0 0 1 0 0 0 0 0.5 0 0 0 0 0]';

% %% next one
% cindex=cindex+1;
% 
% commonticks{cindex}.params.contract=genContract([],'$VOLD');
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
%commonticks{cindex}.params.net.lower_indicators.inputs={'rsi5','rsi21','ddsma5','tick2ret','sma10ret','sma50ret','BBlowerret','BBupperret'};
%commonticks{cindex}.params.net.upper_indicators.inputs={};
% 
%% next one
% 
% cindex=cindex+1;
% 
% commonticks{cindex}.params.contract=genContract([],'$TICK');

%% SETUP main

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
%commonticks{cindex}.params.net.lower_indicators.inputs={'rsi5','rsi21','ddsma5','tick2ret','sma10ret','sma50ret','BBlowerret','BBupperret'};
%commonticks{cindex}.params.net.upper_indicators.inputs={};

%% next one

cindex=cindex+1;

commonticks{cindex}.params.contract=genContract([],'GLD');

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

commonticks{cindex}.params.net.lower_indicators.inputs={'sma10ret','sma21ret'};
commonticks{cindex}.params.net.upper_indicators.inputs={};


commonticks{cindex}.params.Strategies.Manual.Conditions.Entry={47,47};
commonticks{cindex}.params.Strategies.Manual.Conditions.Exit={47,47};


   commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{1}=[0.5 1 1 0 0 0 1 1 0.5 0 1 0 0 0 1 0 1 0 0.5 0   0.5 0.5 1 0 1 0 0 1 0.5 0   1 0 0 0 0 0 0 1 0 0 0.5 0 0 0 0 0 0]';
   commonticks{cindex}.params.Strategies.TotalConditions.Conditions.Entry{2}=[0   0 0 1 1 0 0 0 0.5 1 0 0 1 1 0 1 0 1 0.5 0.5 0.5 0.5 0 1 0 1 1 0 0   0.5 0 1 0 0 0 0 1 0 0 0 0 0.5 0 0 0 0 0]';
