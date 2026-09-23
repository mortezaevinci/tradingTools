function [maintick,debug]=strategy_breakout_t11(looperEngine,maintick,commonticks)
debug=struct();
try

global showbackdateonce;

if (looperEngine.process.type==0)
timetablePrimary=maintick.params.TimeTables.Minute;
timetableSecondary=maintick.params.TimeTables.Day;
timetableAuxilary=maintick.params.TimeTables.Month;
preps.alpha=.60;
preps.alphalong=0.60;
end
if (looperEngine.process.type==1)
timetablePrimary=maintick.params.TimeTables.Day(end-90:end,:);
timetableSecondary=maintick.params.TimeTables.Month;
timetableAuxilary=maintick.params.TimeTables.Month;
preps.alpha=0.25;
preps.alphalong=0.60;
end

if (isempty(timetablePrimary))
    return;
end

maintick.calculations.started=1;

%% process limit
try
% Set process limit after ORB
if (looperEngine.process.limit>0)
proclimit_=min(looperEngine.process.limit,numel(timetablePrimary.Date)-1);
timetablePrimary=timetablePrimary(end-proclimit_:end,:);

end
tms=size(timetablePrimary,1);
catch exception
   dumpReport('error.log', exception)
end
 %%;ticsprep=toc
 
  %%;tic;
%% pivots
[levels(3),mc,mo]=indicators_levels_mlh(timetableAuxilary,datestr(timetablePrimary.Date(end)),preps);



%% xxxmor, TDA daily data show a different time stamp, so double check that these act the same way
levels(1)=indicators_levels_ma(maintick.params.TimeTables.Day,preps);

%% extended dailyhighloq ould be combined
levels(2)=indicators_levels_dlh(maintick.params.TimeTables.Day,timetablePrimary.Date(end),maintick.params.lenPreviousDayPivots,preps);
 %%;tic_dlh_mlh_sma=toc
 %%;tic
%% orb levels
%% special level that is invalid to use in studies. commented out, as it makes studies invalid for now
%levels_orb=indicators_levels_orb(timetablePrimary,preps);
%% pre-market levels
levels(4)=indicators_levels_adh(maintick.params.TimeTables.MinuteFull,preps);

 %%;ticorb=toc

%% continue LEVELS
 %%;tic
try
   
%sve
levels(5) = indicators_levels_pp(@SVEPivots,mc,levels(3).values(2),levels(3).values(1),'-',2,0x03,'MS',preps.alphalong);
levels(6) = indicators_levels_pp(@SVEPivots,maintick.calculations.previousClose,levels(2).values(2),levels(2).values(1),'-',1,0x04,'DS',preps.alpha);
%woodies
levels(7) = indicators_levels_pp(@WoodiesPivots,mc,levels(3).values(2),levels(3).values(1),'--',2,0x05,'MW',preps.alphalong);
levels(8) = indicators_levels_pp(@WoodiesPivots,maintick.calculations.previousClose,levels(2).values(2),levels(2).values(1),'--',1,0x06,'DW',preps.alpha);
%fibonacci
levels(9) = indicators_levels_pp(@FibonacciPivots,mc,levels(3).values(2),levels(3).values(1),'-',2,0x0D,'MF',preps.alphalong);
levels(10) = indicators_levels_pp(@FibonacciPivots,maintick.calculations.previousClose,levels(2).values(2),levels(2).values(1),'-',1,0x0E,'DF',preps.alpha);

levels(11)=indicators_levels_rnd(timetablePrimary,preps);

catch exception
   dumpReport('error.log', exception) 
end
 %%;tictradlevels=toc
 
 minmin=min(timetablePrimary.Low)*0.85;
maxmax=max(timetablePrimary.High)*1.15;
 viewingScale=[minmin,maxmax];
maintick.calculations.levels = indicators_levels_all(levels,viewingScale);
 %%;tic

%% find crossings
try

lxup=zeros(tms,size(maintick.calculations.levels.values,2));
lxdn=zeros(tms,size(maintick.calculations.levels.values,2));
for i=find(maintick.calculations.levels.power>0)
    [lxup(:,i),lxdn(:,i)]=crossPivot2(timetablePrimary,maintick.calculations.levels.values(i));
end

[lxups,lxupi]=max(lxup,[],2); %look into minutesXlevels size array, and fins the largest level has is passed on that minute
[lxdns,lxdni]=max(lxdn,[],2);

%power of levels to cross.. not used for now
lxupp=maintick.calculations.levels.power(lxupi)';
lxdnp=maintick.calculations.levels.power(lxdni)';

% direction of crossing
lxupd=maintick.calculations.levels.direction(lxupi)';
lxdnd=maintick.calculations.levels.direction(lxdni)';

lxupd=lxupd>-1;
lxdnd=lxdnd<1;

%remove the ones that are not supposed to cross in that direction
lxups=lxups.*lxupd; %location of breakout happening
lxdns=lxdns.*lxdnd;


