symbol1='AMD';
symbol2='SPY';

date='2020-08-10';

base='Z:\My files\Project trading\traderdata\data\';

fd1=[base symbol1 '\' symbol1 ' daily 1y ' date '.mat'];
fd2=[base symbol2 '\' symbol2 ' daily 1y ' date '.mat'];
fm1=[base symbol1 '\' symbol1 ' minute ' date '.mat'];
fm2=[base symbol2 '\' symbol2 ' minute ' date '.mat'];
load(fd1);
load(fm1);
td1=td;
tm1=tm;
ttd1=table2timetable(td1);
ttm1=table2timetable(tm1);
load(fd2);
td2=td;
load(fm2);
tm2=tm;
subplot(2,1,1);
plot(td2.Close,td1.Close,'b');
hold on;
plot(tm2.Close,tm1.Close,'r');
hold off;
subplot(2,1,2);
cndl5(ttm1);
ylim([min(ttm1.Low), max(ttm1.High)]);