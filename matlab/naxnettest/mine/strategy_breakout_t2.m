function calculations=strategy_breakout_t2(params)

% %if this line is commented out, the 5 day intraday week loads
% load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' today.mat']);
% 
% %% baseline data
% load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' daily ' params.date '.mat']);
% load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' monthly ' params.date '.mat']);
% load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' weekly ' params.date '.mat']);
% 
% params.TimeTables.Minute=table2timetable(tm);
% params.TimeTables.Day=table2timetable(td);
% params.TimeTables.Week=table2timetable(tw);
% params.TimeTables.Month=table2timetable(tmo);

global showbackdateonce;


%% preperation

% for monthly pivots
tr=timerange(params.TimeTables.Minute.Date(1)- day(datetime())-day(28)-day(3), params.TimeTables.Minute.Date(1)-day(1)/2);
molast=params.TimeTables.Month(tr,:);
lastmonthquote=molast(end,:);
mo=molast(end,:).Open;
mc=lastmonthquote.Close;
mlh(1)=lastmonthquote.Low;
mlh(2)=lastmonthquote.High;

%% this is for daily pivots

tr=timerange(params.TimeTables.Minute.Date(1)-day(5), params.TimeTables.Minute.Date(1)-day(1)/2);
ddlast=params.TimeTables.Day(tr,:);
lastdayquote=ddlast(end,:);
do=params.TimeTables.Minute(1,:).Open;
dc=lastdayquote.Close;
dlh(1)=lastdayquote.Low;
dlh(2)=lastdayquote.High;


if (isempty(showbackdateonce) || showbackdateonce==0) 
    showbackdateonce=1;
disp(['using ' datestr(lastmonthquote.Date(end)) ' monthly data for previous month.']);
disp(['using ' datestr(lastdayquote.Date) ' daily data for previous day.']);
end

%% this is for levels... could be combined
%params.lenPreviousDayPivots=20;
dailyHighLow=zeros(1,params.lenPreviousDayPivots*2);
colors_dailyHighLow=cell(1,params.lenPreviousDayPivots*2);
dir_dailyHighLow=zeros(1,params.lenPreviousDayPivots*2);
width_dailyHighLow=ones(1,params.lenPreviousDayPivots*2);
power_dailyHighLow=zeros(1,params.lenPreviousDayPivots*2);power_dailyHighLow(1:2)=[1,1];
for i=1:params.lenPreviousDayPivots
lastdayquote=params.TimeTables.Day(end-i,:);
dailyHighLow(i*2-1)=lastdayquote.Low;
dailyHighLow(i*2)=lastdayquote.High;
colors_dailyHighLow{i*2-1}='b--';
colors_dailyHighLow{i*2}='b--';
dir_dailyHighLow(i*2-1:i*2)=[-1 1];
end



%% orb levels
orb=zeros(1,2);
if (size(params.TimeTables.Minute,1)>60) %60 minutes from star
     orb(2)=max(params.TimeTables.Minute.High(1:60));
     orb(1)=min(params.TimeTables.Minute.Low(1:60));
end
colors_orb={'r','g'};
dir_orb=[-1 1];
width_orb=[1 1];
power_orb=[1 1];


%% Set process limit after ORB
if (params.processlimit>0)
proclimit_=min(params.processlimit,numel(params.TimeTables.Minute.Date)-1);
params.TimeTables.Minute=params.TimeTables.Minute(end-proclimit_:end,:);
end
tms=size(params.TimeTables.Minute,1);

%% continue LEVELS
%sve
msvepivots=SVEPivots(mc,mlh(2),mlh(1));
dsvepivots=SVEPivots(dc,dlh(2),dlh(1));
colors_svepivots={'g','g','g','m','r','r','r'};
dir_svepivots=[-1 -1 -1 0 1 1 1];
width_dsve=[1 1 1 1 1 1 1];
width_msve=[3 3 3 3 3 3 3];
power_dsve=[1 1 1 1 1 1 1];
power_msve=[2 2 2 2 2 2 2];

