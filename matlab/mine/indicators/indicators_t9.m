function [lower,upper,eval]=indicators_t9(timetablePrimary,timetableSecondary)
%%tic

try
    % find type of main timetable
    secs=60;
    try
    secs=seconds(timetablePrimary.Date(2)-timetablePrimary.Date(1));
    catch
    end
    themorningdate=datetime([datestr(timetablePrimary.Date(end),'yyyy-mm-dd') ' 09:30:00']);
    if (secs==60)
        %it's intraday
       
       % tr=timerange(themorningdate-days(5), themorningdate-hours(16));
       % ddlast=timetableSecondary(tr,:);
      %  lastdayquote=ddlast(end,:);
        %lastPeriodHighLowRange=lastdayquote.High-lastdayquote.Low;
        atr=indicators_atr(timetableSecondary,14);
        lastPeriodHighLowRange=atr(end);
    end
    
     if (secs==86400)
        %it's daily, secondary should be monthly
        tr=timerange(themorningdate- day(themorningdate)-day(28)-day(10), themorningdate);
        mmlast=timetableSecondary(tr,:);
        lastmonthquote=mmlast(end,:);
        lastPeriodHighLowRange=lastmonthquote.High-lastmonthquote.Low;
    end
    
catch
    
end



zero=zeros(size(timetablePrimary.Close));
one=ones(size(timetablePrimary.Close));
%%upper indicators

try

try
%Moving Average 3th - 6th Features
sma5=movavg(timetablePrimary.Close,'simple',5);
sma5(isnan(sma5))=timetablePrimary.Open(1);
catch
    sma5=zero;
end
try
sma10 = movavg(timetablePrimary.Close,'simple',10);
sma10(isnan(sma10))=timetablePrimary.Open(1);
catch
    sma10=zero;
end
try
sma21 = movavg(timetablePrimary.Close,'simple',21);
sma21(isnan(sma21))=timetablePrimary.Open(1);
catch
    sma21=zero;
end
try
sma50 = movavg(timetablePrimary.Close,'simple',50);
sma50(isnan(sma50))=timetablePrimary.Open(1);
catch
    sma50=zero;
end



try
%Exponential Moving Average 9 Feature for daytrade
EMA9 = movavg(timetablePrimary.Close,'exponential',9);
catch
    EMA9=zero;
end

try
%Exponential Moving Average 20 Feature for daytrade
EMA20 = movavg(timetablePrimary.Close,'exponential',20);
catch
    EMA20=zero;
end

try

%Time Series Bollinger band 13-15 Features
[BBmiddle,BBupper,BBlower] = bollinger(timetablePrimary,'WindowSize',12); % standard is 20, but 10 seemed to work better, read that 12 is best for daytrading
catch
    BBmiddle.Open=zero;
    BBupper.Open=zero;
    BBlower.Open=zero;
end


try

%Highest high 16 Features
highind = hhigh(timetablePrimary,'NumPeriods',10) ;
catch
    highind.HighestHigh=zero;
end
try
%Lowest low 17 Features
lowind = llow(timetablePrimary,'NumPeriods',10);
catch
    lowind.LowestLow=zero;
end
try
%Median Price 18 Features
MedIdx = medprice(timetablePrimary);
catch
    MedIdx.MedianPrice=zero;
end
try
%williams Accumulation/Distribution line 21 Features
willadidx = willad(timetablePrimary);
catch
    willadidx.WillAD=zero;
end




varnames={'sma5','sma10','sma21','sma50',...
    'EMA9','EMA20',...
    'BBmiddle','BBupper','BBlower','HighestHigh',...
    'LowestLow','MedianIndex',...
    'WillAD'};

%As explained, price today will be used to predict the stock price tomorrow. Hence all the indicators move forward 1 date.
% Only Open price of stock will be considered as feature as it is the only price we know before opening market in the day.
% 1st data point will be removed as there does not have any value for their feature indicators.
upper = timetable(timetablePrimary.Date, ...
    sma5, sma10, sma21,sma50,...
    EMA9,EMA20,...
    BBmiddle.Open, BBupper.Open, BBlower.Open, highind.HighestHigh,...
    lowind.LowestLow, MedIdx.MedianPrice ,...
    willadidx.WillAD,...
    'VariableNames',varnames);

