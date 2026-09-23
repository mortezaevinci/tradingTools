function [thresh,entry,nextDayEntryCheck,priorientry]=strategy_swing_xdiff_aggresivevol(ttd,voldiff)
maxLength=3;
smaLength=10;
outlierMultiplier=1;
outlierMultiplierMax=1/8; %note we are doing both pre and post market here
atrlength=60;
atrMultiplierTrail=linearMap(ttd.Close,0,30,1.2,1);
atrMultiplier=linearMap(ttd.Close,0,30,2,1.5);
atrMultiplierTarget=linearMap(ttd.Close,0,30,10,2);
thresh.stpLmtDiffPerc=linearMap(ttd.Close,0,30,1.08,1.02);
thresh.stpDiffAgainstMaxPerc=1;%linearMap(ttd.Close,0,30,1.02,1.005);
thresh.targetByPerc=linearMap(ttd.Close,-10,30,2,1.1);

aveDiffVol = movmean(voldiff,[smaLength 0]);

[atr,tr]=indicators_atr(ttd,atrlength);
aveClose= movmean(ttd.Close,[smaLength 0]);

sma6= movmean(ttd.Close,[6 0]);
sma10= movmean(ttd.Close,[10 0]);
sma21= movmean(ttd.Close,[21 0]);
sma50= movmean(ttd.Close,[50 0]);
sma150= movmean(ttd.Close,[150 0]);
sma200= movmean(ttd.Close,[200 0]);

thresh.matr=atrMultiplier.*atr;
thresh.tatr=atrMultiplierTarget.*atr;
thresh.TrailAmt=atrMultiplierTrail.*atr;
thresh.DiffVolMax = outlierMultiplierMax*movmax(voldiff,[smaLength 0]);
thresh.MaxHigh= movmax(ttd.High,[maxLength 0]);
thresh.MaxHighMonth= movmax(ttd.High,[30 0]);
thresh.DiffVolAve=aveDiffVol*outlierMultiplier;
thresh.Vol=min(thresh.DiffVolAve,thresh.DiffVolMax);
thresh.EntryStp=thresh.MaxHigh.*thresh.stpDiffAgainstMaxPerc;%aveClose+thresh.matr;
thresh.EntryLmt=thresh.EntryStp.*thresh.stpLmtDiffPerc;
thresh.AbsVol= max(10000,thresh.Vol/100);

thresh.Vol=max(thresh.Vol,thresh.AbsVol);

thresh.VolRate=max(thresh.Vol/20,5000);

thresh.AbsAtrPerc=.5; %percentile

thresh.Target1=thresh.EntryStp+thresh.tatr;
thresh.Target2=thresh.EntryStp.*thresh.targetByPerc;
thresh.Target=min(thresh.Target1,thresh.Target2);

undermajorsma=(ttd.Close<sma50  | ttd.Close<sma150 | ttd.Close<sma200 | ttd.Close<thresh.MaxHighMonth/4 ...
    );
minorsmareversal= ((ttd.Close >= sma6 & ttd.Close <sma21) | (abs(sma21-sma6)<thresh.matr ));
acceptablemajorsma=(sma150>sma200 | sma50>sma200 | abs(sma50-sma200)<thresh.matr);

%full pre-conditions
entryConditions= [ ttd.Close <= thresh.EntryStp ..., undermajorsma ...
    , ttd.Close<25 ...
    , minorsmareversal ...
    , ttd.Close + 2* thresh.matr >= thresh.EntryStp ...
    ];

entry=(sum(entryConditions,2)==size(entryConditions,2));

%secondary for final intraday check
% we want the thing to be actually buyable
% this is still WRONG because we don't know if
% the low happened after or before trigger
% order would be valid if low happened before trigger
% until we look at intraday (next step)
% for now, this is to filter out obvious cases)
% the same to some degree is true for High, we sure know high happens
% at some point, but not sure if good for premarket
nextDayEntryCheck=shiftpad(ttd.High,-1)>thresh.MaxHigh ...
    & shiftpad(ttd.Low,-1) <thresh.EntryLmt ...
    & shiftpad(voldiff,-1) > thresh.Vol ...
    ;

% also superceding
% if entry exists already in hte earlier few entries,
% it sholud not trigger again
% not including volume, because we want to know price action didn't
% happen

happenedEntryConditions= [shift(ttd.High,-1) >= thresh.EntryStp ...
    , shift(voldiff,-1) >=thresh.Vol ...
    ];

happenedEntry=(sum(happenedEntryConditions,2)==size(happenedEntryConditions,2));
plength=5;
priorientrysum=movsum(shiftpad(happenedEntry,1),[plength,0]);
priorientry=priorientrysum>1;
try
    
fprintf("Conds:\t%s e(%d)\t Priori:\t%s p(%d) o(%d)", ...
    num2str(entryConditions(end,:)), entry(end),...
    num2str(happenedEntry(end-plength+1:end)'),priorientry(end)==0,...
    entry(end) & priorientry(end)==0);
catch
    
end
end