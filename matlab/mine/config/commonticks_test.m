commonticks{1}.params.contract=genContract([],'SPY');

%% SETUP main

%copied over, even though they could be set independetly
commonticks{1}.params.date=looperEngine.date;
commonticks{1}.params.getdatainit=looperEngine.data.getdatainit;
commonticks{1}.params.getalldatainrealtime=looperEngine.data.getalldatainrealtime;
commonticks{1}.params.updaterealtime=looperEngine.data.updaterealtime;
commonticks{1}.params.graph=looperEngine.graph.show; 
commonticks{1}.params.showlimit=looperEngine.graph.showlimit;
commonticks{1}.params.processlimit=looperEngine.process.limit;  %this may malfunction in some studies, try not using
commonticks{1}.params.scalepercent=1.1;
commonticks{1}.params.lower_indicators={};%cell(1,2);
commonticks{1}.params.upper_indicators={};
%% SETUP sub

commonticks{1}.params.todayDataPeriod='1d';% '1d'; '5d'

commonticks{1}.params.DirectionPredictionEnabled=[1;1;1];
commonticks{1}.params.thresh.dcs.fight.min=1;
commonticks{1}.params.thresh.avs.min=.5;
commonticks{1}.params.thresh.rvs.min=0.2; 
commonticks{1}.params.thresh.dvs.open.min=0;0.2;
commonticks{1}.params.thresh.dvs.close.min=0;0.3;
commonticks{1}.params.thresh.dvs.total.min=0;0.5;0.5;
commonticks{1}.params.thresh.dsma5.min=1/100*0.05;
commonticks{1}.params.thresh.ddsma5.min=1/100*0;
commonticks{1}.params.thresh.minNextLvlByPercent=1/100*0.05;

commonticks{1}.params.lenPreviousDayPivots=2;
commonticks{1}.params.localOptimaWidths=[10,21]%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];