if (looperEngine.process.useBookLevels>0)
 if (isfield(maintick.params,'marketdata'))
   if (~isempty(maintick.params.marketdata))  

    
    bl=maintick.params.marketdata.BookLevels;
    bls=size(bl,1);
    if (bls>0)
    if (bls<tms)
       bl(bls:tms,:)=0;
    end
    
    if (bls>tms)
       bl=bl(1:tms,:); 
    end
    
    [lxupb1,lxdnb1]=crossPivot(timetablePrimary,shiftpad(bl(:,1),looperEngine.process.shiftBookLevelCrossing)');
    [lxupb2,lxdnb2]=crossPivot(timetablePrimary,shiftpad(bl(:,2), looperEngine.process.shiftBookLevelCrossing)');
    end
    
    lxups=max([lxups,lxupb1,lxupb2],[],2);
    lxdns=max([lxdns,lxdnb1,lxdnb2],[],2);
   end
end
end

catch exception
   dumpReport('error.log', exception) 
end
 %%;ticscrossing=toc



%% INDICATORS
  %%;tic
try
   
tempmainticks{1}.maintick.params.TimeTables.Minute=timetablePrimary;
tempmainticks{1}.maintick.params.TimeTables.Day=timetableSecondary;

% tempmainticks{2}.maintick.params.TimeTables.Minute=gen2mfrom1m(timetablePrimary,1);
% tempmainticks{2}.maintick.params.TimeTables.Day=timetableSecondary;
% 
% tempmainticks{3}.maintick.params.TimeTables.Minute=gen2mfrom1m(timetablePrimary,5);
% tempmainticks{3}.maintick.params.TimeTables.Day=timetableSecondary;

[mindis,mindislvl]=getmindiscomplex(timetablePrimary,maintick.calculations.levels.values);

%%local optima

loWidths=maintick.params.localOptimaWidths;%[9,21];%,21,35,50];
loColors={[0.5 0.5 0.5 preps.alpha],[0 0 1 preps.alpha],[0 .75 1 preps.alpha],[0 .75 1 preps.alpha],[0 .75 1 preps.alpha]};
lostyle={':',':',':',':',':'};

tradeGroundTruth_signals_=zeros(size(timetablePrimary.Close));

for i=1:numel(loWidths)
maintick.calculations.localOptimaProfile{i}=localOptimaProfiler(loWidths(i),timetablePrimary,1);
maintick.calculations.localOptimaProfile{i}.color=loColors{i};
maintick.calculations.localOptimaProfile{i}.style=lostyle{i};

%tradeGroundTruth_signals_=tradeGroundTruth_signals_+maintick.calculations.localOptimaProfile{i}.tradeGroundTruth_signals;


end

% [~,mind]=max(loWidths);
% 
% sortedIndices=sort(maintick.calculations.localOptimaProfile{mind}.indices);
% sortedIndices=[1;sortedIndices;numel(timetablePrimary.Date)];
% overpurchase=0;
% for bb=1:numel(sortedIndices)-1
%     oprice=timetablePrimary.Open(sortedIndices(bb));
%    dprice=timetablePrimary.Close(sortedIndices(bb+1))-oprice;
%    %for now no threshold
%    if (dprice>0 && overpurchase<1)
%        tradeGroundTruth_signals_(sortedIndices(bb))=1;
%        overpurchase=overpurchase+1;
%    end
%       if (dprice<0 && overpurchase>-1)
%        tradeGroundTruth_signals_(sortedIndices(bb))=-1;
%        overpurchase=overpurchase-1;
%    end
% end



catch exception
   dumpReport('error.log', exception) 
end
 %%;ticslocaloptima=toc
 %%;tic

%% enter conditions preparation


try
     %%;tic
absolutevolumethresh=mean(timetableSecondary.Volume(end-12:end))/390;

for i=1:numel(tempmainticks)
[maintick.calculations.indicators{i}.lower,maintick.calculations.indicators{i}.upper,maintick.calculations.indicators{i}.eval]=indicators_t9(tempmainticks{i}.maintick.params.TimeTables.Minute,tempmainticks{i}.maintick.params.TimeTables.Day);
[maintick.calculations.indicators{i}.lower.rvs,maintick.calculations.indicators{i}.lower.avs]=largevolume(tempmainticks{i}.maintick.params.TimeTables.Minute,1*ones(size(tempmainticks{i}.maintick.params.TimeTables.Minute.Volume)),absolutevolumethresh); 
maintick.calculations.bounce{i}=largebounce(tempmainticks{i}.maintick.params.TimeTables.Minute,mindis,maintick.calculations.indicators{i}.lower.dvs_fight);
end
 %%;ticsenterprep=toc
%%


%% performance eval

%% short term
 %%;tic
noncausalmean=movmean(timetablePrimary.Close,[maintick.params.thresh.futureGroundTruthHalfWindowSize_ShortTerm maintick.params.thresh.futureGroundTruthHalfWindowSize_ShortTerm]);

futuremax=movmax(noncausalmean,[0 2*maintick.params.thresh.futureGroundTruthHalfWindowSize_ShortTerm]);
futuremin=movmin(noncausalmean,[0 2*maintick.params.thresh.futureGroundTruthHalfWindowSize_ShortTerm]);

percentilefuturechangemax=(-noncausalmean+futuremax)./maintick.calculations.atr(end);
percentilefuturechangemin=(-noncausalmean+futuremin)./maintick.calculations.atr(end);

maintick.calculations.indicators{1}.eval.ShortTermPerformance=percentilefuturechangemax;
maintick.calculations.indicators{1}.eval.ShortTermPerformance(percentilefuturechangemin<0)=percentilefuturechangemin(percentilefuturechangemin<0);

futureonlyhigher=percentilefuturechangemax>=maintick.params.thresh.ShortTermPerformance.min;
futureonlylower=percentilefuturechangemin<=-maintick.params.thresh.ShortTermPerformance.min;

tradeGroundTruth_signals_(futureonlyhigher)=1;
tradeGroundTruth_signals_(futureonlylower)=-1;
 %%;ticgtshort=toc
%% long term
 %%;tic
noncausalmean=movmean(timetablePrimary.Close,[maintick.params.thresh.futureGroundTruthHalfWindowSize_LongTerm maintick.params.thresh.futureGroundTruthHalfWindowSize_LongTerm]);

futuremax=movmax(noncausalmean,[0 2*maintick.params.thresh.futureGroundTruthHalfWindowSize_LongTerm]);
futuremin=movmin(noncausalmean,[0 2*maintick.params.thresh.futureGroundTruthHalfWindowSize_LongTerm]);

percentilefuturechangemax=(-noncausalmean+futuremax)./maintick.calculations.atr(end);
percentilefuturechangemin=(-noncausalmean+futuremin)./maintick.calculations.atr(end);

maintick.calculations.indicators{1}.eval.LongTermPerformance=percentilefuturechangemax;
maintick.calculations.indicators{1}.eval.LongTermPerformance(percentilefuturechangemin<0)=percentilefuturechangemin(percentilefuturechangemin<0);
 %%;ticgtlong=toc
%% mid term
 %%;tic
noncausalmean=movmean(timetablePrimary.Close,[maintick.params.thresh.futureGroundTruthHalfWindowSize_MidTerm maintick.params.thresh.futureGroundTruthHalfWindowSize_MidTerm]);

futuremax=movmax(noncausalmean,[0 2*maintick.params.thresh.futureGroundTruthHalfWindowSize_MidTerm]);
futuremin=movmin(noncausalmean,[0 2*maintick.params.thresh.futureGroundTruthHalfWindowSize_MidTerm]);

percentilefuturechangemax=(-noncausalmean+futuremax)./maintick.calculations.atr(end);
percentilefuturechangemin=(-noncausalmean+futuremin)./maintick.calculations.atr(end);

maintick.calculations.indicators{1}.eval.MidTermPerformance=percentilefuturechangemax;
maintick.calculations.indicators{1}.eval.MidTermPerformance(percentilefuturechangemin<0)=percentilefuturechangemin(percentilefuturechangemin<0);

 %%;ticgtmed=toc

%% buy/sell performance
 %%;tic
maintick.calculations.indicators{1}.eval.BestBuyPerformance=cummax(timetablePrimary.Close,1);
maintick.calculations.indicators{1}.eval.BestSellPerformance=cummin(timetablePrimary.Close,1);
 %%;ticbuysellperf=toc

%% other indicators
 %%;tic
[BullCandles, BearCandles ,~] = candlesticksCount(timetablePrimary);
maintick.calculations.indicators{1}.lower.BullBearCandleDiff=BullCandles-BearCandles;

BullishCandles=maintick.calculations.indicators{1}.lower.BullBearCandleDiff>0;
BearishCandles=maintick.calculations.indicators{1}.lower.BullBearCandleDiff<0;
 %%;ticotherindicators=toc

catch exception
   dumpReport('error.log', exception) 
    
end

 %%;tic
%% process volume buzz
try
 if (isfield(maintick.params,'PriceActionProfile'))
    %genrate minute indices
    minuteindex=ceil(1+minutes(timetablePrimary.Date-timetablePrimary.Date(1)));
    % grab section of profile that relates
     
    % add it to indicators.lower
    maintick.calculations.indicators{1}.lower.VolumeBuzz=movmean(movmedian(maintick.params.PriceActionProfile.Volume(minuteindex),[1 1]),[2 2]);
    maintick.calculations.indicators{1}.lower.SellVolumeBuzzRatio= maintick.calculations.indicators{1}.lower.SellVolume./maintick.calculations.indicators{1}.lower.VolumeBuzz;
    maintick.calculations.indicators{1}.lower.BuyVolumeBuzzRatio= maintick.calculations.indicators{1}.lower.BuyVolume./maintick.calculations.indicators{1}.lower.VolumeBuzz;
    maintick.calculations.indicators{1}.lower.VolumeBuzzRatio= timetablePrimary.Volume./maintick.calculations.indicators{1}.lower.VolumeBuzz;
    volumebuzzgood=thresholdCondition(maintick.calculations.indicators{1}.lower.VolumeBuzzRatio,maintick.params.thresh.volumeBuzz,1);
    
    maintick.calculations.SnappedPAP=snappap(timetablePrimary,maintick.params);
 else
    maintick.calculations.indicators{1}.lower.VolumeBuzz=zeros(tms,1);
    maintick.calculations.indicators{1}.lower.SellVolumeBuzzRatio= zeros(tms,1);
    maintick.calculations.indicators{1}.lower.BuyVolumeBuzzRatio= zeros(tms,1);
    maintick.calculations.indicators{1}.lower.VolumeBuzzRatio= zeros(tms,1);
    volumebuzzgood=zeros(tms,1);
 end

catch exception
   dumpReport('error.log', exception) 
    
end


%% gen ground truth (used only for training, but parameter needed in generateNetInputs just ot run without error

%% non-causal buysell signals
tradeGroundTruth_signals_(1)=0;
maintick.calculations.indicators{1}.eval.tradeGroundTruth_signals=tradeGroundTruth_signals_;%eros(size(timetablePrimary.Close));
maintick.calculations.indicators{1}.eval.tradeGroundTruth_return=signal2return(timetablePrimary,maintick.calculations.indicators{1}.eval.tradeGroundTruth_signals);


%% relative Strength
try
    
     %%;tic;

if (isfield(maintick.params,'graphExtras'))
   nge=numel(maintick.params.graphExtras);
   for i=1:nge
    if (maintick.params.graphExtras{i}.practice==1)
       for c=1:numel(commonticks)
          if (strcmp(commonticks{c}.maintick.params.contract.Symbol,maintick.params.graphExtras{1}.commontick))
             %calculate relative strength
             maintick.calculations.indicators{1}.lower.RelativeStrength=relativeStrength(timetablePrimary,commonticks{c}.maintick.params.TimeTables.Minute);
          end
       end
    end
   end
end

catch exception
   dumpReport('error.log', exception) 
    
end
 %%;ticsRS=toc


%% exit conditions preparation

%% enter conditions
try
maintick.calculations.minDisProfileClose=getsignedmindis(timetablePrimary.Close,maintick.calculations.levels.values);
maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent=(abs(maintick.calculations.minDisProfileClose.mindis{2}))*(1)./maintick.calculations.atr(end);
maintick.calculations.indicators{1}.lower.CloseFromLowerLevelPercent=(abs(maintick.calculations.minDisProfileClose.mindis{1}))*(1)./maintick.calculations.atr(end);

maintick.calculations.minDisProfileOpen=getsignedmindis(timetablePrimary.Open,maintick.calculations.levels.values);
maintick.calculations.indicators{1}.lower.OpenFromUpperLevelPercent=(abs(maintick.calculations.minDisProfileOpen.mindis{2}))*(1)./maintick.calculations.atr(end);
maintick.calculations.indicators{1}.lower.OpenFromLowerLevelPercent=(abs(maintick.calculations.minDisProfileOpen.mindis{1}))*(1)./maintick.calculations.atr(end);

maintick.calculations.minDisProfileHigh=getsignedmindis(timetablePrimary.High,maintick.calculations.levels.values);
maintick.calculations.indicators{1}.lower.HighFromUpperLevelPercent=(abs(maintick.calculations.minDisProfileHigh.mindis{2}))*(1)./maintick.calculations.atr(end);
maintick.calculations.indicators{1}.lower.HighFromLowerLevelPercent=(abs(maintick.calculations.minDisProfileHigh.mindis{1}))*(1)./maintick.calculations.atr(end);

maintick.calculations.minDisProfileLow =getsignedmindis(timetablePrimary.Low ,maintick.calculations.levels.values);
maintick.calculations.indicators{1}.lower.LowFromLowerLevelPercent=(abs(maintick.calculations.minDisProfileLow.mindis{1}))*(1)./maintick.calculations.atr(end);
maintick.calculations.indicators{1}.lower.LowFromUpperLevelPercent=(abs(maintick.calculations.minDisProfileLow.mindis{2}))*(1)./maintick.calculations.atr(end);

%maintick.calculations.indicators{1}.lower.nextLowerLevelFromClose=timetablePrimary.Close-maintick.calculations.minDisProfileClose.mindis{1};
%maintick.calculations.indicators{1}.lower.nextUpperLevelFromClose=timetablePrimary.Close-maintick.calculations.minDisProfileClose.mindis{2};

upNotJumpedTooMuch=maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent>maintick.calculations.indicators{1}.lower.CloseFromLowerLevelPercent;
dnNotJumpedTooMuch=~upNotJumpedTooMuch;

LowestTouched=movmin(timetablePrimary.Low,[5 0]);
HighestTouched=movmin(timetablePrimary.High,[5 0]);

%next upper level from close smaller than highest touched recently, next
%level is basically broken just recently
isNextUpperTouched=maintick.calculations.minDisProfileClose.mindislvl{2}<HighestTouched; %idea is if it d touched, we can ignore distance form it
%next lower level from close larger than lowest touched recenrly
isNextLowerTouched=maintick.calculations.minDisProfileClose.mindislvl{1}>LowestTouched;

maintick.calculations.indicators{1}.lower.BounceUpFromLowerLevelPercent=min([maintick.calculations.indicators{1}.lower.LowFromLowerLevelPercent,maintick.calculations.indicators{1}.lower.OpenFromLowerLevelPercent,maintick.calculations.indicators{1}.lower.OpenFromUpperLevelPercent],[],2);
maintick.calculations.indicators{1}.lower.BounceDnFromUpperLevelPercent=min([maintick.calculations.indicators{1}.lower.HighFromUpperLevelPercent,maintick.calculations.indicators{1}.lower.OpenFromUpperLevelPercent,maintick.calculations.indicators{1}.lower.OpenFromLowerLevelPercent],[],2);



goodnextlevel_up_farway= isNextUpperTouched | (maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent>maintick.params.thresh.minNextLvlByPercent);% & maintick.calculations.indicators{1}.lower.CloseFromLowerLevelPercent>maintick.params.thresh.maxTooCloseByPercent );
goodnextlevel_dn_farway= isNextLowerTouched | (maintick.calculations.indicators{1}.lower.CloseFromLowerLevelPercent>maintick.params.thresh.minNextLvlByPercent);% & maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent>maintick.params.thresh.maxTooCloseByPercent );

