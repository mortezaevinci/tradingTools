function [maintick,debug]=strategy_breakout_t10(looperEngine,maintick,commonticks)
debug=struct();
try

global showbackdateonce;

if (looperEngine.process.type==0)
timetablePrimary=maintick.params.TimeTables.Minute;
timetableSecondary=maintick.params.TimeTables.Day;
timetableAuxilary=maintick.params.TimeTables.Month;
alpha=.60;
alphalong=0.60;
end
if (looperEngine.process.type==1)
timetablePrimary=maintick.params.TimeTables.Day(end-90:end,:);
timetableSecondary=maintick.params.TimeTables.Month;
timetableAuxilary=maintick.params.TimeTables.Month;
alpha=0.25;
alphalong=0.60;
end

if (isempty(timetablePrimary))
    return;
end

maintick.calculations.started=1;
%% preperation
try
    themorningdate=datetime([datestr(timetablePrimary.Date(end),'yyyy-mm-dd') ' 09:30:00']);

    
 %%;tic
% for monthly pivots
tr=timerange(themorningdate- day(themorningdate)-day(28)-day(10), themorningdate);
molast=timetableAuxilary(tr,:);
lastmonthquote=molast(1,:);
mo=molast(end,:).Open;
mc=lastmonthquote.Close;
mlh(1)=lastmonthquote.Low;
mlh(2)=lastmonthquote.High;

colors_mlh={[0 0.8 0 alphalong],[1 0 0 alphalong]};
style_mlh={'-','-'};
dir_mlh=[-1 1];
width_mlh=[3 3];
power_mlh=[3 3];
name_mlh={'MLL','MLH'};
id_mlh=[0x0B00 0x0B01];
 %%;ticprep=toc
catch exception
   dumpReport('error.log', exception) 
    
end
 %%;ticsprep=toc
 %%;tic;
%% this is for daily pivots
try

%% xxxmor, TDA daily data show a different time stamp, so double check that these act the same way

tr=timerange(themorningdate-days(60), themorningdate-hours(themorningdate.Hour)-minutes(themorningdate.Minute)-hours(4));
try
ddlast=maintick.params.TimeTables.Day(tr,:);
%lastdayquote=ddlast(end,:);
% dc=lastdayquote.Close;
catch
    
end

levels(1)=indicators_levels_ma(maintick.params.TimeTables.Day);

%% extended dailyhighloq ould be combined

%maintick.params.lenPreviousDayPivots=0;
dailyHighLow=zeros(1,maintick.params.lenPreviousDayPivots*2);
colors_dailyHighLow=cell(1,maintick.params.lenPreviousDayPivots*2);
dir_dailyHighLow=zeros(1,maintick.params.lenPreviousDayPivots*2);
width_dailyHighLow=ones(1,maintick.params.lenPreviousDayPivots*2);
power_dailyHighLow=zeros(1,maintick.params.lenPreviousDayPivots*2);power_dailyHighLow(1:2)=[1,1];
style_dailyHighLow=cell(1,maintick.params.lenPreviousDayPivots*2);
name_dailyHighLow=cell(1,maintick.params.lenPreviousDayPivots*2);

alphadiff=alpha/maintick.params.lenPreviousDayPivots;
 for i=1:maintick.params.lenPreviousDayPivots
     try
 lastdayquote=ddlast(end+1-i,:);
 dailyHighLow(i*2-1)=lastdayquote.Low;
 dailyHighLow(i*2)=lastdayquote.High;
 colors_dailyHighLow{i*2-1}=[0 0 1  alpha-alphadiff*i];
 colors_dailyHighLow{i*2}=[0 0 1  alpha-alphadiff*i];
 style_dailyHighLow{i*2-1}=':';
 style_dailyHighLow{i*2}=':';
 name_dailyHighLow{i*2-1}=['DL' num2str(i)];
  name_dailyHighLow{i*2}=['DH' num2str(i)];
 dir_dailyHighLow(i*2-1:i*2)=[0 0];%[-1 1];
 x1=(0x0100)+i*2-1;
 x2=(0x0100)+i*2;
 id_dailyHighLow(i*2-1:i*2)=[x1 x2];
     catch exception
   dumpReport('error.log', exception)  
         
     end
 end
 
 
 maintick.calculations.diffdhl=dailyHighLow(2)-dailyHighLow(1);

