function calculations=strategy_breakout_t1(params)

% 
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

%% for testing
if (params.processlimit>0)
proclimit_=min(params.processlimit,numel(params.TimeTables.Minute.Date)-1);
params.TimeTables.Minute=params.TimeTables.Minute(end-proclimit_:end,:);
end
%% preperation

tms=size(params.TimeTables.Minute,1);

lastmonthquote=params.TimeTables.Month(end-2,:);
mc=lastmonthquote.Close;
mlh(1)=lastmonthquote.Low;
mlh(2)=lastmonthquote.High;

lastdayquote=params.TimeTables.Day(end-1,:);
dc=lastdayquote.Close;
dlh(1)=lastdayquote.Low;
dlh(2)=lastdayquote.High;
colors_dlh={'c', 'c'};
dir_dlh=[-1 1];
width_dlh=[1 1];
power_dlh=[1 1];




%% LEVELS
%sve
msvepivots=SVEPivots(mc,mlh(2),mlh(1));
dsvepivots=SVEPivots(dc,dlh(2),dlh(1));
colors_svepivots={'g','g','g','m','r','r','r'};
dir_svepivots=[-1 -1 -1 0 1 1 1];
width_dsve=[1 1 1 1 1 1 1];
width_msve=[3 3 3 3 3 3 3];
power_dsve=[1 1 1 1 1 1 1];
power_msve=[2 2 2 2 2 2 2];
%orb
orb=zeros(1,2);
if (size(params.TimeTables.Minute,1)>60) %60 minutes from star
     orb(2)=max(params.TimeTables.Minute.High(1:60));
     orb(1)=min(params.TimeTables.Minute.Low(1:60));
end
colors_orb={'r','g'};
dir_orb=[-1 1];
width_orb=[1 1];
power_orb=[1 1];

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


calculations.levels.values=[dsvepivots msvepivots orb dlh rlvls];
calculations.levels.color=[colors_svepivots colors_svepivots colors_orb colors_dlh colors_rlvls];
calculations.levels.direction=[dir_svepivots dir_svepivots dir_orb dir_dlh dir_rlvls];
calculations.levels.width=[width_dsve width_msve width_orb width_dlh width_rlvls];
calculations.levels.power=[power_dsve power_msve power_orb power_dlh power_rlvls];

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
for i=1:size(calculations.levels.values,2)
    [lxup(:,i),lxdn(:,i)]=crossPivot(params.TimeTables.Minute,calculations.levels.values(i));
end

[lxups,lxupi]=max(lxup,[],2);
[lxdns,lxdni]=max(lxdn,[],2);

%power of levels to corss.. not used for now
lxupp=calculations.levels.power(lxupi)';
lxdnp=calculations.levels.power(lxdni)';

%% INDICATORS

calculations.indicators=indicators_ideal(params.TimeTables.Minute);
[mindis,mindislvl]=getmindiscomplex(params.TimeTables.Minute,calculations.levels.values);

se = strel('line',7,90);
hh = imdilate(params.TimeTables.Minute.High,se);
ll = imerode(params.TimeTables.Minute.Low,se);

islocaloptima{1}=ll==params.TimeTables.Minute.Low;%islocalmin(params.TimeTables.Minute.Low);
islocaloptima{2}=hh==params.TimeTables.Minute.High;%islocalmax(params.TimeTables.Minute.High);
calculations.localoptima{1}=islocaloptima{1}.*params.TimeTables.Minute.Low;
calculations.localoptima{2}=islocaloptima{2}.*params.TimeTables.Minute.High;

profilebinsize=15;
profilebindivider=10;

for i=1:2
    binindex{i}=find(calculations.localoptima{i});
   binlocaloptima{i}= calculations.localoptima{i}(binindex{i});
 [profileN{i},profileEdges{i}] = histcounts(binlocaloptima{i},profilebinsize);
end

[calculations.buyv,calculations.sellv]=buysellVolume(params.TimeTables.Minute,0);

%% profile levels (this one has to update in real-time)
for i=1:2
params.thresh_=numel(binlocaloptima{i})/profilebindivider;
profileLevels_{i}=profileEdges{i}(profileN{i}>params.thresh_);
wp_{i}=profileN{i}(profileN{i}>params.thresh_)/params.thresh_/2;
end
calculations.profilelvls=[profileLevels_{1} profileLevels_{2}];
calculations.width_plvls=[wp_{1} wp_{2}];
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

upcond_break=(calculations.avs{1}>params.thresh.avs.min.*lxupp |calculations.rvs{1}>params.thresh.rvs.min.*lxupp) & calculations.dsma5>params.thresh.dsma5.min & calculations.ddsma5>params.thresh.ddsma5.min;% & dvs_close>params.thresh.dvs.close.min & dvs_open>params.thresh.dvs.open.min & dvs_total > params.thresh.dvs.total.min;
dncond_break=(calculations.avs{1}>params.thresh.avs.min.*lxdnp |calculations.rvs{1}>params.thresh.rvs.min.*lxdnp) & calculations.dsma5<-params.thresh.dsma5.min & calculations.ddsma5<-params.thresh.ddsma5.min;% & dvs_close<-params.thresh.dvs.close.min & dvs_open<-params.thresh.dvs.open.min & dvs_total < -params.thresh.dvs.total.min;

calculations.upcond(:,1)=(upcond_break & lxups);
calculations.dncond(:,1)=(dncond_break & lxdns);

calculations.upcond(:,2)=(calculations.bounce{1}.up | calculations.dcs{1}.fight>1) &(calculations.avs{1}>params.thresh.avs.min |calculations.rvs{1}>params.thresh.rvs.min) & calculations.dsma5<-params.thresh.dsma5.min  & calculations.ddsma5>params.thresh.ddsma5.min;
calculations.dncond(:,2)=(calculations.bounce{1}.dn | calculations.dcs{1}.fight<-1) &(calculations.avs{1}>params.thresh.avs.min |calculations.rvs{1}>params.thresh.rvs.min)& calculations.dsma5>params.thresh.dsma5.min  & calculations.ddsma5<-params.thresh.ddsma5.min;

calculations.upcond(:,3)=(calculations.bounce{2}.up| calculations.dcs{2}.fight>1) &(calculations.avs{2}>params.thresh.avs.min |calculations.rvs{2}>params.thresh.rvs.min)& calculations.dsma5<-params.thresh.dsma5.min  & calculations.ddsma5>params.thresh.ddsma5.min;
calculations.dncond(:,3)=(calculations.bounce{2}.dn | calculations.dcs{2}.fight<-1)&(calculations.avs{2}>params.thresh.avs.min |calculations.rvs{2}>params.thresh.rvs.min)& calculations.dsma5>params.thresh.dsma5.min & calculations.ddsma5<-params.thresh.ddsma5.min;

%% signals
condlen=size(calculations.upcond,2);
cmul=(0:condlen-1)';
cmul=pow2(cmul);

cmul=cmul.*params.enabled;

%% exit conditions
% for now, I am going to cheat and find the maximum/minimum in the next x minutes

calculations.upc=calculations.upcond*cmul;
calculations.dnc=calculations.dncond*cmul;

calculations.indicators{1}.eval.pbto=(calculations.upc>0)  .*params.TimeTables.Minute.High;% .* lxups;
calculations.indicators{1}.eval.psto=(calculations.dnc>0) .*params.TimeTables.Minute.Low;% lxdns;

end