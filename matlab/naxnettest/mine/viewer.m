%can possibly update tm data in real-time here, and show


filename='Z:\My files\Project trading\traderdata\data\AAPL 20_05_22.mat';
tr_train = timerange('2020-05-19' , '2020-05-20');
tr_predict = timerange('2020-05-21' , '2020-05-22');



load(filename);


candle(tm(end-200:end,:));

StockData_TimeTable=table2timetable(tm);