goodlastlevel_up_bounce=maintick.calculations.indicators{1}.lower.BounceUpFromLowerLevelPercent<maintick.params.thresh.maxLastLvlByPercent;
goodlastlevel_dn_bounce=maintick.calculations.indicators{1}.lower.BounceDnFromUpperLevelPercent<maintick.params.thresh.maxLastLvlByPercent;

candle_up=timetablePrimary.Close>timetablePrimary.Open;
higherthanhighprev=timetablePrimary.High>shift(timetablePrimary.High,1);
lowerthanlowprev=timetablePrimary.Low<shift(timetablePrimary.Low,1);

%just place holder for x-minute bar shifted tables, that are dropped for
%now
for i=1:3
fightup{i}=ones(tms,1);
fightdn{i}=ones(tms,1);
vsgood{i}=ones(tms,1);
up_dvs_{i}=ones(tms,1);
dn_dvs_{i}=ones(tms,1);
end

for i=1:numel(tempmainticks)
fightup{i}=maintick.calculations.bounce{i}.up | thresholdCondition(maintick.calculations.indicators{i}.lower.dcs_fight,maintick.params.thresh.dcs.fight,1) | thresholdCondition(shift(maintick.calculations.indicators{i}.lower.dcs_fight,1),maintick.params.thresh.dcs.fight,1);%dcs{i}.fight>maintick.params.thresh.dcs.fight.min | shift(dcs{i}.fight,1)>maintick.params.thresh.dcs.fight.min;
fightdn{i}=maintick.calculations.bounce{i}.dn | thresholdCondition(maintick.calculations.indicators{i}.lower.dcs_fight,maintick.params.thresh.dcs.fight,0) | thresholdCondition(shift(maintick.calculations.indicators{i}.lower.dcs_fight,1),maintick.params.thresh.dcs.fight,0);%dcs{i}.fight<-maintick.params.thresh.dcs.fight.min | shift(dcs{i}.fight,1)<-maintick.params.thresh.dcs.fight.min;
vsgood{i}=volumebuzzgood;% & (thresholdCondition(maintick.calculations.indicators{i}.lower.avs,maintick.params.thresh.avs,1) | thresholdCondition(maintick.calculations.indicators{i}.lower.rvs,maintick.params.thresh.rvs,1));%(avs{i}>maintick.params.thresh.avs.min |rvs{i}>maintick.params.thresh.rvs.min);
up_dvs_{i}=thresholdCondition(maintick.calculations.indicators{i}.lower.dvs_close,maintick.params.thresh.dvs.close,1) & thresholdCondition(maintick.calculations.indicators{i}.lower.dvs_total,maintick.params.thresh.dvs.total,1) & thresholdCondition(maintick.calculations.indicators{i}.lower.dvs_open,maintick.params.thresh.dvs.open,1);
dn_dvs_{i}=thresholdCondition(maintick.calculations.indicators{i}.lower.dvs_close,maintick.params.thresh.dvs.close,0) & thresholdCondition(maintick.calculations.indicators{i}.lower.dvs_total,maintick.params.thresh.dvs.total,0) & thresholdCondition(maintick.calculations.indicators{i}.lower.dvs_open,maintick.params.thresh.dvs.open,0);
end

