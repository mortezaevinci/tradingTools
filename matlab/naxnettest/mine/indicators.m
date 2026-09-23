function PredictionTable=indicators(StockData_TimeTable)

%Extract Technical Indicators
%Relative Strength Index 1st-3th Features
rsi7 = rsindex(StockData_TimeTable.Close,'WindowSize',7);
rsi14 = rsindex(StockData_TimeTable.Close,'WindowSize',14);
rsi21 = rsindex(StockData_TimeTable.Close,'WindowSize',21);
%Moving Average 3th - 6th Features
SMA5=movavg(StockData_TimeTable.Close,'linear',5);
SMA7 = movavg(StockData_TimeTable.Close,'linear',7);
SMA14 = movavg(StockData_TimeTable.Close,'linear',14);
SMA21 = movavg(StockData_TimeTable.Close,'linear',21);
%Exponential Moving Average 7 Feature
EMA7 = movavg(StockData_TimeTable.Close,'exponential',7);
%Moving Average Convergent/Divergent 8-9th Features
[MACDLine, signalLine]= macd(StockData_TimeTable.Close);
%Negative Volume Index 10th Features
NVIind = negvolidx(StockData_TimeTable);
%Positive Volume Index 11th Features
PosVind = posvolidx(StockData_TimeTable);
%Accumulation/Distribution OSciallator 12th Features
ADOsc = adosc(StockData_TimeTable);
%Time Series Bollinger band 13-15 Features
[middle,upper,lower] = bollinger(StockData_TimeTable);
%Highest high 16 Features
highind = hhigh(StockData_TimeTable) ;
%Lowest low 17 Features
lowind = llow(StockData_TimeTable);
%Median Price 18 Features
MedIdx = medprice(StockData_TimeTable);
%on-balance volume 19 Features
volumeIdx = onbalvol(StockData_TimeTable);
%Price and Volume Trend(PVT) 20 Features
pvtInd = pvtrend(StockData_TimeTable); 
%williams Accumulation/Distribution line 21 Features
willadidx = willad(StockData_TimeTable);
%Ticket Return Series 22 Features
tick2retidx = tick2ret(StockData_TimeTable);
%Chaikin Volatility 23
volatility = chaikvolat(StockData_TimeTable);
%Stochastic Oscillator 24
percentKnD = stochosc(StockData_TimeTable);
%Acceleration between times 25
acceleration = tsaccel(StockData_TimeTable);
%Momentum between times 26
momentum = tsmom(StockData_TimeTable);

rsi7=rsi7(1:end-1);
rsi14 = rsi14(1:end-1);%;
rsi21 = rsi21(1:end-1);%;
%Moving Average 3th - 6th Features
SMA5 = SMA5(1:end-1);%movavg(StockData_TimeTable.Close,'linear',3);
SMA7 = SMA7(1:end-1);%movavg(StockData_TimeTable.Close,'linear',5);
SMA14 = SMA14(1:end-1);%movavg(StockData_TimeTable.Close,'linear',10);
SMA21=SMA21(1:end-1);

%Exponential Moving Average 7 Feature
EMA7 = EMA7(1:end-1);%movavg(StockData_TimeTable.Close,'exponential',7);
%Moving Average Convergent/Divergent 8-9th Features
[MACDLine, signalLine]= macd(StockData_TimeTable.Close);
MACDLine=MACDLine(1:end-1);%
signalLine=signalLine(1:end-1);%
%Negative Volume Index 10th Features
NVIind = NVIind(1:end-1,:);%negvolidx(StockData_TimeTable);
%Positive Volume Index 11th Features
PosVind =PosVind(1:end-1,:);% posvolidx(StockData_TimeTable);
%Accumulation/Distribution OSciallator 12th Features
ADOsc =ADOsc(1:end-1,:);% adosc(StockData_TimeTable);
%Time Series Bollinger band 13-15 Features
[middle,upper,lower] = bollinger(StockData_TimeTable);
middle=middle(1:end-1,:);%
upper=upper(1:end-1,:);%
lower=lower(1:end-1,:);%
%Highest high 16 Features
highind = highind(1:end-1,:);%hhigh(StockData_TimeTable) ;

%Lowest low 17 Features
lowind = lowind(1:end-1,:);%llow(StockData_TimeTable);
%Median Price 18 Features
MedIdx =MedIdx(1:end-1,:);% medprice(StockData_TimeTable);
%on-balance volume 19 Features
volumeIdx =volumeIdx(1:end-1,:);% onbalvol(StockData_TimeTable);
%Price and Volume Trend(PVT) 20 Features
pvtInd =pvtInd(1:end-1,:);% pvtrend(StockData_TimeTable); 
%williams Accumulation/Distribution line 21 Features
willadidx = willadidx(1:end-1,:);%willad(StockData_TimeTable);
%Ticket Return Series 22 Features
tick2retidx = tick2retidx(1:end,:);%tick2ret(StockData_TimeTable);
%Chaikin Volatility 23
volatility =volatility(1:end-1,:);% chaikvolat(StockData_TimeTable);
%Stochastic Oscillator 24
percentKnD =percentKnD(1:end-1,:);% stochosc(StockData_TimeTable);
%Acceleration between times 25
acceleration =acceleration(1:end-1,:);% tsaccel(StockData_TimeTable);
%Momentum between times 26
momentum =momentum(1:end-1,:);% tsmom(StockData_TimeTable);

varnames={'rsi7','rsi14','rsi21',...
    'SMA5','SMA7','SMA14','SMA21',...
    'EMA7','MACD','signalLine',...
    'NVI','PVI','ADO',...
    'BBmiddle','BBupper','BBlower','HighestHigh',...
    'LowestLow','MedianIndex','PriceVolumeTrend',...
    'OnBalanceVolume','WillAD','tick2ret',...
    'ChaikinVolatility','FastPercentK','acceleration',...
    'momentum','Open'};

%As explained, price today will be used to predict the stock price tomorrow. Hence all the indicators move forward 1 date.
% Only Open price of stock will be considered as feature as it is the only price we know before opening market in the day.
% 1st data point will be removed as there does not have any value for their feature indicators.
PredictionTable = timetable(StockData_TimeTable.Date(2:end), ...
rsi7, rsi14, rsi21,...
    SMA5, SMA7, SMA14,SMA21,...
    EMA7,MACDLine,signalLine,...
    NVIind.NegativeVolume, PosVind.PositiveVolume, ADOsc.ADOscillator,...
    middle.Open, upper.Open, lower.Open, highind.HighestHigh,...
    lowind.LowestLow, MedIdx.MedianPrice ,pvtInd.PriceVolumeTrend,...
    volumeIdx.OnBalanceVolume, willadidx.WillAD, tick2retidx.Open,...
    volatility.ChaikinVolatility, percentKnD.FastPercentK, acceleration.Open,...
    momentum.Open, StockData_TimeTable.Open(2:end),'VariableNames',varnames);

end