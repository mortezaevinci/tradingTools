%close all

for i=1:numel(bearishList_over1)
    try
    bl=bearishList_over1(i);
    symbol=bl.symbol;
fn=[basedir symbol '\' symbol ' minute ' date '.mat'];load(fn);
params.TimeTables.Minute=table2timetable(tm);
fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];load(fn);
params.TimeTables.Day=table2timetable(td);

h=figure;
tlt=tiledlayout(h,1,2);
tlt.Padding = "none";
tlt.TileSpacing = "none";
tiled=nexttile(tlt,[1 1]);

cndl5(params.TimeTables.Day(end-30:end,:));

tilem=nexttile(tlt,[1 1]);
linkaxes([tiled tilem],'y');


target=bl.target;%params.TimeTables.Minute.Open(1)+bl.expectedmove;

cndl5(params.TimeTables.Minute);
ylim([min(target*0.99,min(params.TimeTables.Minute.Low)),max(target*1.01,max(params.TimeTables.Minute.High))]);
hold on;

plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(1).STP,bl.orders_(1).STP],'b');
plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(1).LMT,bl.orders_(1).LMT],'b--');
plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(2).LMT,bl.orders_(2).LMT],'g');
plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(3).STP,bl.orders_(3).STP],'r');
title(symbol);
    catch exception
     
    end
end

for i=1:numel(bullishList_over1)
    try
    bl=bullishList_over1(i);
    symbol=bl.symbol
fn=[basedir symbol '\' symbol ' minute ' date '.mat'];load(fn);
params.TimeTables.Minute=table2timetable(tm);
fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];load(fn);
params.TimeTables.Day=table2timetable(td);

h=figure;
tlt=tiledlayout(h,1,2);
tlt.Padding = "none";
tlt.TileSpacing = "none";
tiled=nexttile(tlt,[1 1]);

cndl5(params.TimeTables.Day(end-30:end,:));

tilem=nexttile(tlt,[1 1]);
linkaxes([tiled tilem],'y');

target=bl.target;%params.TimeTables.Minute.Open(1)+bl.expectedmove;

cndl5(params.TimeTables.Minute);
ylim([min([target*0.99,bl.loss*0.99,min(params.TimeTables.Minute.Low)]),max([target*1.01,bl.loss*1.01,max(params.TimeTables.Minute.High)])]);
hold on;

plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(1).STP,bl.orders_(1).STP],'b');
plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(1).LMT,bl.orders_(1).LMT],'b--');
plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(2).LMT,bl.orders_(2).LMT],'g');
plot([params.TimeTables.Minute.Date(1) params.TimeTables.Minute.Date(end)],[bl.orders_(3).STP,bl.orders_(3).STP],'r');
title([symbol,',',num2str(bl.orders_(3).STP),',',num2str(bl.orders_(1).STP),',',num2str(bl.orders_(2).LMT)]);
    catch exception
      
    end
end