%%%xxxmor .,could check against close, or high/low, or check againt lasi
%%%bar data
%shiftedclose=timetablePrimary.Close;
shiftedclose=shiftpad(timetablePrimary.Close,1);

lowerThanBBupper= shiftedclose< maintick.calculations.indicators{1}.upper.BBupper;
lowerThanBBupper(isnan(maintick.calculations.indicators{1}.upper.BBupper))=1;

%%%xxxmor .,could check against close
higherThanBBlower= shiftedclose> maintick.calculations.indicators{1}.upper.BBlower;
higherThanBBlower(isnan(maintick.calculations.indicators{1}.upper.BBlower))=1;

notbounceup=~fightup{1} & ~fightup{2}& ~fightup{3};
notbouncedn=~fightdn{1} & ~fightdn{2}& ~fightdn{3};

dsmasettlinglow=thresholdCondition(maintick.calculations.indicators{1}.lower.dsma5,maintick.params.thresh.dsma5settling,0);% maintick.calculations.indicators{1}.lower.dsma5<-maintick.params.thresh.dsma5.min;
dsmasettlinghigh=thresholdCondition(maintick.calculations.indicators{1}.lower.dsma5,maintick.params.thresh.dsma5settling,1);%  maintick.calculations.indicators{1}.lower.dsma5>maintick.params.thresh.dsma5.min;