%woodies
mwpivots=WoodiesPivots(mo,mlh(2),mlh(1));
dwpivots=WoodiesPivots(do,dlh(2),dlh(1));
colors_wpivots={'g--','g--','g--','m--','r--','r--','r--'};
dir_wpivots=[-1 -1 -1 0 1 1 1];
width_dwpivots=[1 1 1 1 1 1 1];
width_mwpivots=[3 3 3 3 3 3 3];
power_dwpivots=[1 1 1 1 1 1 1];
power_mwpivots=[2 2 2 2 2 2 2];

%high/low of yesterday
%dlh
%roundlevels
%%old approach
%rlvls=roundLevels(params.TimeTables.Minute.Close);
%colors_rlvls={'k.', 'k.','k.','k.'};
%dir_rlvls=[-1 1 -1 1];
%width_rlvls=[1 1 1 1];
[hlvls,llvls]=roundLevelsAll(params.TimeTables.Minute);
for i=1:2
   %ch_{i}=repmat('k--',1,numel(hlvls{i}));
   dh_{i}=repmat(1,1,numel(hlvls{i}));
   wh_{i}=repmat(i,1,numel(hlvls{i}));
   %cl_{i}=repmat('k--',1,numel(llvls{i}));
   dl_{i}=repmat(-1,1,numel(llvls{i}));
   wl_{i}=repmat(i,1,numel(llvls{i}));
   pl_{i}=repmat(i,1,numel(llvls{i}));
   ph_{i}=repmat(i,1,numel(hlvls{i}));
end
rlvls=[llvls{1} llvls{2} hlvls{1} hlvls{2}];
for uu=1:numel(rlvls)
    colors_rlvls{uu}='k--';
end
dir_rlvls=[dl_{1} dl_{2} dh_{1} dh_{2}];
width_rlvls=[wl_{1} wl_{2} wh_{1} wh_{2}];
power_rlvls=[pl_{1} pl_{2} ph_{1} ph_{2}];


calculations.levels.values=[dsvepivots msvepivots dwpivots mwpivots orb dailyHighLow rlvls];
calculations.levels.color=[colors_svepivots colors_svepivots colors_wpivots colors_wpivots colors_orb colors_dailyHighLow colors_rlvls];
calculations.levels.direction=[dir_svepivots dir_svepivots dir_wpivots dir_wpivots dir_orb dir_dailyHighLow dir_rlvls];
calculations.levels.width=[width_dsve width_msve width_dwpivots width_mwpivots width_orb width_dailyHighLow width_rlvls];
calculations.levels.power=[power_dsve power_msve power_dwpivots power_mwpivots power_orb power_dailyHighLow power_rlvls];

% sort levels for later additional analysis
[~,sindex]=sort(calculations.levels.values);
calculations.levels.values=calculations.levels.values(sindex);
calculations.levels.color=calculations.levels.color(sindex);
calculations.levels.direction=calculations.levels.direction(sindex);
calculations.levels.width=calculations.levels.width(sindex);
calculations.levels.power=calculations.levels.power(sindex);

%%find crossings
lxup=zeros(tms,size(calculations.levels.values,2));
lxdn=zeros(tms,size(calculations.levels.values,2));
for i=find(calculations.levels.power>0)
    [lxup(:,i),lxdn(:,i)]=crossPivot(params.TimeTables.Minute,calculations.levels.values(i));
end

[lxups,lxupi]=max(lxup,[],2);
[lxdns,lxdni]=max(lxdn,[],2);

%power of levels to corss.. not used for now
lxupp=calculations.levels.power(lxupi)';
lxdnp=calculations.levels.power(lxdni)';

nlvls=numel(calculations.levels.values);
maxup=calculations.levels.values(nlvls)*2;
lxupiNext=lxupi+1;
lxupiNext(lxupiNext==0)=1;
lxupNext=calculations.levels.values(lxupiNext)';
lxupNext(lxupi==nlvls | lxupi==1)=maxup;


lxdniNext=lxdni-1;
lxdniNext(lxdniNext==0)=1;
lxdnNext=calculations.levels.values(lxdniNext)';
lxdnNext(lxdni==1)=0;


