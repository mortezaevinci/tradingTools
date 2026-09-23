%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show
clear all

%% SETUP

thresh.avs.min=.7;
thresh.rvs.min=0.4; 
thresh.dvs.open.min=0;0.2;
thresh.dvs.close.min=0;0.3;
thresh.dvs.total.min=0;0.5;0.5;
thresh.dsma5.min=0.05;
thresh.ddsma5.min=0;


showlimit=120;

%% DATA
symbol='SHOP';
date='20_05_22';

%% main tester

%if this line is commented out, the 5 day intraday week loads
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' intraday ' date '.mat']);

%% baseline data
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' daily ' date '.mat']);
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' monthly ' date '.mat']);
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' weekly ' date '.mat']);

TimeTables.Minute=table2timetable(tm);
TimeTables.Day=table2timetable(td);
TimeTables.Week=table2timetable(tw);
TimeTables.Month=table2timetable(tmo);

%% for testing
%TimeTables.Minute=TimeTables.Minute(1:363,:);

%% preperation

tms=size(TimeTables.Minute,1);


lastmonthquote=TimeTables.Month(end-2,:);
mc=lastmonthquote.Close;
mlh(1)=lastmonthquote.Low;
mlh(2)=lastmonthquote.High;

lastdayquote=TimeTables.Day(end-1,:);
dc=lastdayquote.Close;
dlh(1)=lastdayquote.Low;
dlh(2)=lastdayquote.High;
colors_dlh={'c', 'c'};
dir_dlh=[-1 1];
width_dlh=[1 1];
power_dlh=[1 1];

scalepercent=1.1 ;



%% update real-time could be lower, if orb level was done a bit differently

TimeTables.Minute=updaterealtime(symbol,TimeTables.Minute);


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
if (size(TimeTables.Minute,1)>60) %60 minutes from star
     orb(2)=max(TimeTables.Minute.High(1:60));
     orb(1)=min(TimeTables.Minute.Low(1:60));
end
colors_orb={'r','g'};
dir_orb=[-1 1];
width_orb=[1 1];
power_orb=[1 1];

%high/low of yesterday
%dlh
%roundlevels
%%old approach
%rlvls=roundLevels(TimeTables.Minute.Close);
%colors_rlvls={'k.', 'k.','k.','k.'};
%dir_rlvls=[-1 1 -1 1];
%width_rlvls=[1 1 1 1];
[hlvls,llvls]=roundLevelsAll(TimeTables.Minute);
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


lvls=[dsvepivots msvepivots orb dlh rlvls];
colors_lvls=[colors_svepivots colors_svepivots colors_orb colors_dlh colors_rlvls];
dir_lvls=[dir_svepivots dir_svepivots dir_orb dir_dlh dir_rlvls];
width_lvls=[width_dsve width_msve width_orb width_dlh width_rlvls];
power_lvls=[power_dsve power_msve power_orb power_dlh power_rlvls];

% sort levels for later additional analysis
[~,sindex]=sort(lvls);
lvls=lvls(sindex);
colors_lvls=colors_lvls(sindex);
dir_lvls=dir_lvls(sindex);
width_lvls=width_lvls(sindex);
power_lvls=power_lvls(sindex);

%%find crossings
lxup=zeros(tms,size(lvls,2));
lxdn=zeros(tms,size(lvls,2));
for i=1:size(lvls,2)
    [lxup(:,i),lxdn(:,i)]=crossPivot(TimeTables.Minute,lvls(i));
end

[lxups,lxupi]=max(lxup,[],2);
[lxdns,lxdni]=max(lxdn,[],2);

%power of levels to corss.. not used for now
lxupp=power_lvls(lxupi)';
lxdnp=power_lvls(lxdni)';

%% INDICATORS

PredictionTable=indicators_ideal(TimeTables.Minute);
[mindis,mindislvl]=getmindiscomplex(TimeTables.Minute,lvls);

se = strel('line',7,90);
hh = imdilate(TimeTables.Minute.High,se);
ll = imerode(TimeTables.Minute.Low,se);

islocaloptima{1}=ll==TimeTables.Minute.Low;%islocalmin(TimeTables.Minute.Low);
islocaloptima{2}=hh==TimeTables.Minute.High;%islocalmax(TimeTables.Minute.High);
localoptima{1}=islocaloptima{1}.*TimeTables.Minute.Low;
localoptima{2}=islocaloptima{2}.*TimeTables.Minute.High;

