cindex=1;

commonticks{cindex}.params.symbol='SPY';

%% SETUP main

%copied over, even though they could be set independetly
commonticks{cindex}.params.date=looperParams.date;
commonticks{cindex}.params.getdatainit=looperParams.getdatainit;
commonticks{cindex}.params.getalldatainrealtime=looperParams.getalldatainrealtime;
commonticks{cindex}.params.updaterealtime=looperParams.updaterealtime;
commonticks{cindex}.params.graph=looperParams.graph.show; 
commonticks{cindex}.params.showlimit=looperParams.graph.showlimit;
commonticks{cindex}.params.processlimit=looperParams.processlimit;  %this may malfunction in some studies, try not using
commonticks{cindex}.params.scalepercent=1.1;
commonticks{cindex}.params.lower_indicators={};%cell(1,2);
commonticks{cindex}.params.upper_indicators={};
%% SETUP sub

commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'

commonticks{cindex}.params.enabled=[1;1;1];
commonticks{cindex}.params.thresh=default_threshold();

commonticks{cindex}.params.lenPreviousDayPivots=1;
commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];

commonticks{cindex}.params.net.lower_indicators.inputs={'rsi7','rsi14','rsi21','dsma5','ddsma5','tick2ret'};
commonticks{cindex}.params.net.upper_indicators.inputs={};%'NSMA7'};%,'NSMA14','NSMA21'};

% %% next one
% cindex=cindex+1;
% 
% commonticks{cindex}.params.symbol='$VOLD';
% 
% %% SETUP main
% 
% %copied over, even though they could be set independetly
% commonticks{cindex}.params.date=looperParams.date;
% commonticks{cindex}.params.getdatainit=looperParams.getdatainit;
% commonticks{cindex}.params.getalldatainrealtime=looperParams.getalldatainrealtime;
% commonticks{cindex}.params.updaterealtime=looperParams.updaterealtime;
% commonticks{cindex}.params.graph=looperParams.graph.show; 
% commonticks{cindex}.params.showlimit=looperParams.graph.showlimit;
% commonticks{cindex}.params.processlimit=looperParams.processlimit;  %this may malfunction in some studies, try not using
% commonticks{cindex}.params.scalepercent=1.1;
% commonticks{cindex}.params.lower_indicators={};%cell(1,2);
% commonticks{cindex}.params.upper_indicators={};
% %% SETUP sub
% 
% commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'
% 
% commonticks{cindex}.params.enabled=[1;1;1];
% commonticks{cindex}.params.thresh=default_threshold();
% 
% commonticks{cindex}.params.lenPreviousDayPivots=1;
% commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];
% commonticks{cindex}.params.net.lower_indicators.inputs={};
% commonticks{cindex}.params.net.upper_indicators.inputs={};%'NSMA7','NSMA14','NSMA21'};
% 
%% next one
cindex=cindex+1;

commonticks{cindex}.params.symbol='$TICK';

%% SETUP main

%copied over, even though they could be set independetly
commonticks{cindex}.params.date=looperParams.date;
commonticks{cindex}.params.getdatainit=looperParams.getdatainit;
commonticks{cindex}.params.getalldatainrealtime=looperParams.getalldatainrealtime;
commonticks{cindex}.params.updaterealtime=looperParams.updaterealtime;
commonticks{cindex}.params.graph=looperParams.graph.show; 
commonticks{cindex}.params.showlimit=looperParams.graph.showlimit;
commonticks{cindex}.params.processlimit=looperParams.processlimit;  %this may malfunction in some studies, try not using
commonticks{cindex}.params.scalepercent=1.1;
commonticks{cindex}.params.lower_indicators={};%cell(1,2);
commonticks{cindex}.params.upper_indicators={};
%% SETUP sub

commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'

commonticks{cindex}.params.enabled=[1;1;1];
commonticks{cindex}.params.thresh=default_threshold();

commonticks{cindex}.params.lenPreviousDayPivots=1;
commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];
commonticks{cindex}.params.net.lower_indicators.inputs={};
commonticks{cindex}.params.net.upper_indicators.inputs={'SMA5'};%'NSMA7','NSMA14','NSMA21'};

%% next one
% cindex=cindex+1;
% 
% commonticks{cindex}.params.symbol='GLD';
% 
% %% SETUP main
% 
% %copied over, even though they could be set independetly
% commonticks{cindex}.params.date=looperParams.date;
% commonticks{cindex}.params.getdatainit=looperParams.getdatainit;
% commonticks{cindex}.params.getalldatainrealtime=looperParams.getalldatainrealtime;
% commonticks{cindex}.params.updaterealtime=looperParams.updaterealtime;
% commonticks{cindex}.params.graph=looperParams.graph.show; 
% commonticks{cindex}.params.showlimit=looperParams.graph.showlimit;
% commonticks{cindex}.params.processlimit=looperParams.processlimit;  %this may malfunction in some studies, try not using
% commonticks{cindex}.params.scalepercent=1.1;
% commonticks{cindex}.params.lower_indicators={};%cell(1,2);
% commonticks{cindex}.params.upper_indicators={};
% %% SETUP sub
% 
% commonticks{cindex}.params.todayDataPeriod='1d';% '1d'; '5d'
% 
% commonticks{cindex}.params.enabled=[1;1;1];
% commonticks{cindex}.params.thresh=default_threshold();
% 
% commonticks{cindex}.params.lenPreviousDayPivots=1;
% commonticks{cindex}.params.localOptimaWidths=[10,25];%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];
% 
% commonticks{cindex}.params.net.lower_indicators.inputs={'rsi7','rsi14','rsi21'};
% commonticks{cindex}.params.net.upper_indicators.inputs={'NSMA7','NSMA14','NSMA21'};