dsma5low=thresholdCondition(maintick.calculations.indicators{1}.lower.dsma5,maintick.params.thresh.dsma5,0);% maintick.calculations.indicators{1}.lower.dsma5<-maintick.params.thresh.dsma5.min;
dsma5high=thresholdCondition(maintick.calculations.indicators{1}.lower.dsma5,maintick.params.thresh.dsma5,1);%  maintick.calculations.indicators{1}.lower.dsma5>maintick.params.thresh.dsma5.min;
ddsma5high=thresholdCondition(maintick.calculations.indicators{1}.lower.ddsma5,maintick.params.thresh.ddsma5,1);%maintick.calculations.indicators{1}.lower.ddsma5>maintick.params.thresh.ddsma5.min;
ddsma5low=thresholdCondition(maintick.calculations.indicators{1}.lower.ddsma5,maintick.params.thresh.ddsma5,0);%maintick.calculations.indicators{1}.lower.ddsma5<-maintick.params.thresh.ddsma5.min;
hhp=( higherthanhighprev | shift(higherthanhighprev,1));
llp=(lowerthanlowprev | shift(lowerthanlowprev,1));

%upcond_break=(maintick.calculations.indicators{1}.lower.avs>maintick.params.thresh.avs.min.*lxupp |maintick.calculations.indicators{1}.lower.rvs>maintick.params.thresh.rvs.min.*lxupp) ;% & dvs_close>maintick.params.thresh.dvs.close.min & dvs_open>maintick.params.thresh.dvs.open.min & dvs_total > maintick.params.thresh.dvs.total.min;
%dncond_break=(maintick.calculations.indicators{1}.lower.avs>maintick.params.thresh.avs.min.*lxdnp |maintick.calculations.indicators{1}.lower.rvs>maintick.params.thresh.rvs.min.*lxdnp) ;% & dvs_close<-maintick.params.thresh.dvs.close.min & dvs_open<-maintick.params.thresh.dvs.open.min & dvs_total < -maintick.params.thresh.dvs.total.min;

