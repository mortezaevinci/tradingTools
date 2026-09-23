
annualinflationrate=0.025;

basedir='Z:\My files\Project trading\traderdata\data\';
date='2020-07-31';

symbol='AAPL';

fn=[basedir symbol '\' symbol ' daily 5y ' date '.mat'];load(fn);
params.TimeTables.Day=table2timetable(td);



%% indicators
 [atr_noncausal,tr]=indicators_atr(params.TimeTables.Day,14);
atr=shiftpad(atr_noncausal,1);
atrthresh1=atr/16;

%% groundtruth

intradaymovethreshold=atr/4;

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

%% forecast ideas
inflationrate=annualinflationrate*params.TimeTables.Day.Open/365;


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


% %changed sma calculations to use OPEN instead of CLOSE
% trendup_noncausal=dsma50>0 &  sma50>sma200;
% trenddn_noncausal=dsma50<0 & sma50<sma200;
% trendup=shiftpad(trendup_noncausal,1);
% trenddn=shiftpad(trenddn_noncausal,1);
trendup=dsma50>inflationrate &  sma50>sma200;
trenddn=dsma50<inflationrate & sma50<sma200;

strategy_bullish=premarketup & lastcandlesup & trendup;
strategy_bearish=premarketdn & lastcandlesdn & trenddn;

strategy_superposition_main_bullish=(double(shiftpad(lastdcandles,1)>atrthresh1) + double(gapup) + double(dsma200>inflationrate) + double(sma100>sma200) +  double(sma100>sma200 )+ double(sma50>sma200));
strategy_superposition_main_bearish=(double(shiftpad(lastdcandles,1)<-atrthresh1)+ double(gapdn) + double(dsma200<inflationrate) + double(sma100<sma200) +  double(sma100<sma200 )+ double(sma50<sma200));

conditions={'premarketdn','gapdn','gapunderlow','trenddn','lastcandlesdn','strategy_bearish','dsma200<inflationrate','dsma100<inflationrate',...
    'dsma50<inflationrate','(sma100<sma200)','sma50<sma200',...
    'shiftpad(lastdcandles,1)<inflationrate','shiftpad(lastdcandles,2)<inflationrate','shiftpad(lastdcandles,3)<inflationrate',...
    'shiftpad(lastdcandles,4)<inflationrate',...
    'shiftpad(lastdcandles,1)<inflationrate & shiftpad(lastdcandles,1)>-1*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>-1*atrthresh1+inflationrate','shiftpad(lastdcandles,1)<-1*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>-2*atrthresh1+inflationrate','shiftpad(lastdcandles,1)<-2*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>-4*atrthresh1+inflationrate','shiftpad(lastdcandles,1)<-4*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,2)>inflationrate | shiftpad(lastdcandles,3)>inflationrate |shiftpad(lastdcandles,4)>inflationrate',...
    'strategy_superposition_main_bearish>4','strategy_superposition_main_bearish>5',...
    'shiftpad(lastdcandles,1)>-4*atrthresh1+inflationrate & shiftpad(lastdcandles,1)<-2*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>-2*atrthresh1+inflationrate & shiftpad(lastdcandles,1)<0*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>-1*atrthresh1+inflationrate & shiftpad(lastdcandles,1)<1*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)> 2*atrthresh1+inflationrate & shiftpad(lastdcandles,1)<4*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,2)>-4*atrthresh1+inflationrate & shiftpad(lastdcandles,2)<-2*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,2)>-1*atrthresh1+inflationrate & shiftpad(lastdcandles,2)<1*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,2)>-2*atrthresh1+inflationrate & shiftpad(lastdcandles,2)<4*atrthresh1+inflationrate',...
    'premarketup','gapup','gapoverhigh','trendup','lastcandlesup','strategy_bullish','dsma200>inflationrate','dsma100>inflationrate',...
    'dsma50>inflationrate','(sma100>sma200)','sma50>sma200','dsma200<inflationrate','dsma100<inflationrate',...
    'shiftpad(lastdcandles,1)>inflationrate','shiftpad(lastdcandles,2)>inflationrate','shiftpad(lastdcandles,3)>inflationrate',...
    'shiftpad(lastdcandles,4)>inflationrate',...
    'shiftpad(lastdcandles,1)>inflationrate & shiftpad(lastdcandles,1)<1*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>1*atrthresh1+inflationrate','shiftpad(lastdcandles,1)<1*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>2*atrthresh1+inflationrate','shiftpad(lastdcandles,1)<2*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,1)>4*atrthresh1+inflationrate','shiftpad(lastdcandles,1)<4*atrthresh1+inflationrate',...
    'shiftpad(lastdcandles,2)<inflationrate | shiftpad(lastdcandles,3)<inflationrate |shiftpad(lastdcandles,4)<inflationrate',...
    'strategy_superposition_main_bullish>4','strategy_superposition_main_bullish>5',...
    };
nc=numel(conditions);

probabilities=zeros(2,floor(nc+nc*nc/2+nc*nc*nc/4));
cdayss=zeros(2,floor(nc+nc*nc/2+nc*nc*nc/4));
conditionnames=cell(1,floor(nc+nc*nc/2+nc*nc*nc/4));

direction=dndays;
dirtext='bearish';
allindex=1;

sub_dailytrendevaluation;
sub_dailytrendplot;

direction=updays;
dirtext='bullish';
allindex=2;

sub_dailytrendevaluation;
sub_dailytrendplot;