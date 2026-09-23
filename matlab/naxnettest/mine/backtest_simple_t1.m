%can possibly update tm data in real-time here, and show

clear all

filename='Z:\My files\Project trading\traderdata\data\AAPL intraday_week 20_05_22.mat';
%tr_train = timerange('2020-05-19' , '2020-05-20');
%tr_predict = timerange('2020-05-21' , '2020-05-22');

load(filename);

StockData_TimeTable=table2timetable(tm);

PredictionTable=indicators(StockData_TimeTable);

%to limit time
tr_train = timerange('2020-05-20' , '2020-05-21');
PredictionTable = PredictionTable(PredictionTable.Time(tr_train),:);

% Deal with missing data
PredictionTable(any(ismissing(PredictionTable),2),:)=[];

% Get the Open and Close Price Data for year 2016 & 2017
StockData_TimeTable_corrected = StockData_TimeTable(PredictionTable.Time,:);

Response=zeros(size(StockData_TimeTable_corrected,1),1);
%strategy

for i =1:height(StockData_TimeTable_corrected)
    if (i>1)
if (PredictionTable(i-1,:).rsi21<30 && PredictionTable(i,:).rsi21>=30)
    Response(i)=1;%"buy to open";
elseif (PredictionTable(i-1,:).rsi21>70 && PredictionTable(i,:).rsi21<=70)
    Response(i)=-1;%"sell to open";
elseif (PredictionTable(i-1,:).rsi21<70 && PredictionTable(i,:).rsi21>=70)
    Response(i)=0;   %close
elseif (PredictionTable(i-1,:).rsi21>30 && PredictionTable(i,:).rsi21<=30)
    Response(i)=0;  %close
else
    Response(i)=Response(i-1);
end
    end%i>1
end%for

returns=tick2ret(StockData_TimeTable_corrected.Close);
portReturns=returns.*Response(1:end-1);
sharpeRatio=sharpe(portReturns,0)*sqrt(252)
portValues=ret2tick(portReturns);

figure
subplot(3,1,1);
plot(StockData_TimeTable_corrected.Date,StockData_TimeTable_corrected.Close);

hold on;
plot(StockData_TimeTable_corrected.Date,(Response*5+StockData_TimeTable_corrected(1,:).Close))

subplot(3,1,2);
plot(StockData_TimeTable_corrected.Date,PredictionTable.rsi21);

subplot(3,1,3);
plot(StockData_TimeTable_corrected.Date,portValues);


returns=diff(StockData_TimeTable_corrected.Close);
portReturns=returns.*Response(1:end-1);
portValues=[0;cumsum(portReturns)];
diffreturnpercent=portValues(end)/StockData_TimeTable_corrected.Close(1);
disp(['P/L=' num2str(diffreturnpercent*100) '%']);

figure
subplot(3,1,1);
plot(StockData_TimeTable_corrected.Date,StockData_TimeTable_corrected.Close);
hold on;
plot(StockData_TimeTable_corrected.Date,(Response*5+StockData_TimeTable_corrected(1,:).Close))

subplot(3,1,2);
plot(StockData_TimeTable_corrected.Date,PredictionTable.rsi21);


subplot(3,1,3);
plot(StockData_TimeTable_corrected.Date,portValues);
