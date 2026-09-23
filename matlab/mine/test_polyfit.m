base='Z:\My files\Project trading\traderdata\data\';
sym='SPY';
type='daily max';

date0='2020-12-18';

fn=[base sym '\' sym ' ' type ' ' date0 '.mat'];
load(fn);
ttd=table2timetable(td);

range=1:100;

ind=(1:numel(ttd.Date))';
p = polyfit(ind(range),ttd.Close(range),50);
y1 = polyval(p,ind);

f=figure;
ax=cndlv(ttd);
hold(ax{1},'on');
plot(ax{1},ttd.Date,y1);
