load('z:\My files\Project Trading\traderdata\data\AAPL\AAPL minute 2020-08-20.mat');

h=figure;
opengl hardware
set(h,'Renderer','OpenGL');

tt=table2timetable(tm);
tic
layout=cndl5(tt);
ylim([min(tt.Low)*.8,max(tt.High)*1.2]);
toc

load('z:\My files\Project Trading\traderdata\data\AAPL\AAPL minute 2020-08-21.mat');
tt=table2timetable(tm);

tic
cndl5layout(tt,layout);
toc
tic
drawnow
toc