profilebinsize=15;
profilebindivider=10;

for i=1:2
    binindex{i}=find(localoptima{i});
   binlocaloptima{i}= localoptima{i}(binindex{i});
 [profileN{i},profileEdges{i}] = histcounts(binlocaloptima{i},profilebinsize);
end

[buyv,sellv]=buysellVolume(TimeTables.Minute,0);

%% profile levels (this one has to update in real-time)
for i=1:2
thresh_=numel(binlocaloptima{i})/profilebindivider;
profileLevels{i}=profileEdges{i}(profileN{i}>thresh_);
wp_{i}=profileN{i}(profileN{i}>thresh_)/thresh_/2;
end
profilelvls=[profileLevels{1} profileLevels{2}];
width_plvls=[wp_{1} wp_{2}];
%% enter conditions preparation

dsma5=(PredictionTable.SMA5-[PredictionTable.SMA5(1);PredictionTable.SMA5(1);PredictionTable.SMA5(1);PredictionTable.SMA5(1);PredictionTable.SMA5(1);PredictionTable.SMA5(1:end-5)])*100./TimeTables.Minute.Close;
ddsma5=dsma5-[dsma5(1);dsma5(1:end-1)];
    
absolutevolumethresh=median(TimeTables.Week.Volume)/390;

[dcs_close,dcs_open,dcs_total,dcs_fight]=largedcandle(TimeTables.Minute);
[dvs_close,dvs_open,dvs_total,dvs_fight]=largedvol(TimeTables.Minute,0.1);
[rvs,avs]=largevolume(TimeTables.Minute,1*ones(size(TimeTables.Minute.Volume)),absolutevolumethresh); 
[upbounce,dnbounce]=largebounce(TimeTables.Minute,mindis,dvs_fight);

t2m=gen2mfrom1m(TimeTables.Minute);
[dcs_close2,dcs_open2,dcs_total2,dcs_fight2]=largedcandle(t2m);
[dvs_close2,dvs_open2,dvs_total2,dvs_fight2]=largedvol(t2m,0.1);
[rvs2,avs2]=largevolume(t2m,1*ones(size(TimeTables.Minute.Volume)),absolutevolumethresh);
[upbounce2,dnbounce2]=largebounce(t2m,mindis,dvs_fight2);

%% exit conditions preparation

forwardWindow=15;
mmax=100*(movmax(TimeTables.Minute.Close,[0 forwardWindow])-TimeTables.Minute.Close)./TimeTables.Minute.Close;
mmin=100*(movmin(TimeTables.Minute.Close,[0 forwardWindow])-TimeTables.Minute.Close)./TimeTables.Minute.Close;

%% enter conditions

upcond_break=(avs>thresh.avs.min.*lxupp |rvs>thresh.rvs.min.*lxupp) & dsma5>thresh.dsma5.min & ddsma5>thresh.ddsma5.min;% & dvs_close>thresh.dvs.close.min & dvs_open>thresh.dvs.open.min & dvs_total > thresh.dvs.total.min;
dncond_break=(avs>thresh.avs.min.*lxdnp |rvs>thresh.rvs.min.*lxdnp) & dsma5<-thresh.dsma5.min & ddsma5<-thresh.ddsma5.min;% & dvs_close<-thresh.dvs.close.min & dvs_open<-thresh.dvs.open.min & dvs_total < -thresh.dvs.total.min;

upcond(:,1)=(upcond_break & lxups);
dncond(:,1)=(dncond_break & lxdns);

upcond(:,2)=(upbounce | dcs_fight>1) &(avs>thresh.avs.min |rvs>thresh.rvs.min) & dsma5<-thresh.dsma5.min  & ddsma5>thresh.ddsma5.min;
dncond(:,2)=(dnbounce | dcs_fight<-1) &(avs>thresh.avs.min |rvs>thresh.rvs.min)& dsma5>thresh.dsma5.min  & ddsma5<-thresh.ddsma5.min;

upcond(:,3)=(upbounce2| dcs_fight2>1) &(avs>thresh.avs.min |rvs>thresh.rvs.min)& dsma5<-thresh.dsma5.min  & ddsma5>thresh.ddsma5.min;
dncond(:,3)=(dnbounce2 | dcs_fight2<-1)&(avs>thresh.avs.min |rvs>thresh.rvs.min)& dsma5>thresh.dsma5.min & ddsma5<-thresh.ddsma5.min;

