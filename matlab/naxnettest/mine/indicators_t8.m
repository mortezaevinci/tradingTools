function [lower,upper]=lower_indicators_ideal(TimeTable)
   
    
    zero=zeros(size(TimeTable.Close));

%%upper indicators

try
    
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
upper = timetable(StockData_TimeTable.Date, ...
    SMA5, SMA7, SMA14,SMA21,...
    NSMA5, NSMA7, NSMA14, NSMA21,...
    EMA7,...
    middle.Open, upper.Open, lower.Open, highind.HighestHigh,...
    lowind.LowestLow, MedIdx.MedianPrice ,willadidx.WillAD,'VariableNames',varnames);

catch exception
     disp('upper indicators failed.');
      getReport(exception,'extended','hyperlinks','off');
     upper=timetable(TimeTable.Date);
end

%% lower indicator

try

%Extract Technical Indicators
%Relative Strength Index 1st-3th Features


rsi7 = rsindex(TimeTable.Close,'WindowSize',7);
rsi7(isnan(rsi7))=50;
catch
   rsi7=zero; 
end
try
rsi14 = rsindex(TimeTable.Close,'WindowSize',14);
rsi14(isnan(rsi14))=50;
catch
   rsi14=zero; 
end
try
rsi21 = rsindex(TimeTable.Close,'WindowSize',s21);
rsi21(isnan(rsi21))=50;
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

try

    
shiftedsma5=shift(upper.SMA5,5);
dsma5=(upper.SMA5-shiftedsma5)*100./params.TimeTables.Minute.Close;
dsma5(1:min(4,size(dsma5,1)),1)=0;
ddsma5=dsma5-[dsma5(1);dsma5(1:end-1)];

dcs=largedcandle(TimeTable);
dvs=largedvol(TimeTable,0.1);

% calculations.indicators{1}.lower.dcs1_fight=dcs{1}.fight;
% calculations.indicators{1}.lower.dcs1_open=dcs{1}.open;
% calculations.indicators{1}.lower.dcs1_close=dcs{1}.close;
% calculations.indicators{1}.lower.dcs1_total=dcs{1}.total;
% calculations.indicators{1}.lower.dvs1_fight=dvs{1}.fight;
% calculations.indicators{1}.lower.dvs1_open=dvs{1}.open;
% calculations.indicators{1}.lower.dvs1_close=dvs{1}.close;
% calculations.indicators{1}.lower.dvs1_total=dvs{1}.total;
    
    
varnames={'rsi7','rsi14','rsi21',...
    'dsma5','ddsma5',...
    'MACD','signalLine',...
    'NVI','PVI','ADO',...
   'PriceVolumeTrend',...
    'OnBalanceVolume','tick2ret',...
    'ChaikinVolatility','FastPercentK','acceleration',...
    'momentum',...
    'dcs_fight','dcs_open','dcs_close','dcs_total',...
    'dvs_fight','dvs_open','dvs_close','dvs_total',...
    };

%As explained, price today will be used to predict the stock price tomorrow. Hence all the indicators move forward 1 date.
% Only Open price of stock will be considered as feature as it is the only price we know before opening market in the day.
% 1st data point will be removed as there does not have any value for their feature indicators.
lower = timetable(TimeTable.Date, ...
rsi7, rsi14, rsi21,...
    dsma5,ddsma5,...
    MACDLine,signalLine,...
    NVIind.NegativeVolume, PosVind.PositiveVolume, ADOsc.ADOscillator,...
     pvtInd.PriceVolumeTrend,...
    volumeIdx.OnBalanceVolume, a_tick2retidx,...
    volatility.ChaikinVolatility, percentKnD.FastPercentK, acceleration.Open,...
    momentum.Open,...
    dcs.fight,dcs.open,dcs.close,dcs.total,...
    dvs.fight,dvs.open,dvs.close,dcs.total,...
    'VariableNames',varnames);
catch exception
     disp('lower indicators failed.');
      getReport(exception,'extended','hyperlinks','off');
     lower=timetable(TimeTable.Date);
end
end