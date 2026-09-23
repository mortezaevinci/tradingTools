%% SETUP main

tempsymbol.params.symbol='AAPL'; %placeholder for yahoo crumb
%copied over, even though they could be set independetly
tempsymbol.params.date=looperParams.date;
tempsymbol.params.getdatainit=looperParams.getdatainit;
tempsymbol.params.getalldatainrealtime=looperParams.getalldatainrealtime;
tempsymbol.params.updaterealtime=looperParams.updaterealtime;
tempsymbol.params.graph=looperParams.graph.show; 
tempsymbol.params.showlimit=looperParams.graph.showlimit;
tempsymbol.params.processlimit=looperParams.processlimit;  %this may malfunction in some studies, try not using
tempsymbol.params.scalepercent=1.1;
%tempsymbol.params.subIndicators={19};%cell(1,2);
tempsymbol.params.lower_ndicators={};
tempsymbol.params.upper_ndicators={};
%% SETUP sub

tempsymbol.params.enabled=[1;1;1];
tempsymbol.params.thresh.dcs.fight.min=1;
tempsymbol.params.thresh.avs.min=.5;
tempsymbol.params.thresh.rvs.min=0.2; 
tempsymbol.params.thresh.dvs.open.min=0;0.2;
tempsymbol.params.thresh.dvs.close.min=0;0.3;
tempsymbol.params.thresh.dvs.total.min=0;0.5;0.5;
tempsymbol.params.thresh.dsma5.min=0.05;
tempsymbol.params.thresh.ddsma5.min=0;
tempsymbol.params.thresh.minNextLvlByPercent=0.05;

tempsymbol.params.lenPreviousDayPivots=1;
tempsymbol.params.localOptimaWidths=[10,25]%by fft of WMT, [8,18,36,66];by fft of SPY [3;6;10;25], [9,21];