base='Z:\My files\Project trading\traderdata\data_other\IB\';
symbol='KERN';

date='2020-12-31';

types={'daily 1y','dailyx1y'};

for i=1:2
fn=[base symbol '\' symbol ' ' types{i} ' ' date '.mat'];

load(fn)
ttd{i}=table2timetable(td);

disp(['size of ' num2str(i) ' = ' num2str(size(ttd{i}))]);
figure;
cndlv(ttd{i});
title(types{i});
end

dates=intersect(ttd{1}.Date,ttd{2}.Date);
ttd{1}=ttd{1}(dates,:);
ttd{2}=ttd{2}(dates,:);

voldiff=ttd{2}.Volume-ttd{1}.Volume;



smaLength=10;
outlierMultiplier=2;
atrMultiplier=2;
aveDiffVol = movmean(shiftpad(voldiff,1),[smaLength 0]);
movMaxDiffVol = movmax(shiftpad(voldiff,1),[smaLength 0]);
[atr,tr]=indicators_atr(shiftpad(ttd{2},1),smaLength);
aveClose= movmean(shiftpad(ttd{2}.Close,1),[smaLength 0]);
matr=atrMultiplier*atr;
thVol=aveDiffVol*outlierMultiplier;
thClose=aveClose+matr;
thAbsVol=20000;

entry=voldiff> movMaxDiffVol & voldiff>thAbsVol ...
& voldiff>thVol & ttd{2}.High>thClose;
eplot=entry.*thClose;

figure
ttd{2}.Volume=voldiff;
ax=cndlv(ttd{2});
axes(ax{2}); hold on ;
plot(ttd{2}.Date,thVol);
plot(ttd{2}.Date,movMaxDiffVol);
axes(ax{1}); hold on ;
plot(ttd{2}.Date,aveClose+matr);
plot(ttd{2}.Date,aveClose-matr);
plot(ttd{2}.Date,eplot,'r+');

