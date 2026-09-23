function [lower,upper]=lower_indicators_ideal(TimeTable)
   
    
    zero=zeros(size(TimeTable.Close));

%%upper indicators

try
    
try
%Moving Average 3th - 6th Features
sma5=movavg(StockData_TimeTable.Close,'linear',5);
sma5(isnan(sma5))=StockData_TimeTable.Open(1);
catch
    sma5=zero;
end
try
sma10 = movavg(StockData_TimeTable.Close,'linear',10);
sma10(isnan(sma10))=StockData_TimeTable.Open(1);
catch
    sma10=zero;
end
try
sma21 = movavg(StockData_TimeTable.Close,'linear',21);
sma21(isnan(sma21))=StockData_TimeTable.Open(1);
catch
    sma21=zero;
end
try
sma50 = movavg(StockData_TimeTable.Close,'linear',50);
sma50(isnan(sma50))=StockData_TimeTable.Open(1);
catch
    sma50=zero;
end

nsma5=normalizeQuote(sma5);
nsma10=normalizeQuote(sma10);
nsma21=normalizeQuote(sma21);
nsma50=normalizeQuote(sma50);



try
%Exponential Moving Average 7 Feature
EMA7 = movavg(StockData_TimeTable.Close,'exponential',7);
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

varnames={'sma5','sma10','sma21','sma50',...
    'nsma5','nsma10','nsma21','nsma50',...
    'EMA7',...
    'BBmiddle','BBupper','BBlower','HighestHigh',...
    'LowestLow','MedianIndex',...
    'WillAD'};

%As explained, price today will be used to predict the stock price tomorrow. Hence all the indicators move forward 1 date.
% Only Open price of stock will be considered as feature as it is the only price we know before opening market in the day.
% 1st data point will be removed as there does not have any value for their feature indicators.
upper = timetable(StockData_TimeTable.Date, ...
    sma5, sma10, sma21,sma50,...
    nsma5, nsma10, nsma21, nsma50,...
    EMA7,...
    middle.Open, upper.Open, lower.Open, highind.HighestHigh,...
    lowind.LowestLow, MedIdx.MedianPrice ,willadidx.WillAD,'VariableNames',varnames);

catch exception
     disp('upper indicators failed.');
      dumpReport('error.log', exception);
     upper=timetable(TimeTable.Date);
end

%% lower indicator

try

%Extract Technical Indicators
%Relative Strength Index 1st-3th Features


rsi5 = rsindex(TimeTable.Close,'WindowSize',7)/100;
rsi5(isnan(rsi5))=0.5;
catch
   rsi5=zero; 
end
try
rsi10 = rsindex(TimeTable.Close,'WindowSize',14)/100;
rsi10(isnan(rsi10))=0.5;
catch
   rsi10=zero; 
end
try
rsi21 = rsindex(TimeTable.Close,'WindowSize',21)/100;
rsi21(isnan(rsi21))=0.5;
catch
   rsi21=zero; 
end
try

%Moving Average Convergent/Divergent 8-9th Features
[MACDLine, signalLine]= macd(TimeTable.Close);
MACDLine(isnan(MACDLine))=0;
signalLine(isnan(signalLine))=0;
catch
  signalLine =zero; 
  MACDLine=zero;
end
try
%Negative Volume Index 10th Features
NVIind = negvolidx(TimeTable);
catch
  NVIind.NegativeVolume =zero; 
end
try
%Positive Volume Index 11th Features
PosVind = posvolidx(TimeTable);
catch
 PosVind.PositiveVolume  =zero; 
end
try
%Accumulation/Distribution OSciallator 12th Features
ADOsc = adosc(TimeTable);
catch
  ADOsc.ADOscillator =zero; 
end
try
%on-balance volume 19 Features
volumeIdx = onbalvol(TimeTable);
catch
  volumeIdx.OnBalanceVolume =zero; 
end
try
%Price and Volume Trend(PVT) 20 Features
pvtInd = pvtrend(TimeTable); 
catch
  pvtInd.PriceVolumeTrend =zero; 
end
try
%Ticket Return Series 22 Features
tt_tick2retidx = tick2ret(TimeTable);
a_tick2retidx=table2array(tt_tick2retidx);
a_tick2retidx=[zeros(1,size(a_tick2retidx,2));a_tick2retidx];
catch
  a_tick2retidx =zeros(size(TimeTable)); 
end
try
%Chaikin Volatility 23
volatility = chaikvolat(TimeTable);
volatility.ChaikinVolatility(isnan(volatility.ChaikinVolatility))=0;
catch
  volatility.ChaikinVolatility =zero; 
end
try
%Stochastic Oscillator 24
percentKnD = stochosc(TimeTable);
catch
   percentKnD.FastPercentK=zero; 
end
try
%Acceleration between times 25
acceleration = tsaccel(TimeTable);
catch
 acceleration.Open  =zero; 
end
try
%Momentum between times 26
momentum = tsmom(TimeTable);
catch
  momentum.Open =zero; 
end

%coming from upper


shiftedsma5=shift(upper.sma5,5);
dsma5=(upper.sma5-shiftedsma5)*(1)./params.TimeTables.Minute.Close;
dsma5(1:min(4,size(dsma5,1)),1)=0;
ddsma5=dsma5-[dsma5(1);dsma5(1:end-1)];


try

    
varnames={'rsi5','rsi10','rsi21',...
    'dsma5','ddsma5',...
    'MACD','signalLine',...
    'NVI','PVI','ADO',...
   'PriceVolumeTrend',...
    'OnBalanceVolume','tick2ret',...
    'ChaikinVolatility','FastPercentK','acceleration',...
    'momentum'};

%As explained, price today will be used to predict the stock price tomorrow. Hence all the indicators move forward 1 date.
% Only Open price of stock will be considered as feature as it is the only price we know before opening market in the day.
% 1st data point will be removed as there does not have any value for their feature indicators.
lower = timetable(TimeTable.Date, ...
rsi5, rsi10, rsi21,...
    dsma5,ddsma5,...
    MACDLine,signalLine,...
    NVIind.NegativeVolume, PosVind.PositiveVolume, ADOsc.ADOscillator,...
     pvtInd.PriceVolumeTrend,...
    volumeIdx.OnBalanceVolume, a_tick2retidx,...
    volatility.ChaikinVolatility, percentKnD.FastPercentK, acceleration.Open,...
    momentum.Open,'VariableNames',varnames);
catch exception
     disp('lower indicators failed.');
      dumpReport('error.log', exception);
     lower=timetable(TimeTable.Date);
end
end