catch exception
   dumpReport('error.log', exception)  
end
 %%;tic_dlh_sma=toc
 %%;tic
%% orb levels
try


if (size(timetablePrimary,1)>60) %60 minutes from star
     orb(2)=max(timetablePrimary.High(1:60));
     orb(1)=min(timetablePrimary.Low(1:60));
     colors_orb={[0 1 0  alphalong],[1 0 0 alphalong]};
style_orb={'-','-'};
dir_orb=[0 0];
width_orb=[1 1];
power_orb=[1 1];
id_orb=[0x0200 0x0201];
name_orb={'ORL','ORH'};
else
    orb=[];
        colors_orb={};
style_orb={};
dir_orb=[];
width_orb=[];
power_orb=[];
id_orb=[];
name_orb={}; 
end

lvl_ADH=[0 0];
if (~isempty(maintick.params.TimeTables.MinuteFull))
tmfulltime=maintick.params.TimeTables.MinuteFull.Date.Hour+maintick.params.TimeTables.MinuteFull.Date.Minute/60;
pminds=find(tmfulltime<9.5 & tmfulltime>=4);
%all day high including premarket
lvl_ADH(2)=max(maintick.params.TimeTables.MinuteFull.High(pminds));
lvl_ADH(1)=min(maintick.params.TimeTables.MinuteFull.Low(pminds));
end
colors_ADH={[0.9 0.6 0  alphalong],[0.9 0.6 0 alphalong]};
style_ADH={'-','-'};
dir_ADH=[0 0];
width_ADH=[2 2];
power_ADH=[2 2];
id_ADH=[0x0C00 0x0C01];
name_ADH={'ADL','ADH'};



% Set process limit after ORB
if (looperEngine.process.limit>0)
proclimit_=min(looperEngine.process.limit,numel(timetablePrimary.Date)-1);
timetablePrimary=timetablePrimary(end-proclimit_:end,:);

end
tms=size(timetablePrimary,1);
catch exception
   dumpReport('error.log', exception)
end
 %%;ticorb=toc
 %%;tic
%% continue LEVELS

try
   
