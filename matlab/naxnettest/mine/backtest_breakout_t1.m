%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show
clear all

symbol='AMD';
date='20_05_22';

load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' intraday ' date '.mat']);
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' daily ' date '.mat']);
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' monthly ' date '.mat']);

TimeTables.Minute=table2timetable(tm);
TimeTables.Day=table2timetable(td);
TimeTables.Month=table2timetable(tmo);
tms=size(tm,1);

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

scalepercent=1.3;

scale_min=min(TimeTables.Minute.Close);
scale_max=max(TimeTables.Minute.Close);
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*scalepercent;
scale_max=scale_max+scale_d*scalepercent;

%LEVELS
%sve
msvepivots=SVEPivots(mc,mlh(2),mlh(1));
dsvepivots=SVEPivots(dc,dlh(2),dlh(1));
colors_svepivots={'g','g','g','p','r','r','r'};
dir_svepivots=[-1 -1 -1 0 1 1 1];
width_dsve=[1 1 1 1 1 1 1];
width_msve=[2 2 2 2 2 2 2];
%orb
orb=zeros(1,2);
if (size(TimeTables.Minute,1)>60) %60 minutes from star
     orb(2)=max(TimeTables.Minute.High(1:60));
     orb(1)=min(TimeTables.Minute.Low(1:60));
end
colors_orb={'r','g'};
dir_orb=[-1 1];
width_orb=[1 1];

%high/low of yesterday
%dlh
%roundlevels
%%old approach
rlvls=roundLevels(TimeTables.Minute.Close);
colors_rlvls={'k.', 'k.','k.','k.'};
dir_rlvls=[-1 1 -1 1];
width_rlvls=[1 1 1 1];



lvls=[msvepivots dsvepivots orb dlh];
colors_lvls=[colors_svepivots colors_svepivots colors_orb colors_dlh];
dir_lvls=[dir_svepivots dir_svepivots dir_orb dir_dlh];
width_lvls=[width_dsve width_msve width_orb width_dlh];

%%find crossings
lxup=zeros(tms,size(lvls,2)+size(rlvls,2));
lxdn=zeros(tms,size(lvls,2)+size(rlvls,2));
for i=1:size(lvls,2)
    [lxup(:,i),lxdn(:,i)]=crossPivot(TimeTables.Minute,[lvls(i);lvls(i)]);
end

for i=1:size(rlvls,2)
    [lxup(:,size(lvls,2)+i),lxdn(:,size(lvls,2)+i)]=crossPivot(TimeTables.Minute,rlvls(i));
end

lxups=max(lxup,[],2);
lxdns=max(lxdn,[],2);

gcf=figure;
%set(gcf,'color','b');
tiledlayout(2,1)
ax1=nexttile;
ylim([scale_min ,scale_max])
hold on;
for i=1:numel(lvls)
 plot([TimeTables.Minute.Date(1), TimeTables.Minute.Date(end)],[lvls(i),lvls(i)],colors_lvls{i},'linewidth',width_lvls(i));
end
for i=1:size(rlvls,2)
 plot(TimeTables.Minute.Date,rlvls(:,i),colors_rlvls{i},'linewidth',width_rlvls(i));
end
plot(TimeTables.Minute.Date,lxups,'^');
plot(TimeTables.Minute.Date,lxdns,'v');
candle(TimeTables.Minute);


% for i=1:7
% plot([0,tms],[dsvepivots(i),dsvepivots(i)],colors_svepivots(i));
% plot([0,tms],[msvepivots(i),msvepivots(i)],colors_svepivots(i),'linewidth',2);
% end
ylim([scale_min ,scale_max])
hold off;

ax2=nexttile;
bar(TimeTables.Minute.Date,TimeTables.Minute.Volume);
linkaxes([ax1 ax2],'x');