%% signals
condlen=size(upcond,2);
cmul=(0:condlen-1)';
cmul=pow2(cmul);

enabled=[1;1;1];
cmul=cmul.*enabled;

upc=upcond*cmul;
dnc=dncond*cmul;

pbto=(upc>0)  .*TimeTables.Minute.High;% .* lxups;
psto=(dnc>0) .*TimeTables.Minute.Low;% lxdns;

%% exit conditions
% for now, I am going to cheat and find the maximum/minimum in the next x minutes

success_bto=(pbto>0).*mmax;
success_sto=-(psto>0).*mmin;

success=sum(success_bto)+sum(success_sto)

%% volume graph

if(showlimit>0)
showlimit=min(showlimit,numel(TimeTables.Minute.Date)-1);
genericrange=(numel(TimeTables.Minute.Date)-showlimit):numel(TimeTables.Minute.Date);
else
genericrange=1:numel(TimeTables.Minute.Date);
end
scale_min=min(TimeTables.Minute.Close(genericrange));
scale_max=max(TimeTables.Minute.Close(genericrange));
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*scalepercent;
scale_max=scale_max+scale_d*scalepercent;

load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' intraday_week ' date '.mat']);
TimeTables.Minute5d=table2timetable(tm);

gcf=figure('units','normalized','outerposition',[0 0 1 1]);
%set(gcf,'color','b');
tlt=tiledlayout(10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";

ax0=nexttile([7 1]);
volumeprofile(TimeTables.Minute5d);
ax1=nexttile([7 9]);
linkaxes([ax1 ax0],'y');
ylim([scale_min ,scale_max])
hold on;

for i=1:numel(profilelvls)
 plot([TimeTables.Minute.Date(end-showlimit), TimeTables.Minute.Date(end)],[profilelvls(i),profilelvls(i)],'y--','linewidth',min(4,width_plvls(i)));
end
for i=1:numel(lvls)
 plot([TimeTables.Minute.Date(end-showlimit), TimeTables.Minute.Date(end)],[lvls(i),lvls(i)],colors_lvls{i},'linewidth',width_lvls(i));
end
plot(TimeTables.Minute.Date(genericrange),pbto(genericrange)*1.001,'c^','linewidth',4);
plot(TimeTables.Minute.Date(genericrange),psto(genericrange)*0.999,'cv','linewidth',4);

cndl4(TimeTables.Minute(genericrange,:));
grid on;
hold on;

text(TimeTables.Minute.Date(genericrange),pbto(genericrange)*1.001,num2str(upc(genericrange)));
text(TimeTables.Minute.Date(genericrange),psto(genericrange)*0.999,num2str(dnc(genericrange)));
%text(TimeTables.Minute.Date,pbto*1.01,num2str(success_bto));
%text(TimeTables.Minute.Date,psto*.99,num2str(success_sto));

plot(TimeTables.Minute.Date(genericrange),localoptima{1}(genericrange),'k.');
plot(TimeTables.Minute.Date(genericrange),localoptima{2}(genericrange),'k.');

% for i=1:7
% plot([0,tms],[dsvepivots(i),dsvepivots(i)],colors_svepivots(i));
% plot([0,tms],[msvepivots(i),msvepivots(i)],colors_svepivots(i),'linewidth',2);
% end
%ylim([scale_min ,scale_max])
hold off;

pvs=(upcond | dncond).*TimeTables.Minute.Volume;
pvs(pvs==0)=NaN;
nexttile([1 1]);
ax2=nexttile([1 9]);
bar(TimeTables.Minute.Date(genericrange),TimeTables.Minute.Volume(genericrange),'g');
grid on;
hold on;
bar(TimeTables.Minute.Date(genericrange),sellv(genericrange),'r');
plot(TimeTables.Minute.Date(genericrange),pvs(genericrange),'*b');
hold off;

nexttile([1 1]);
ax3=nexttile([1 9]);
plot(TimeTables.Minute.Date(genericrange),dsma5(genericrange));
grid on;
nexttile([1 1]);
ax4=nexttile([1 9]);
plot(TimeTables.Minute.Date(genericrange),ddsma5(genericrange));
grid on;
linkaxes([ax1 ax2 ax3 ax4],'x');