buyersvolumebuzz= maintick.calculations.indicators{1}.lower.SellVolumeBuzzRatio-maintick.calculations.indicators{1}.lower.BuyVolumeBuzzRatio<-maintick.params.thresh.volumeBuzzBuySellDiff.min;% & dvs_close>maintick.params.thresh.dvs.close.min & dvs_open>maintick.params.thresh.dvs.open.min & dvs_total > maintick.params.thresh.dvs.total.min;
sellersvolumebuzz= maintick.calculations.indicators{1}.lower.SellVolumeBuzzRatio-maintick.calculations.indicators{1}.lower.BuyVolumeBuzzRatio>maintick.params.thresh.volumeBuzzBuySellDiff.min;% & dvs_close<-maintick.params.thresh.dvs.close.min & dvs_open<-maintick.params.thresh.dvs.open.min & dvs_total < -maintick.params.thresh.dvs.total.min;


overbought=maintick.calculations.indicators{1}.lower.rsi5>maintick.params.thresh.overboughtPercent.min & maintick.calculations.indicators{1}.lower.rsi10<maintick.params.thresh.overboughtPercent.max;
oversold=maintick.calculations.indicators{1}.lower.rsi5>maintick.params.thresh.oversoldPercent.min & maintick.calculations.indicators{1}.lower.rsi10<maintick.params.thresh.oversoldPercent.max;

up_dvs=up_dvs_{1} | up_dvs_{2}| up_dvs_{3};
dn_dvs=dn_dvs_{1} | dn_dvs_{2}| up_dvs_{3};

debug.indicatorsNames={'CloseFromUpperLevelPercent','avs{1}','rvs{1}','lxupp','lxdnp',... %1,','2,','3,','4,','5 reference to the condition 1,','2(4),','2(4),','3,','4,','
                  '{1}.dcs_fight',...'{2}.dcs_fight','{3}.dcs_fight',...
                  'dsma5','ddsma5',... %6,','7,','8
                  '{1}.dcs_close',...'{2}.dcs_close','{3}.dcs_close',...  %9,','10
                  '{1}.dcs_total',...'{2}.dcs_total','{3}.dcs_total',...%11,','12
                  '{1}.dcs_open',...'{2}.dcs_open','{3}.dcs_open',...%13,','14
                  'CloseFromUpperLevelPercent','CloseFromLowerLevelPercent',... %15,'
                  'OpenFromUpperLevelPercent','OpenFromLowerLevelPercent',...
                  'HighFromUpperLevelPercent','LowFromLowerLevelPercent',...
                  'nextLowerLevelFromClose','nextUpperLevelFromClose',...
                  'BullBearCandleDiff','rsi10',...
                'VolumeBuzzRatio','SellVolumeBuzzRatio','BuyVolumeBuzzRatio'};

debug.indicators=[maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent,maintick.calculations.indicators{1}.lower.avs,maintick.calculations.indicators{1}.lower.rvs,lxupp,lxdnp... %1,2,3,4,5 reference to the condition 1,2(4),2(4),3,4,
                  maintick.calculations.indicators{1}.lower.dcs_fight,...maintick.calculations.indicators{2}.lower.dcs_fight,maintick.calculations.indicators{3}.lower.dcs_fight,...
                  maintick.calculations.indicators{1}.lower.dsma5,maintick.calculations.indicators{1}.lower.ddsma5,... %6,7,8
                  maintick.calculations.indicators{1}.lower.dcs_close,...maintick.calculations.indicators{2}.lower.dcs_close,maintick.calculations.indicators{3}.lower.dcs_close,...  %9,10
                  maintick.calculations.indicators{1}.lower.dcs_total,...maintick.calculations.indicators{2}.lower.dcs_total,maintick.calculations.indicators{3}.lower.dcs_total,...%11,12
                  maintick.calculations.indicators{1}.lower.dcs_open,... maintick.calculations.indicators{2}.lower.dcs_open,maintick.calculations.indicators{3}.lower.dcs_open,...%13,14
                  maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent,maintick.calculations.indicators{1}.lower.CloseFromLowerLevelPercent,... %15
                  maintick.calculations.indicators{1}.lower.OpenFromUpperLevelPercent,maintick.calculations.indicators{1}.lower.OpenFromLowerLevelPercent,...
                  maintick.calculations.indicators{1}.lower.HighFromUpperLevelPercent,maintick.calculations.indicators{1}.lower.LowFromLowerLevelPercent,...
                  maintick.calculations.minDisProfileClose.mindislvl{1},maintick.calculations.minDisProfileClose.mindislvl{2},...
                  maintick.calculations.indicators{1}.lower.BullBearCandleDiff,maintick.calculations.indicators{1}.lower.rsi10,...
                    maintick.calculations.indicators{1}.lower.VolumeBuzzRatio,maintick.calculations.indicators{1}.lower.SellVolumeBuzzRatio,maintick.calculations.indicators{1}.lower.BuyVolumeBuzzRatio];
                

%% more stop related

%xxxmor, high/low may over estimate stop condition, while the stock might
%just bounch back from that high low. Close is better to use, but it will
%under estimate. So, ideally this should become more complicated, and
%consider high/low but only if the price action didn't "fight" back.
%upNextLevelIsReaching= abs(maintick.calculations.indicators{1}.lower.HighFromUpperLevelPercent)<maintick.params.thresh.maxLastLvlByPercent;
%dnNextLevelIsReaching= abs(maintick.calculations.indicators{1}.lower.LowFromLowerLevelPercent)<maintick.params.thresh.maxLastLvlByPercent;

upNextLevelIsReaching= abs(maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent)<maintick.params.thresh.maxLastLvlByPercent;
dnNextLevelIsReaching= abs(maintick.calculations.indicators{1}.lower.CloseFromLowerLevelPercent)<maintick.params.thresh.maxLastLvlByPercent;