%% INDICATORS

[calculations.buyv,calculations.sellv]=buysellVolume(params.TimeTables.Minute,0);

calculations.indicators=indicators_ideal(params.TimeTables.Minute);
[mindis,mindislvl]=getmindiscomplex(params.TimeTables.Minute,calculations.levels.values);

%%local optima

loWidths=params.localOptimaWidths;%[9,21];%,21,35,50];
loColors={'c:','c:','c:','b:','k:'};

for i=1:numel(loWidths)
calculations.localOptimaProfile{i}=localOptimaProfiler(loWidths(i),params,1);
calculations.localOptimaProfile{i}.color=loColors{i};
end
% 
% calculations.localOptimaProfile{1}=localOptimaProfiler(7,params,1);
% calculations.localOptimaProfile{1}.color='c:';
% calculations.localOptimaProfile{2}=localOptimaProfiler(21,params,1);
% calculations.localOptimaProfile{2}.color='c:';


%% enter conditions preparation

calculations.dsma5=(calculations.indicators.SMA5-[calculations.indicators.SMA5(1);calculations.indicators.SMA5(1);calculations.indicators.SMA5(1);calculations.indicators.SMA5(1);calculations.indicators.SMA5(1);calculations.indicators.SMA5(1:end-5)])*100./params.TimeTables.Minute.Close;
calculations.ddsma5=calculations.dsma5-[calculations.dsma5(1);calculations.dsma5(1:end-1)];
    
absolutevolumethresh=median(params.TimeTables.Week.Volume)/390;

calculations.dcs{1}=largedcandle(params.TimeTables.Minute);
calculations.dvs{1}=largedvol(params.TimeTables.Minute,0.1);
[calculations.rvs{1},calculations.avs{1}]=largevolume(params.TimeTables.Minute,1*ones(size(params.TimeTables.Minute.Volume)),absolutevolumethresh); 
calculations.bounce{1}=largebounce(params.TimeTables.Minute,mindis,calculations.dvs{1}.fight);

t2m=gen2mfrom1m(params.TimeTables.Minute);
calculations.dcs{2}=largedcandle(t2m);
calculations.dvs{2}=largedvol(t2m,0.1);
[calculations.rvs{2},calculations.avs{2}]=largevolume(t2m,1*ones(size(params.TimeTables.Minute.Volume)),absolutevolumethresh);
calculations.bounce{2}=largebounce(t2m,mindis,calculations.dvs{2}.fight);

%% exit conditions preparation

%% enter conditions

calculations.minDisProfile=getsignedmindis(params.TimeTables.Minute.Close,calculations.levels.values);

fromUpperLevelPercent=(abs(calculations.minDisProfile.mindis{1}))*100./params.TimeTables.Minute.Close;
fromLowerLevelPercent=(abs(calculations.minDisProfile.mindis{2}))*100./params.TimeTables.Minute.Close;

%upNextLevelPercent=(lxupNext - params.TimeTables.Minute.Close)*100./params.TimeTables.Minute.Close;
upcond_goodnextlevel=fromUpperLevelPercent>params.thresh.minNextLvlByPercent;%NextLevelPercent >params.thresh.minNextLvlByPercent;

%dnNextLevelPercent=(lxdnNext - params.TimeTables.Minute.Close)*100./params.TimeTables.Minute.Close;
dncond_goodnextlevel=fromLowerLevelPercent>params.thresh.minNextLvlByPercent;% dnNextLevelPercent >params.thresh.minNextLvlByPercent;

candle_up=params.TimeTables.Minute.Close>params.TimeTables.Minute.Open;
higherthanhighprev=params.TimeTables.Minute.High>shift(params.TimeTables.Minute.High,1);
lowerthanlowprev=params.TimeTables.Minute.Low<shift(params.TimeTables.Minute.Low,1);