catch exception
    % disp('upper indicators failed.');
    exception
     dumpReport('error.log', exception);
     upper=timetable(timetablePrimary.Date);
end

%% lower indicator

try

%Extract Technical Indicators
%Relative Strength Index 1st-3th Features

rsi5 = rsindex(timetablePrimary.Close,'WindowSize',5)/100;
rsi5(isnan(rsi5))=0.5;
catch
   rsi5=one*0.5; 
end
try
rsi10 = rsindex(timetablePrimary.Close,'WindowSize',10)/100;
rsi10(isnan(rsi10))=0.5;
catch
   rsi10=one*0.5; 
end
try
rsi21 = rsindex(timetablePrimary.Close,'WindowSize',21)/100;
rsi21(isnan(rsi21))=0.5;
catch
   rsi21=one*0.5; 
end
try

%Moving Average Convergent/Divergent 8-9th Features
[MACDLine, signalLine]= macd(timetablePrimary.Close);
MACDLine(isnan(MACDLine))=0;

%signal line could be different in size
%signalLine(isnan(signalLine))=0;

catch
 % signalLine =zero; 
  MACDLine=zero;
end
try
%Negative Volume Index 10th Features
NVIind = negvolidx(timetablePrimary);
catch
  NVIind.NegativeVolume =zero; 
end
try
%Positive Volume Index 11th Features
PosVind = posvolidx(timetablePrimary);
catch
 PosVind.PositiveVolume  =zero; 
end
try
%Accumulation/Distribution OSciallator 12th Features
ADOsc = adosc(timetablePrimary);
catch
  ADOsc.ADOscillator =zero; 
end
try
%on-balance volume 19 Features
volumeIdx = onbalvol(timetablePrimary);
catch
  volumeIdx.OnBalanceVolume =zero; 
end
try
OnBalanceVolume10=movavg(volumeIdx.OnBalanceVolume,'simple',10);
catch
  OnBalanceVolume10 =zero; 
end
try
OnBalanceVolume21=movavg(volumeIdx.OnBalanceVolume,'simple',21);
catch
  OnBalanceVolume21 =zero; 
end
try
%Price and Volume Trend(PVT) 20 Features
pvtInd = pvtrend(timetablePrimary); 
catch
  pvtInd.PriceVolumeTrend =zero; 
end
try
%Ticket Return Series 22 Features
tt_tick2retidx = tick2ret(timetablePrimary);
a_tick2retidx=table2array(tt_tick2retidx);
a_tick2retidx=[zeros(1,size(a_tick2retidx,2));a_tick2retidx];
a_tick2retidx=a_tick2retidx(:,1:4);
catch
  a_tick2retidx =zeros(size(timetablePrimary,1),4); 
end


try
%Ticket Return Series 22 Features

tp=table2array(timetablePrimary);

relativeQuote=tp-tp(1,1); %open
relativeQuote=relativeQuote(:,1:4)/lastPeriodHighLowRange;
catch
  relativeQuote =zeros(size(timetablePrimary,1),4); 
end



try
%Chaikin Volatility 23
volatility = chaikvolat(timetablePrimary);
volatility.ChaikinVolatility(isnan(volatility.ChaikinVolatility))=0;
catch
  volatility.ChaikinVolatility =zero; 
end
try
%Stochastic Oscillator 24
percentKnD = stochosc(timetablePrimary)/100;
catch
   percentKnD.FastPercentK=zero; 
end
try
%Acceleration between times 25
acceleration = tsaccel(timetablePrimary);
catch
 acceleration.Open  =zero; 
end
try
%Momentum between times 26
momentum = tsmom(timetablePrimary);
catch
  momentum.Open =zero; 
end

%coming from upper

try

smashift=4;
shiftedsma5=shiftpad(upper.sma5,smashift);
dsma5=(upper.sma5-shiftedsma5)*(1)/lastPeriodHighLowRange/smashift;
dsma5(1:min(4,size(dsma5,1)),1)=0;
catch
 dsma5 =zero; 
end

try
ddsma5=dsma5- shiftpad(dsma5,1);
catch
 ddsma5 =zero; 
