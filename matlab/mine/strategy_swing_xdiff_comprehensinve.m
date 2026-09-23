function [thresh,entry,nextDayEntryCheck,priorientry]=strategy_swing_xdiff_comprehensinve(ttd,voldiff)

maxLength=5;
smaLength=10;
outlierMultiplier=1.5;
outlierMultiplierMax=0.5;

atrMultiplierTrail=linearMap(ttd.Close,0,30,1.5,1.2);
atrMultiplier=linearMap(ttd.Close,0,30,1.5,1.2);
atrMultiplierTarget=linearMap(ttd.Close,0,30,10,2);
thresh.stpLmtDiffPerc=linearMap(ttd.Close,0,30,1.05,1.005);
thresh.targetByPerc=linearMap(ttd.Close,-10,30,2,1.1);

aveDiffVol = movmean(voldiff,[smaLength 0]);

[atr,tr]=indicators_atr(ttd,smaLength);
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
thresh.Vol=max(thresh.DiffVolAve,thresh.DiffVolMax);
thresh.EntryStp=min(aveClose+thresh.matr,thresh.MaxHigh);
thresh.EntryLmt=thresh.EntryStp.*thresh.stpLmtDiffPerc;
thresh.AbsVol=max(25000,thresh.Vol/20);
thresh.AbsAtrPerc=.25; %percentile
thresh.VolRate=max(thresh.Vol/20,15000); %essentially bypassing by rate

thresh.Target1=thresh.EntryStp+thresh.tatr;
thresh.Target2=thresh.EntryStp.*thresh.targetByPerc;
thresh.Target=min(thresh.Target1,thresh.Target2);

undermajorsma=(ttd.Close<sma50  | ttd.Close<sma150 | ttd.Close<sma200 | ttd.Close<thresh.MaxHighMonth/4 ...
    );
minorsmareversal= ttd.Close >= sma6 & abs(sma21-sma6)<atr;
sma6reversal= shiftpad(ttd.Close,1) <sma6 | shiftpad(ttd.Close,2)<sma6;
acceptablemajorsma=(sma150>sma200 | sma50>sma200 | abs(sma50-sma200)<thresh.matr);

%full pre-conditions
entryConditions= [thresh.matr./ttd.Close<thresh.AbsAtrPerc ...% & voldiff>thresh.AbsVol;
    , ttd.Close<25 ...
    , minorsmareversal ...
    , acceptablemajorsma ...
    , sma6reversal ...
    , ttd.Close <= thresh.EntryStp ...
    , thresh.Vol >=thresh.AbsVol ...
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