upPrevLevelIsReached= abs(maintick.calculations.indicators{1}.lower.HighFromLowerLevelPercent)<maintick.params.thresh.maxLastLvlByPercent;
dnPrevLevelIsReached= abs(maintick.calculations.indicators{1}.lower.LowFromUpperLevelPercent)<maintick.params.thresh.maxLastLvlByPercent;

ddsma_lessthanmin=thresholdCondition(maintick.calculations.indicators{1}.lower.ddsma5,maintick.params.thresh.ddsma5,3);
ddsma_morethan_minusmin=thresholdCondition(maintick.calculations.indicators{1}.lower.ddsma5,maintick.params.thresh.ddsma5,2);

dret_sma5_close_zerocrossing_up=maintick.calculations.indicators{1}.lower.dret_sma5_close>maintick.params.thresh.zerocrossing & shiftpad(maintick.calculations.indicators{1}.lower.dret_sma5_close,1)<-maintick.params.thresh.zerocrossing;
dret_sma5_close_zerocrossing_dn=maintick.calculations.indicators{1}.lower.dret_sma5_close<-maintick.params.thresh.zerocrossing & shiftpad(maintick.calculations.indicators{1}.lower.dret_sma5_close,1)>maintick.params.thresh.zerocrossing;

ret_sma5_close_low =thresholdCondition(maintick.calculations.indicators{1}.lower.ret_sma5_close,maintick.params.thresh.ret_sma5,0);
ret_sma5_close_high=thresholdCondition(maintick.calculations.indicators{1}.lower.ret_sma5_close,maintick.params.thresh.ret_sma5,1);

tr_cdc=abs(timetablePrimary.Close-maintick.calculations.previousClose);
tr_cl=abs(timetablePrimary.Close-timetablePrimary.Low);
tr_ch=abs(timetablePrimary.Close-timetablePrimary.High);
tr_hl=abs(timetablePrimary.Low-timetablePrimary.High)/2; % allow some room for this, for possible breakouts
tr=max([tr_cdc tr_cl tr_ch tr_hl],[],2);
tr=abs(timetablePrimary.Close-timetablePrimary.Open);

atrgood=tr<maintick.calculations.atr(end);

%%

debug.AllConditionsnames={ 'goodnextlevel_up_farway', 'buyersvolumebuzz', 'lxups',... %1', '2', '3
      'sellersvolumebuzz', 'lxdns',... %4', '5
      'llp', 'fightup{1}', 'candle_up', 'vsgood{1}', 'dsma5low', 'ddsma5high',...%6', '7', '8', '9', '10', '11
      'hhp', 'fightdn{1}', '~candle_up', 'dsma5high', 'ddsma5low',... %12', '13', '14', '15', '16
      'fightup{2}', 'fightdn{2}', 'vsgood{2}',...%17', '18', '19
      'goodnextlevel_dn_farway',... %20
      'up_dvs', 'dn_dvs',...%21', '22
      'dsmasettlinghigh', 'dsmasettlinglow',... %23', '24
      'BullishCandles', 'BearishCandles',...   %25', '26
      'notbounceup', 'notbouncedn',... %27', '28
      'lowerThanBBupper', 'higherThanBBlower ',... %29,30
      'fightup_all','fightdn_all',...               %31,32
      'goodlastlevel_up_bounce','goodlastlevel_dn_bounce',... %33,34
      'upReacingorReachedLevel','dnReachingorReachedLevel',... %35,36
       'ddsma_lessthanmin','ddsma_morethan_minusmin',... %,37,38
       'dnNotJumpedTooMuch','upNotJumpedTooMuch',... %39,40
       'overbought','oversold',... % 41,42
       'dret_sma5_close_zerocrossing_up','dret_sma5_close_zerocrossing_up',... % 43,44
       'ret_sma5_close_low','ret_sma5_close_high',... % 45,46
       'zeros',... %47
       'atrgood'
      };
 
debug.AllConditions=([goodnextlevel_up_farway,buyersvolumebuzz,lxups>0,... %1,2,3
     sellersvolumebuzz,lxdns>0,... %4,5
     llp,fightup{1},candle_up,vsgood{1},dsma5low,ddsma5high,...%6,7,8,9,10,11
     hhp,fightdn{1},~candle_up,dsma5high,ddsma5low,... %12,13,14,15,16
     fightup{2},fightdn{2},vsgood{2},...%17,18,19
     goodnextlevel_dn_farway,... %20
     up_dvs,dn_dvs,...%21,22
     dsmasettlinghigh,dsmasettlinglow,... %23,24
     BullishCandles,BearishCandles,...   %25,26
     notbounceup,notbouncedn,... %27,28
     lowerThanBBupper,higherThanBBlower,... %29,30
     fightup{1}|fightup{2}|fightup{3},fightdn{1}|fightdn{2}|fightdn{3},...%31,32
     goodlastlevel_up_bounce,goodlastlevel_dn_bounce,... %33,34
     (upNextLevelIsReaching|upPrevLevelIsReached),(dnNextLevelIsReaching|dnPrevLevelIsReached),... %35,36
     ddsma_lessthanmin,ddsma_morethan_minusmin,... %,37,38
     dnNotJumpedTooMuch,upNotJumpedTooMuch,... %39,40
     overbought,oversold,... %41,42
     dret_sma5_close_zerocrossing_up,dret_sma5_close_zerocrossing_dn,ret_sma5_close_low,ret_sma5_close_high,...   %43,44, 45,46
     zeros(size(timetablePrimary.Close)),... %47, this is to not have a condition
     atrgood
     ]); 

  
