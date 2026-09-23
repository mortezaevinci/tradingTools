intradaymovethreshold=2.5;
annualinflationrate=0.025;

date='2020-08-05';
symbol='TSLA';
basedir='Z:\My files\Project trading\traderdata\data\';

fn=[basedir symbol '\' symbol ' minute ' date '.mat'];
load(fn);
params.TimeTables.Minute=table2timetable(tm);

fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];
load(fn);
params.TimeTables.Day=table2timetable(td);

% 
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

cndl5(params.TimeTables.Day);
hold on;

plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*updays,'b^','linewidth',2);
plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*dndays,'bv','linewidth',2);

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

strategy_superposition_main_bullish=(double(shiftpad(lastdcandles,1)>1) + double(gapup) + double(dsma200>inflationrate) + double(sma100>sma200) +  double(sma100>sma200 )+ double(sma50>sma200));
strategy_superposition_main_bearish=(double(shiftpad(lastdcandles,1)<-1)+ double(gapdn) + double(dsma200<inflationrate) + double(sma100<sma200) +  double(sma100<sma200 )+ double(sma50<sma200));

disp('bearish');
direction=dndays;
condition='premarketdn';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='gapdn';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='trenddn';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='lastcandlesdn';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='strategy_bearish';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='dsma200<inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='dsma100<inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='dsma50<inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='(sma100<sma200)';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='(sma100<sma200)';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='sma50<sma200';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='dsma200>inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='dsma100>inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,1)<0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,2)<0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,3)<0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,4)<0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,1)<0 & shiftpad(lastdcandles,1)>-1';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,1)<-1 & shiftpad(lastdcandles,1)>-2';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,1)<-2';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,1)<-3 & shiftpad(lastdcandles,1)>-4';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='shiftpad(lastdcandles,2)>0 | shiftpad(lastdcandles,3)>0 |shiftpad(lastdcandles,4)>0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='strategy_superposition_main_bearish>2';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='strategy_superposition_main_bearish>3';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='strategy_superposition_main_bearish>4';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
condition='strategy_superposition_main_bearish>5';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);

direction=updays;
disp('bullish');
% condition='premarketup';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='gapup';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='trendup';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='lastcandlesup';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='strategy_bullish';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='dsma200>inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='dsma100>inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='dsma50>inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='(sma100>sma200)';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='(sma100>sma200)';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='sma50>sma200';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='dsma200<inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='dsma100<inflationrate';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,1)>0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,2)>0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,3)>0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,4)>0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,1)>0 & shiftpad(lastdcandles,1)<1';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,1)>1 & shiftpad(lastdcandles,1)<2';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,1)>2';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,1)>3 & shiftpad(lastdcandles,1)<4';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='shiftpad(lastdcandles,2)<0 | shiftpad(lastdcandles,3)<0 |shiftpad(lastdcandles,4)<0';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='strategy_superposition_main_bullish>2';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='strategy_superposition_main_bullish>3';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='strategy_superposition_main_bullish>4';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
% condition='strategy_superposition_main_bullish>5';result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);

conditions={'premarketup','gapup','trendup','lastcandlesup','strategy_bullish','dsma200>inflationrate','dsma100>inflationrate',...
    'dsma50>inflationrate','(sma100>sma200)','(sma100>sma200)','sma50>sma200','dsma200<inflationrate','dsma100<inflationrate',...
    'shiftpad(lastdcandles,1)>0','shiftpad(lastdcandles,2)>0','shiftpad(lastdcandles,3)>0','shiftpad(lastdcandles,4)>0',...
    'shiftpad(lastdcandles,1)>0 & shiftpad(lastdcandles,1)<1','shiftpad(lastdcandles,1)>1 & shiftpad(lastdcandles,1)<2',...
    'shiftpad(lastdcandles,1)>2','shiftpad(lastdcandles,1)>3','shiftpad(lastdcandles,1)<4',...
    'shiftpad(lastdcandles,2)<0 | shiftpad(lastdcandles,3)<0 |shiftpad(lastdcandles,4)<0',...
    'strategy_superposition_main_bullish>2','strategy_superposition_main_bullish>3','strategy_superposition_main_bullish>4','strategy_superposition_main_bullish>5'};

nc=numel(conditions);

for i=1:nc
   condition=conditions{i};
   result=eval(condition);probability=condition2probability(result,direction);disp(['% proper forecast/' condition ':' num2str(100*probability)]);
end

signalup=params.TimeTables.Day.Low.*(strategy_superposition_main_bullish>5);
signaldn=params.TimeTables.Day.Low .*(strategy_superposition_main_bearish>2);

plot(params.TimeTables.Day.Date,signalup,'g^','linewidth',2);
plot(params.TimeTables.Day.Date,signaldn,'rv','linewidth',2);




