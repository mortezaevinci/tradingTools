intradaymovethreshold=2.5;
annualinflationrate=0.025;

date='2020-08-05';basedir='Z:\My files\Project trading\traderdata\data\';
symbol='AAPL';

fn=[basedir symbol '\' symbol ' minute ' date '.mat'];load(fn);
params.TimeTables.Minute=table2timetable(tm);

fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];load(fn);
params.TimeTables.Day=table2timetable(td);

% %probabality of going bullish is higher than going bearish, and vice versa
% updays=(params.TimeTables.Day.High-params.TimeTables.Day.Open> intradaymovethreshold) | (params.TimeTables.Day.Low-params.TimeTables.Day.Open>-intradaymovethreshold/2);
% dndays=(params.TimeTables.Day.Low-params.TimeTables.Day.Open<-intradaymovethreshold)  | (params.TimeTables.Day.High-params.TimeTables.Day.Open< intradaymovethreshold/2);

% %bullish move of the day is twice the size of its bearish move, and vice
% %versa
 updays=(params.TimeTables.Day.High-params.TimeTables.Day.Open)>intradaymovethreshold & (params.TimeTables.Day.High-params.TimeTables.Day.Open)>2* (params.TimeTables.Day.Open-params.TimeTables.Day.Low);
 dndays=params.TimeTables.Day.Open-params.TimeTables.Day.Low>intradaymovethreshold & params.TimeTables.Day.Open-params.TimeTables.Day.Low>2*(params.TimeTables.Day.High-params.TimeTables.Day.Open);

updaysn=sum(updays);
dndaysn=sum(dndays);
ndays=numel(params.TimeTables.Day.Date);

%% indicators
 [atr_noncausal,tr]=indicators_atr(params.TimeTables.Day,14);
atr=shiftpad(atr_noncausal,1);


%% forecast ideas


premarketmove=params.TimeTables.Day.Open-shiftpad(params.TimeTables.Day.Close,1);
premarketup=premarketmove>0;
premarketdn=premarketmove<0;


% NOTE that we are predicting intraday move of each daily candle, so the
% one already evaluated cannot be used for its evaluation except for Open
lastdcandles=params.TimeTables.Day.Close-params.TimeTables.Day.Open;
lastcandlesup=shiftpad(lastdcandles,1)>inflationrate & (shiftpad(lastdcandles,2)<inflationrate | shiftpad(lastdcandles,3)<inflationrate | shiftpad(lastdcandles,4)<inflationrate);
lastcandlesdn=shiftpad(lastdcandles,1)<inflationrate & (shiftpad(lastdcandles,2)>inflationrate | shiftpad(lastdcandles,3)>inflationrate | shiftpad(lastdcandles,4)>inflationrate);

gap=params.TimeTables.Day.Open-shiftpad(params.TimeTables.Day.Close,1);
gapup=gap>atr/4 & gap< atr*3;
gapdn=gap<-atr/4 & gap> -atr*3;

gapoverhigh=params.TimeTables.Day.Open>shiftpad(params.TimeTables.Day.High,1);
gapunderlow=params.TimeTables.Day.Open<shiftpad(params.TimeTables.Day.Low,1);

supportoflast=params.TimeTables.Day.Open>shiftpad(params.TimeTables.Day.Low,1);
resistanceoflast=params.TimeTables.Day.Open<shiftpad(params.TimeTables.Day.High,1);

sma50=movmean(params.TimeTables.Day.Open,[50 0]);
sma100=movmean(params.TimeTables.Day.Open,[100 0]);
sma200=movmean(params.TimeTables.Day.Open,[200 0]);

dsma50=sma50-shiftpad(sma50,1);
dsma100=sma50-shiftpad(sma100,1);
dsma200=sma200-shiftpad(sma200,1);

inflationrate=annualinflationrate*params.TimeTables.Day.Open/365;

% %changed sma calculations to use OPEN instead of CLOSE
% trendup_noncausal=dsma50>0 &  sma50>sma200;
% trenddn_noncausal=dsma50<0 & sma50<sma200;
% trendup=shiftpad(trendup_noncausal,1);
% trenddn=shiftpad(trenddn_noncausal,1);
trendup=dsma50>inflationrate &  sma50>sma200;
trenddn=dsma50<inflationrate & sma50<sma200;

strategy_bullish=premarketup & lastcandlesup & trendup;
strategy_bearish=premarketdn & lastcandlesdn & trenddn;

strategy_superposition_main_bullish=(double(shiftpad(lastdcandles,1)>atr/10) + double(gapup) + double(dsma200>inflationrate) + double(sma100>sma200) +  double(sma100>sma200 )+ double(sma50>sma200));
strategy_superposition_main_bearish=(double(shiftpad(lastdcandles,1)<-atr/10)+ double(gapdn) + double(dsma200<inflationrate) + double(sma100<sma200) +  double(sma100<sma200 )+ double(sma50<sma200));

