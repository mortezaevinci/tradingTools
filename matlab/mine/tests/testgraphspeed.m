load('z:\My files\Project Trading\traderdata\data\AAPL\AAPL minute 2020-08-17.mat')
tt=table2timetable(tm);
tic
layout=cndl5(tt);
toc