end


dcs=largedcandle(timetablePrimary);
dvs=largedvol(timetablePrimary,0.1);

try
dcs_fight10=movavg(dcs.fight,'simple',10);
dcs_close10=movavg(dcs.close,'simple',10);
dcs_open10=movavg(dcs.open,'simple',10);
dcs_total10=movavg(dcs.total,'simple',10);

catch
 
  dcs_fight10=zero;
dcs_close10=zero;
dcs_open10=zero;
dcs_total10=zero;
end

try
dcs_fight21=movavg(dcs.fight,'simple',21);
dcs_close21=movavg(dcs.close,'simple',21);
dcs_open21=movavg(dcs.open,'simple',21);
dcs_total21=movavg(dcs.total,'simple',21);
catch
dcs_fight21=zero;
dcs_close21=zero;
dcs_open21=zero;
dcs_total21=zero;
end

try

sma5ret = tick2ret(sma5);
sma5ret=[zeros(1,size(sma5ret,2));sma5ret];

catch
 sma5ret =zero; 
end
try
sma10ret = tick2ret(sma10);
sma10ret=[zeros(1,size(sma10ret,2));sma10ret];
catch
 sma10ret =zero; 
end
try
sma21ret = tick2ret(sma21);
sma21ret=[zeros(1,size(sma21ret,2));sma21ret];
catch
 sma21ret =zero; 
end
try
sma50ret = tick2ret(sma50);
sma50ret=[zeros(1,size(sma50ret,2));sma50ret];
catch
 sma50ret =zero; 
end
try
BBupperret = tick2ret(BBupper.Open);
BBupperret=[zeros(1,size(BBupperret,2));BBupperret];
catch
 BBupperret =zero; 
end
try
BBlowerret = tick2ret(BBlower.Open);
BBlowerret=[zeros(1,size(BBlowerret,2));BBlowerret];
catch
 BBlowerret =zero; 
end
try
PercentileBollingerBW=(BBupper.Open-BBlower.Open)./BBmiddle.Open;


    catch
 PercentileBollingerBW =zero; 
end
try
ret_sma5=movavg(a_tick2retidx,'simple',5)*(1)/lastPeriodHighLowRange;
catch
 ret_sma5 =zeros(size(timetablePrimary)); 
end

% try
% ret_sma10=movavg(a_tick2retidx,'linear',10)*(1)/lastPeriodHighLowRange;
% catch
%  ret_sma10 =zeros(size(timetablePrimary)); 
% end
% 
% try
% ret_sma21=movavg(a_tick2retidx,'linear',21)*(1)/lastPeriodHighLowRange;
% catch
%  ret_sma21 =zeros(size(timetablePrimary)); 
% end

try
relativeQuote5=movavg(relativeQuote,'simple',5);
catch
 relativeQuote5 =zeros(size(timetablePrimary,1),4); 
end

try
relativeQuote10=movavg(relativeQuote,'simple',10)*(1);
catch
 relativeQuote10 =zeros(size(timetablePrimary,1),4); 
end

try
relativeQuote21=movavg(relativeQuote,'simple',21)*(1);
catch
 relativeQuote21 =zeros(size(timetablePrimary,1),4); 
end

try
relativeQuote50=movavg(relativeQuote,'simple',50)*(1);
catch
 relativeQuote50 =zeros(size(timetablePrimary,1),4); 
end

try
deltaQuote5=relativeQuote-movavg(relativeQuote,'simple',5);
catch
 deltaQuote5 =zeros(size(timetablePrimary,1),4); 
end

try
deltaQuote10=relativeQuote-movavg(relativeQuote,'simple',10)*(1);
catch
 deltaQuote10 =zeros(size(timetablePrimary,1),4); 
end

try
deltaQuote21=relativeQuote-movavg(relativeQuote,'simple',21)*(1);
catch
 deltaQuote21 =zeros(size(timetablePrimary,1),4); 
end

try
deltaQuote50=relativeQuote-movavg(relativeQuote,'simple',50)*(1);
catch
 deltaQuote50 =zeros(size(timetablePrimary,1),4); 
end