%sve
msvepivots=SVEPivots(mc,mlh(2),mlh(1));
dsvepivots=SVEPivots(maintick.calculations.previousClose,dailyHighLow(2),dailyHighLow(1));
colors_msvepivots={[0 0.8 0 alphalong],[0 0.8 0 alphalong],[0 0.8 0 alphalong],[0 0.8 0 alphalong],[1 0 1 alphalong],[1 0 0 alphalong],[1 0 0 alphalong],[1 0 0 alphalong],[1 0 0 alphalong]};
colors_dsvepivots={[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[1 0 1 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha]};
style_svepivots= {'-','-','-','-','-','-','-','-','-'};
dir_svepivots=[0 0 0 0 0 0 0 0 0];%[-1 -1 -1 -1 0 1 1 1 1];
width_dsve=[1 1 1 1 1 1 1 1 1];
width_msve=[3 3 3 3 3 3 3 3 3];
power_dsve=[2 2 1 1 1 1 1 2 2];
power_msve=[3 3 2 2 2 2 2 2 2];
id_msve=[0x0300 0x0301 0x0302 0x0303 0x0304 0x0305 0x0306 0x0307 0x0308];
id_dsve=[0x0400 0x0401 0x0402 0x0403 0x0404 0x0405 0x0406 0x0407 0x0408];
name_dsve={'DS4','DS3','DS2','DS1','DPP','DR1','DR2','DR3','DR4'};
name_msve={'MS4','MS3','MS2','MS1','MPP','MR1','MR2','MR3','MR4'};
%woodies
mwpivots=WoodiesPivots(mc,mlh(2),mlh(1));
dwpivots=WoodiesPivots(maintick.calculations.previousClose,dailyHighLow(2),dailyHighLow(1));
colors_mwpivots={[0 0.8 0 alphalong],[0 0.8 0 alphalong],[0 0.8 0 alphalong],[0 0.8 0 alphalong],[1 0 1 alphalong],[1 0 0 alphalong],[1 0 0 alphalong],[1 0 0 alphalong],[1 0 0 alphalong]};
colors_dwpivots={[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[1 0 1 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha]};
style_wpivots={'--','--','--','--','--','--','--','--','--'};
dir_wpivots=[0 0 0 0 0 0 0 0 0];%dir_wpivots=[-1 -1 -1 -1 0 1 1 1 1];
width_dwpivots=[1 1 1 1 1 1 1 1 1];
width_mwpivots=[3 3 3 3 3 3 3 3 3];
power_dwpivots=[2 2 1 1 1 1 1 2 2];
power_mwpivots=[3 3 2 2 2 2 2 3 3];
id_mwpivots=[0x0500 0x0501 0x0502 0x0503 0x0504 0x0505 0x0506 0x0507 0x0508];
id_dwpivots=[0x0600 0x0601 0x0602 0x0603 0x0604 0x0605 0x0606 0x0607 0x0608];

name_dwpivots={'DWS4','DWS3','DWS2','DWS1','DWPP','DWR1','DWR2','DWR3','DWR4'};
name_mwpivots={'MWS4','MWS3','MWS2','MWS1','MWPP','MWR1','MWR2','MWR3','MWR4'};

%fibonacci
mfibpivots=FibonacciPivots(mc,mlh(2),mlh(1));
dfibpivots=FibonacciPivots(maintick.calculations.previousClose,dailyHighLow(2),dailyHighLow(1));
colors_mfibpivots={[0 0.8 0 alphalong],[0 0.8 0 alphalong],[0 0.8 0 alphalong],[0 0.8 0 alphalong],[1 0 1 alphalong],[1 0 0 alphalong],[1 0 0 alphalong],[1 0 0 alphalong],[1 0 0 alphalong]};
colors_dfibpivots={[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[0 0.8 0 alpha],[1 0 1 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha],[1 0 0 alpha]};
style_fibpivots= {'-','-','-','-','-','-','-','-','-'};
dir_fibpivots=[0 0 0 0 0 0 0 0 0];%[-1 -1 -1 -1 0 1 1 1 1];
width_dfib=[1 1 1 1 1 1 1 1 1];
width_mfib=[3 3 3 3 3 3 3 3 3];
power_dfib=[2 2 1 1 1 1 1 2 2];
power_mfib=[3 3 2 2 2 2 2 2 2];
id_mfib=[0x0D00 0x0D01 0x0D02 0x0D03 0x0D04 0x0D05 0x0D06 0x0D07 0x0D08];
id_dfib=[0x0E00 0x0E01 0x0E02 0x0E03 0x0E04 0x0E05 0x0E06 0x0E07 0x0E08];
name_dfib={'DF4','DF3','DF2','DF1','DFP','DF1','DF2','DF3','DF4'};
name_mfib={'MF4','MF3','MF2','MF1','MFP','MF1','MF2','MF3','MF4'};

[hlvls,llvls]=roundLevelsAll(timetablePrimary);
for i=1:2
   dh_{i}=repmat(0,1,numel(hlvls{i}));
   wh_{i}=repmat(i,1,numel(hlvls{i}));
   dl_{i}=repmat(0,1,numel(llvls{i}));
   wl_{i}=repmat(i,1,numel(llvls{i}));
   pl_{i}=repmat(i,1,numel(llvls{i}));
   ph_{i}=repmat(i,1,numel(hlvls{i}));
end
rlvls=[llvls{1} llvls{2} hlvls{1} hlvls{2}];
colors_rlvls=cell(size(rlvls));
style_rlvls=cell(size(rlvls));
name_rlvls=cell(size(rlvls));
for uu=1:numel(rlvls)
    colors_rlvls{uu}=[.5 .5 .5 alpha];
    style_rlvls{uu}='--';
    name_rlvls{uu}='RND';
end
dir_rlvls=[dl_{1} dl_{2} dh_{1} dh_{2}];
width_rlvls=[wl_{1} wl_{2} wh_{1} wh_{2}];
power_rlvls=[pl_{1} pl_{2} ph_{1} ph_{2}];
xx=1:numel(rlvls);
id_rlvls=0x0700+uint16(xx);


catch exception
   dumpReport('error.log', exception) 
end
 %%;tictradlevels=toc
 %%;tic
maintick.calculations.levels.values=[dsvepivots msvepivots dfibpivots mfibpivots dwpivots mwpivots orb dailyHighLow rlvls smas mlh lvl_ADH];
maintick.calculations.levels.color=[colors_dsvepivots colors_msvepivots colors_dfibpivots colors_mfibpivots colors_dwpivots colors_mwpivots colors_orb colors_dailyHighLow colors_rlvls colors_smas colors_mlh colors_ADH];
maintick.calculations.levels.style=[style_svepivots  style_svepivots style_fibpivots  style_fibpivots   style_wpivots  style_wpivots  style_orb  style_dailyHighLow  style_rlvls style_smas style_mlh style_ADH];
maintick.calculations.levels.direction=[dir_svepivots dir_svepivots dir_fibpivots dir_fibpivots dir_wpivots dir_wpivots dir_orb dir_dailyHighLow dir_rlvls dir_smas dir_mlh dir_ADH];
maintick.calculations.levels.width=[width_dsve width_msve width_dfib width_mfib width_dwpivots width_mwpivots width_orb width_dailyHighLow width_rlvls width_smas width_mlh width_ADH];
maintick.calculations.levels.power=[power_dsve power_msve power_dfib power_mfib power_dwpivots power_mwpivots power_orb power_dailyHighLow power_rlvls power_smas power_mlh power_ADH];
maintick.calculations.levels.id=[id_dsve id_msve id_dfib id_mfib id_dwpivots id_mwpivots id_orb id_dailyHighLow id_rlvls id_smas id_mlh id_ADH];
maintick.calculations.levels.name=[name_dsve name_msve name_dfib name_mfib name_dwpivots name_mwpivots name_orb name_dailyHighLow name_rlvls name_smas name_mlh name_ADH];

% remove far away levels that we do not care for
minmin=min(timetablePrimary.Low)*0.85;
maxmax=max(timetablePrimary.High)*1.15;
inind=find(maintick.calculations.levels.values>minmin & maintick.calculations.levels.values<maxmax);
maintick.calculations.levels.values=maintick.calculations.levels.values(inind);
maintick.calculations.levels.color=maintick.calculations.levels.color(inind);
maintick.calculations.levels.direction=maintick.calculations.levels.direction(inind);
maintick.calculations.levels.width=maintick.calculations.levels.width(inind);
maintick.calculations.levels.power=maintick.calculations.levels.power(inind);
maintick.calculations.levels.id=maintick.calculations.levels.id(inind);
maintick.calculations.levels.style=maintick.calculations.levels.style(inind);
maintick.calculations.levels.name=maintick.calculations.levels.name(inind);

%numel(maintick.calculations.levels.values)

% sort levels for later additional analysis
[~,sindex]=sort(maintick.calculations.levels.values);
maintick.calculations.levels.values=maintick.calculations.levels.values(sindex);
maintick.calculations.levels.color=maintick.calculations.levels.color(sindex);
maintick.calculations.levels.direction=maintick.calculations.levels.direction(sindex);
maintick.calculations.levels.width=maintick.calculations.levels.width(sindex);
maintick.calculations.levels.power=maintick.calculations.levels.power(sindex);
maintick.calculations.levels.id=maintick.calculations.levels.id(sindex);
maintick.calculations.levels.style=maintick.calculations.levels.style(sindex);
maintick.calculations.levels.name=maintick.calculations.levels.name(sindex);
 %%;ticslevels=toc
 %%;tic

%% find crossings
try

lxup=zeros(tms,size(maintick.calculations.levels.values,2));
lxdn=zeros(tms,size(maintick.calculations.levels.values,2));
for i=find(maintick.calculations.levels.power>0)
    [lxup(:,i),lxdn(:,i)]=crossPivot(timetablePrimary,maintick.calculations.levels.values(i));
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
   



%maintick.calculations.indicators{1}.lower=lower_indicators_ideal(timetablePrimary);
%maintick.calculations.indicators{1}.upper=upper_indicators_ideal(timetablePrimary);

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
loColors={[0.5 0.5 0.5 alpha],[0 0 1 alpha],[0 .75 1 alpha],[0 .75 1 alpha],[0 .75 1 alpha]};
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
        [maintick.calculations.net.X,maintick.calculations.net.C,maintick.calculations.net.T,maintick.calculations.net.t, ...
         maintick.calculations.net.indices,maintick.calculations.net.viewx, maintick.calculations.net.indicators]= ... 
          generateNetInputs_t10(looperEngine,maintick.params,maintick.calculations,commonticks);
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