try
debug.DirectionCondition=maintick.params.Strategies.Manual.Conditions.Entry;
maintick.calculations.DirectionPrediction{1}.Condition=[];
maintick.calculations.DirectionPrediction{2}.Condition=[];

for i=1:size(debug.DirectionCondition,1)
    for j=1:size(debug.DirectionCondition,2)
        maintick.calculations.DirectionPrediction{j}.Condition(:,i)=min(debug.AllConditions(:,debug.DirectionCondition{i,j}),[],2);
    end
end
catch exception
   dumpReport('error.log', exception) 
    
end
catch exception
   dumpReport('error.log', exception) 
    
end
 %%;ticscond=toc
 %%;tic;

try
%% stop conditions

% debug.AllStopConditionsnames={'upNextLevelIsReaching','dnNextLevelIsReaching',...
%     'ddsmagettingsmaller','ddsmagettinglarger',...
%     'candle_up','~candle_up'};
%  
% debug.AllStopConditions=([upNextLevelIsReaching,dnNextLevelIsReaching,...
%     ddsmagettingsmaller,ddsmagettinglarger,...
%     candle_up,~candle_up
%     ]);
 
% debug.StopCondition{1,1}=[35,37,8]; %upward
% debug.StopCondition{1,2}=[36,38,14]; 

% dsma stuff are really under developed here to be used... we want to trakc
% slow down of signal, or change in direction of dsma, which is zero
% crosing f ddsma... candles don't give that. Will have to possibly look at
% reversal of ddsma in between candles

% di=1;
% debug.StopCondition{di,1}=[35,37]; %upward
% debug.StopCondition{di,2}=[36,38]; 
% di=di+1;
% %debug.StopCondition{di,1}=[8,31 ,30,33]; %upward
% %debug.StopCondition{di,2}=[14,32,29,34]; 
% %di=di+1;
% debug.StopCondition{di,1}=[3,43,45]; %upward
% debug.StopCondition{di,2}=[5,44,46]; 
debug.StopCondition=maintick.params.Strategies.Manual.Conditions.Exit;

for i=1:size(debug.StopCondition,1)
    for j=1:size(debug.StopCondition,2)
        maintick.calculations.StopPrediction{j}.Condition(:,i)=min(debug.AllConditions(:,debug.StopCondition{i,j}),[],2);
    end
end
catch exception
   dumpReport('error.log', exception) 
    
end
 %%;ticsstopcond=toc

 %%;tic



%% net entries

try
    maintick.calculations.indicators{1}.eval.net_yRemapped=zeros(size(timetablePrimary.Close));
    maintick.calculations.net.DirectionPrediction{1}.final=zeros(size(timetablePrimary.Close));
     maintick.calculations.net.DirectionPrediction{2}.final= maintick.calculations.net.DirectionPrediction{1}.final;
if (looperEngine.net.use==1)
    if (isfield(maintick.params.net,'netP1'))
        [maintick.calculations.net.X,maintick.calculations.net.C,maintick.calculations.net.T,maintick.calculations.net.t,maintick.calculations.net.indices,maintick.calculations.net.viewx,maintick.calculations.net.indicators]=generateNetInputs_t10(looperEngine,maintick.params,maintick.calculations,commonticks);
        if (~isempty(maintick.calculations.net.X))
        
        maintick.calculations.net.Y=maintick.params.net.netP1(maintick.calculations.net.X);
        maintick.calculations.net.y=convertTargetTocondensed(maintick.calculations.net.Y);
        maintick.calculations.net.yRemapped=zeros(size(timetablePrimary.Close));
        maintick.calculations.net.yRemapped(maintick.calculations.net.indices)=maintick.calculations.net.y;
        maintick.calculations.indicators{1}.eval.net_yRemapped=maintick.calculations.net.yRemapped;
        maintick.calculations.net.DirectionPrediction{1}.final=(maintick.calculations.net.yRemapped>0.75);
        maintick.calculations.net.DirectionPrediction{2}.final=(maintick.calculations.net.yRemapped<-0.75);

        end
    end
end

catch exception
   disp('net failed.');
    disp(exception.message);
   %dumpReport('error.log', exception) 
end

 %%;ticprocesscond=toc
 %%;tic;

%commas=repmat(',',size(timetablePrimary.Date,1),1);
%[datestr(timetablePrimary.Date),commas,num2str(maintick.calculations.DirectionPrediction{1}.final),commas,num2str(maintick.calculations.DirectionPrediction{2}.final),num2str(lxdns), num2str(lxups),num2str(maintick.calculations.indicators{1}.lower.dsma5),commas,num2str(maintick.calculations.minDisProfileClose.mindis{1}),num2str(maintick.calculations.minDisProfileClose.mindis{2}),num2str(maintick.calculations.indicators{1}.lower.CloseFromUpperLevelPercent),num2str(debug.AllConditions(:,cond11))]
%[datestr(timetablePrimary.Date),num2str(dcs{1}.fight),num2str(dcs{2}.fight),num2str(avs{1}),num2str(avs{2}),num2str(rvs{1}),num2str(rvs{2}),num2str(maintick.calculations.indicators{1}.lower.dsma5),num2str(maintick.calculations.indicators{1}.lower.ddsma5),num2str(dvs{1}.close),num2str(dvs{2}.close),num2str(dvs{1}.open),num2str(dvs{2}.open),num2str(dvs{1}.total),num2str(dvs{2}.total)]
 %%;ticgndtruth=toc
maintick.calculations.finished=1;
%try for all
catch exception
   dumpReport('error.log', exception) 
    
end


end