try
da_tick2retidx=a_tick2retidx- shiftpad(a_tick2retidx,1);
dret_sma5=movavg(da_tick2retidx,'simple',5)*(1)/lastPeriodHighLowRange;
catch
 dret_sma5 =zeros(size(timetablePrimary)); 

end




try
    
    [BuyVolume,SellVolume]=buysellVolume(timetablePrimary,0);
catch
 BuyVolume =zeros(size(timetablePrimary.Close)); 
SellVolume =zeros(size(timetablePrimary.Close)); 
end

try
    
    %    'ret_sma10_open','ret_sma10_high','ret_sma10_low','ret_sma10_close',...
%    'ret_sma21_open','ret_sma21_high','ret_sma21_low','ret_sma21_close',...
varnames={'rsi5','rsi10','rsi21',...
'sma5ret','sma10ret','sma21ret','sma50ret',...
'BBlowerret','BBupperret','PercentileBollingerBW',...
    'dsma5','ddsma5',...
    'MACD',...
    'NVI','PVI','ADO',...
   'PriceVolumeTrend',...
    'OnBalanceVolume','OnBalanceVolume10','OnBalanceVolume21',...
    'tick2ret',...
    'ChaikinVolatility','FastPercentK','acceleration',...
    'momentum',...
    'dcs_fight','dcs_open','dcs_close','dcs_total',...
    'dcs_fight10','dcs_open10','dcs_close10','dcs_total10',...
    'dcs_fight21','dcs_open21','dcs_close21','dcs_total21',...
    'dvs_fight','dvs_open','dvs_close','dvs_total',...
    'ret_sma5_open','ret_sma5_high','ret_sma5_low','ret_sma5_close',...
    'dret_sma5_open','dret_sma5_high','dret_sma5_low','dret_sma5_close',...
    'BuyVolume','SellVolume',...
    'relativeQuote','relativeQuote5','relativeQuote10','relativeQuote21','relativeQuote50',...
    'deltaQuote5','deltaQuote10','deltaQuote21','deltaQuote50'
    };

%As explained, price today will be used to predict the stock price tomorrow. Hence all the indicators move forward 1 date.
% Only Open price of stock will be considered as feature as it is the only price we know before opening market in the day.
% 1st data point will be removed as there does not have any value for their feature indicators.


%     ret_sma10(:,1),ret_sma10(:,2),ret_sma10(:,3),ret_sma10(:,4),...
%     ret_sma21(:,1),ret_sma21(:,2),ret_sma21(:,3),ret_sma21(:,4),...

lower = timetable(timetablePrimary.Date, ...
rsi5, rsi10, rsi21,...
sma5ret,sma10ret,sma21ret,sma50ret,...
BBlowerret,BBupperret,PercentileBollingerBW,...
   dsma5,ddsma5,...
    MACDLine,...
    NVIind.NegativeVolume, PosVind.PositiveVolume, ADOsc.ADOscillator,...
    pvtInd.PriceVolumeTrend,...
     volumeIdx.OnBalanceVolume,OnBalanceVolume10,OnBalanceVolume21,...
 a_tick2retidx,...
     volatility.ChaikinVolatility, percentKnD.FastPercentK, acceleration.Open,...
     momentum.Open,...
     dcs.fight,dcs.open,dcs.close,dcs.total,...
     dcs_fight10,dcs_open10,dcs_close10,dcs_total10,...
    dcs_fight21,dcs_open21,dcs_close21,dcs_total21,...
     dvs.fight,dvs.open,dvs.close,dcs.total,...
     ret_sma5(:,1),ret_sma5(:,2),ret_sma5(:,3),ret_sma5(:,4),...
     dret_sma5(:,1),dret_sma5(:,2),dret_sma5(:,3),dret_sma5(:,4),...
     BuyVolume,SellVolume,...
     relativeQuote,relativeQuote5,relativeQuote10,relativeQuote21,relativeQuote50,...
     deltaQuote5,deltaQuote10,deltaQuote21,deltaQuote50,...
     'VariableNames',varnames);
catch exception
     %disp('lower indicators failed.');
     
      dumpReport('error.log', exception);
     lower=timetable(timetablePrimary.Date);
end


eval=timetable(timetablePrimary.Date);
%%ticindicators=toc

end