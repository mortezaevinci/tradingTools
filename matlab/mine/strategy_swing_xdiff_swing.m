function [thresh,entry,nextDayEntryCheck,priorientry]=strategy_swing_xdiff_comprehensinve(ttd,voldiff)

maxLength=3;
smaLength=10;
outlierMultiplier=2;
outlierMultiplierMax=1;

atrMultiplierTrail=linearMap(ttd.Close,0,30,1.2,1);
atrMultiplier=linearMap(ttd.Close,0,30,2,1.5);
atrMultiplierTarget=linearMap(ttd.Close,0,30,10,2);
thresh.stpLmtDiffPerc=linearMap(ttd.Close,0,30,1.05,1.005);
thresh.targetByPerc=linearMap(ttd.Close,-10,30,2,1.1);

aveDiffVol = movmean(voldiff,[smaLength 0]);

[atr,tr]=indicators_atr(ttd,smaLength);
aveClose= movmean(ttd.Close,[smaLength 0]);

sma10= movmean(ttd.Close,[10 0]);
sma50= movmean(ttd.Close,[50 0]);
sma100= movmean(ttd.Close,[100 0]);
sma200= movmean(ttd.Close,[200 0]);

thresh.matr=atrMultiplier.*atr;
thresh.tatr=atrMultiplierTarget.*atr;
thresh.TrailAmt=atrMultiplierTrail.*atr;
thresh.DiffVolMax = outlierMultiplierMax*movmax(voldiff,[smaLength 0]);
thresh.MaxHigh= movmax(ttd.High,[maxLength 0]);
thresh.DiffVolAve=aveDiffVol*outlierMultiplier;
thresh.Vol=max(thresh.DiffVolAve,thresh.DiffVolMax);
thresh.EntryStp=aveClose+thresh.matr;
thresh.EntryLmt=thresh.EntryStp.*thresh.stpLmtDiffPerc;
thresh.AbsVol=25000;
thresh.AbsAtrPerc=.25; %percentile

thresh.Target1=thresh.EntryStp+thresh.tatr;
thresh.Target2=thresh.EntryStp.*thresh.targetByPerc;
thresh.Target=min(thresh.Target1,thresh.Target2);

undermajorsma=ttd.Close<sma50 | ttd.Close<sma100 ...| ttd.Close<sma200...
    ;

%full pre-conditions
entryConditions= [thresh.matr./ttd.Close<thresh.AbsAtrPerc ...% & voldiff>thresh.AbsVol;
    , undermajorsma...
    , ttd.Close > sma10...
    , ttd.Close <= thresh.EntryStp ...
    , thresh.Vol >=thresh.AbsVol ...
    , thresh.EntryStp >= thresh.MaxHigh ...
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
nextDayEntryCheck=shiftpad(ttd.High,-1)>thresh.EntryStp ...
    & shiftpad(ttd.Low,-1) <thresh.EntryLmt ...
    & shiftpad(voldiff,-1) > thresh.Vol ...
    ;

% also superceding
% if entry exists already in hte earlier few entries,
% it sholud not trigger again
% not including volume, because we want to know price action didn't
% happen
happenedPriceEntry=shift(ttd.High,-1)>min(thresh.EntryStp,thresh.MaxHigh) ...    & shift(ttd.Low,-1) <thresh.EntryLmt ...
    ;

priorientry=movmax(shiftpad(happenedPriceEntry,1),[5,0]);
try
    
fprintf("Conds:\t%s e(%d)\t Priori:\t%s p(%d) o(%d)", ...
    num2str(entryConditions(end,:)), entry(end),...
    num2str(happenedPriceEntry(end-5:end)'),priorientry(end)==0,...
    entry(end) & priorientry(end)==0);
catch
    
end

end