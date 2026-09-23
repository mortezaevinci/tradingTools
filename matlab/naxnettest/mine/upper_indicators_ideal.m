function PredictionTable=upper_indicators_ideal(StockData_TimeTable)
zero=zeros(size(StockData_TimeTable.Close));
try
%Moving Average 3th - 6th Features
SMA5=movavg(StockData_TimeTable.Close,'linear',5);
SMA5(isnan(SMA5))=StockData_TimeTable.Open(1);
catch
    SMA5=zero;
end
try
SMA7 = movavg(StockData_TimeTable.Close,'linear',7);
SMA7(isnan(SMA7))=StockData_TimeTable.Open(1);
catch
    SMA7=zero;
end
try
SMA14 = movavg(StockData_TimeTable.Close,'linear',14);
SMA14(isnan(SMA14))=StockData_TimeTable.Open(1);
catch
    SMA14=zero;
end
try
SMA21 = movavg(StockData_TimeTable.Close,'linear',21);
SMA21(isnan(SMA21))=StockData_TimeTable.Open(1);
catch
    SMA21=zero;
end

NSMA5=normalizeQuote(SMA5);
NSMA7=normalizeQuote(SMA7);
NSMA14=normalizeQuote(SMA14);
NSMA21=normalizeQuote(SMA21);



try
%Exponential Moving Average 7 Feature
EMA7 = movavg(StockData_TimeTable.Close,'exponential',5);
catch
    EMA7=zero;
end
try

%Time Series Bollinger band 13-15 Features
[middle,upper,lower] = bollinger(StockData_TimeTable);
catch
    middle.Open=zero;
    upper.Open=zero;
    lower.Open=zero;
end
try

%Highest high 16 Features
highind = hhigh(StockData_TimeTable) ;
catch
    highind.HighestHigh=zero;
end
try
%Lowest low 17 Features
lowind = llow(StockData_TimeTable);
catch
    lowind.LowestLow=zero;
end
try
%Median Price 18 Features
MedIdx = medprice(StockData_TimeTable);
catch
    MedIdx.MedianPrice=zero;
end
try
%williams Accumulation/Distribution line 21 Features
willadidx = willad(StockData_TimeTable);
catch
    willadidx.WillAD=zero;
end

varnames={'SMA5','SMA7','SMA14','SMA21',...
    'NSMA5','NSMA7','NSMA14','NSMA21',...
    'EMA7',...
    'BBmiddle','BBupper','BBlower','HighestHigh',...
    'LowestLow','MedianIndex',...
    'WillAD'};

%As explained, price today will be used to predict the stock price tomorrow. Hence all the indicators move forward 1 date.
% Only Open price of stock will be considered as feature as it is the only price we know before opening market in the day.
% 1st data point will be removed as there does not have any value for their feature indicators.
PredictionTable = timetable(StockData_TimeTable.Date, ...
    SMA5, SMA7, SMA14,SMA21,...
    NSMA5, NSMA7, NSMA14, NSMA21,...
    EMA7,...
    middle.Open, upper.Open, lower.Open, highind.HighestHigh,...
    lowind.LowestLow, MedIdx.MedianPrice ,willadidx.WillAD,'VariableNames',varnames);

end