for i=1:2
fightup{i}=(calculations.bounce{i}.up | calculations.dcs{i}.fight>params.thresh.dcs.fight.min | shift(calculations.dcs{i}.fight,1)>params.thresh.dcs.fight.min);
fightdn{i}=(calculations.bounce{i}.dn | calculations.dcs{i}.fight<-params.thresh.dcs.fight.min | shift(calculations.dcs{i}.fight,1)<-params.thresh.dcs.fight.min);
vsgood{i}=(calculations.avs{i}>params.thresh.avs.min |calculations.rvs{i}>params.thresh.rvs.min);
end

dsma5low=calculations.dsma5<-params.thresh.dsma5.min;
dsma5high=calculations.dsma5>params.thresh.dsma5.min;
ddsma5high=calculations.ddsma5>params.thresh.ddsma5.min;
ddsma5low=calculations.ddsma5<-params.thresh.ddsma5.min;
hhp=(higherthanhighprev | shift(higherthanhighprev,1));
llp=(lowerthanlowprev | shift(lowerthanlowprev,1));

upcond_break=(calculations.avs{1}>params.thresh.avs.min.*lxupp |calculations.rvs{1}>params.thresh.rvs.min.*lxupp) ;% & dvs_close>params.thresh.dvs.close.min & dvs_open>params.thresh.dvs.open.min & dvs_total > params.thresh.dvs.total.min;
dncond_break=(calculations.avs{1}>params.thresh.avs.min.*lxdnp |calculations.rvs{1}>params.thresh.rvs.min.*lxdnp) ;% & dvs_close<-params.thresh.dvs.close.min & dvs_open<-params.thresh.dvs.open.min & dvs_total < -params.thresh.dvs.total.min;

condall=([upcond_goodnextlevel,upcond_break,lxups,... %1,2,3
     dncond_break,lxdns,... %4,5
     llp,fightup{1},candle_up,vsgood{1},dsma5low,ddsma5high,...%6,7,8,9,10,11
     hhp,fightdn{1},~candle_up,dsma5high,ddsma5low,... %12,13,14,15,16
     fightup{2},fightdn{2},vsgood{2},...%17,18,19
     dncond_goodnextlevel]); %20
    
cond11=[1,2,3,11,15];
cond12=[20,4,5,10,16];
cond21=[1,6,7,8,9,10,11];
cond22=[20,12,13,14,15,16,9];
cond31=[1,6,17,8,19,10,11];
cond32=[20,12,18,14,19,15,16];


calculations.up.cond(:,1)=min(condall(:,cond11),[],2);%(upcond_break_goodnextlevel & upcond_break & lxups)& dsma5high & ddsma5high;
calculations.dn.cond(:,1)=min(condall(:,cond12),[],2);%((dncond_break_goodnextlevel & dncond_break & lxdns)& dsma5low & ddsma5low;

calculations.up.cond(:,2)=min(condall(:,cond21),[],2);%(llp &  fightup{1} & candle_up & vsgood{1} & dsma5low  & ddsma5high;
calculations.dn.cond(:,2)=min(condall(:,cond22),[],2);%(hhp & fightdn{1} & ~candle_up & vsgood{1} & dsma5high  & ddsma5low;

calculations.up.cond(:,3)=min(condall(:,cond31),[],2);%(llp & fightup{2} & candle_up& vsgood{2} & dsma5low  & ddsma5high;
calculations.dn.cond(:,3)=min(condall(:,cond32),[],2);%(hhp & fightdn{2} & ~candle_up& vsgood{2} & dsma5high & ddsma5low;


%% conditiondetails

%% signals
condlen=size(calculations.up.cond,2);
cmul=(0:condlen-1)';
cmul=pow2(cmul);

cmul=cmul.*params.enabled;

%% exit conditions
% for now, I am going to cheat and find the maximum/minimum in the next x minutes

calculations.up.final=calculations.up.cond*cmul;
calculations.dn.final=calculations.dn.cond*cmul;

calculations.indicators{1}.eval.pbto=(calculations.up.final>0)  .*params.TimeTables.Minute.High;% .* lxups;
calculations.indicators{1}.eval.psto=(calculations.dn.final>0) .*params.TimeTables.Minute.Low;% lxdns;

end