direction=dndays;
dirtext='bearish';
conditions={'premarketdn','gapdn','gapunderlow','trenddn','lastcandlesdn','strategy_bearish','dsma200<inflationrate','dsma100<inflationrate',...
    'dsma50<inflationrate','(sma100<sma200)','(sma100<sma200)','sma50<sma200','dsma200>inflationrate','dsma100>inflationrate',...
    'shiftpad(lastdcandles,1)<inflationrate','shiftpad(lastdcandles,2)<inflationrate','shiftpad(lastdcandles,3)<inflationrate',...
    'shiftpad(lastdcandles,4)<inflationrate',...
    'shiftpad(lastdcandles,1)<inflationrate & shiftpad(lastdcandles,1)>-1*atr/10+inflationrate',...
    'shiftpad(lastdcandles,1)<-1*atr/10+inflationrate & shiftpad(lastdcandles,1)>-2*atr/10+inflationrate',...
    'shiftpad(lastdcandles,1)<-2*atr/10+inflationrate','shiftpad(lastdcandles,1)<-3*atr/10+inflationrate','shiftpad(lastdcandles,1)>-4*atr/10+inflationrate',...
    'shiftpad(lastdcandles,2)>inflationrate | shiftpad(lastdcandles,3)>inflationrate |shiftpad(lastdcandles,4)>inflationrate',...
    'strategy_superposition_main_bearish>2','strategy_superposition_main_bearish>3','strategy_superposition_main_bearish>4',...
    'strategy_superposition_main_bearish>5',...
    'premarketup','gapup','gapoverhigh','trendup','lastcandlesup','strategy_bullish','dsma200>inflationrate','dsma100>inflationrate',...
    'dsma50>inflationrate','(sma100>sma200)','(sma100>sma200)','sma50>sma200','dsma200<inflationrate','dsma100<inflationrate',...
    'shiftpad(lastdcandles,1)>inflationrate','shiftpad(lastdcandles,2)>inflationrate','shiftpad(lastdcandles,3)>inflationrate',...
    'shiftpad(lastdcandles,4)>inflationrate',...
    'shiftpad(lastdcandles,1)>inflationrate & shiftpad(lastdcandles,1)<1*atr/10+inflationrate',...
    'shiftpad(lastdcandles,1)>1*atr/10+inflationrate & shiftpad(lastdcandles,1)<2*atr/10+inflationrate',...
    'shiftpad(lastdcandles,1)>2*atr/10+inflationrate','shiftpad(lastdcandles,1)>3*atr/10+inflationrate','shiftpad(lastdcandles,1)<4*atr/10+inflationrate',...
    'shiftpad(lastdcandles,2)<inflationrate | shiftpad(lastdcandles,3)<inflationrate |shiftpad(lastdcandles,4)<inflationrate',...
    'strategy_superposition_main_bullish>2','strategy_superposition_main_bullish>3','strategy_superposition_main_bullish>4',...
    'strategy_superposition_main_bullish>5',...
    };


sub_dailytrendevaluation;

direction=updays;
dirtext='bullish';

sub_dailytrendevaluation;

cndl5(params.TimeTables.Day);
hold on;

plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*updays,'b^','linewidth',2,'markersize',2);
plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*dndays,'bv','linewidth',2,'markersize',2);

%tested for tsla
% 7-80% success rate, calm the day before then gap
signalup=params.TimeTables.Day.Low.*((gapup) &(shiftpad(lastdcandles,1)>inflationrate & shiftpad(lastdcandles,1)<1+inflationrate));
signaldn=params.TimeTables.Day.Low .*((gapdn) &(shiftpad(lastdcandles,1)<inflationrate & shiftpad(lastdcandles,1)>-1+inflationrate));

%tested for tsla
% 65% success, clear stop loss at yesterday's res/support, rebounce
% approach
signalup=params.TimeTables.Day.Low.*((strategy_superposition_main_bullish>4) &(lastcandlesup) &(gapdn) & supportoflast);
signaldn=params.TimeTables.Day.Low .*((strategy_superposition_main_bearish>4) &(lastcandlesdn) &(gapup) & resistanceoflast);

%tested for tsla
% 100% success, seems to be based on an idea that momentum is good, and
% last candle moved against momentum, so the stock came back
signalup=params.TimeTables.Day.Low.*((strategy_superposition_main_bullish>4) &(shiftpad(lastdcandles,1)>-4+inflationrate) &(shiftpad(lastdcandles,1)<-2+inflationrate));
signaldn=params.TimeTables.Day.Low .*((strategy_superposition_main_bearish>4) &(shiftpad(lastdcandles,1)<4+inflationrate) &(shiftpad(lastdcandles,1)>2+inflationrate));

% 71% on aapl, idea is momentum or gap exists, and other previous candles
% are in the same direction
sup=(strategy_superposition_main_bullish>5) &(shiftpad(lastdcandles,3)>inflationrate) &(shiftpad(lastdcandles,2)>inflationrate);
sdn=(strategy_superposition_main_bearish>5) &(shiftpad(lastdcandles,3)<inflationrate) &(shiftpad(lastdcandles,2)<inflationrate);
signalup=(params.TimeTables.Day.Low-0.5) .*(sup);
signaldn=(params.TimeTables.Day.Low-0.5) .*(sdn);


% 71% on aapl, idea is momentum or gap exists, and 4th prev candle is the
% other way but the second is in the same direction
% are in the same direction
sup=(strategy_superposition_main_bullish>5) &(shiftpad(lastdcandles,4)<inflationrate) &(shiftpad(lastdcandles,2)>inflationrate);
sdn=(strategy_superposition_main_bearish>5) &(shiftpad(lastdcandles,4)>inflationrate) &(shiftpad(lastdcandles,2)<inflationrate);
signalup=(params.TimeTables.Day.Low-0.5) .*(sup);
signaldn=(params.TimeTables.Day.Low-0.5) .*(sdn);


sup=(strategy_superposition_main_bullish>5) &(dsma100<inflationrate) &(shiftpad(lastdcandles,2)>-1*atr/10+inflationrate & shiftpad(lastdcandles,2)<1*atr/10+inflationrate);
sdn=0;

signalup=(params.TimeTables.Day.Low-0.5) .*(sup);
signaldn=(params.TimeTables.Day.Low-0.5) .*(sdn);
plot(params.TimeTables.Day.Date,signalup,'g^','linewidth',5,'markersize',5);
plot(params.TimeTables.Day.Date,signaldn,'rv','linewidth',5,'markersize',5);

