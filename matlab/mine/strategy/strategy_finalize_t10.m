function maintick=strategy_finalize_t10(looperEngine,maintick,commonticks)


if (looperEngine.process.type==0)
timetablePrimary=maintick.params.TimeTables.Minute;
timetableSecondary=maintick.params.TimeTables.Day;
timetableAuxilary=maintick.params.TimeTables.Month;
end
if (looperEngine.process.type==1)
timetablePrimary=maintick.params.TimeTables.Day(end-90:end,:);
timetableSecondary=maintick.params.TimeTables.Month;
timetableAuxilary=maintick.params.TimeTables.Month;
end

try

tms=size(maintick.debug.AllConditions,1);


%% conditiondetails

%% automate conditions, and signal types
dircmul=[];
condlen=size(maintick.calculations.DirectionPrediction{1}.Condition,2);
dircmul=(0:condlen-1)';
dircmul=pow2(dircmul);
denabled=maintick.params.DirectionPredictionEnabled(1:numel(dircmul));
dircmul=dircmul.*denabled;

condlen=size(maintick.calculations.StopPrediction{1}.Condition,2);
stopcmul=(0:condlen-1)';
stopcmul=pow2(stopcmul);
denabled=maintick.params.StopPredictionEnabled(1:numel(stopcmul));
stopcmul=stopcmul.*denabled;

%%ticscmu=toc
%%tic

%% Process conditions
% for now, I am going to cheat and find the maximum/minimum in the next x minutes

maintick.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_signals=zeros(tms,1);
maintick.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_return=zeros(tms,1);

  
% maintick.calculations.DirectionPrediction{1}.final=maintick.calculations.DirectionPrediction{1}.Condition*dircmul |  maintick.calculations.indicators{1}.eval.totalConditions>=  maintick.params.thresh.totalConditions.min | thresholdCondition(maintick.calculations.indicators{1}.eval.totalIndicators,maintick.params.thresh.totalIndicators,1) | maintick.calculations.indicators{1}.eval.IndicatorsCount> maintick.params.thresh.IndicatorsCount.min;
% maintick.calculations.DirectionPrediction{2}.final=maintick.calculations.DirectionPrediction{2}.Condition*dircmul |  maintick.calculations.indicators{1}.eval.totalConditions<=- maintick.params.thresh.totalConditions.min | thresholdCondition(maintick.calculations.indicators{1}.eval.totalIndicators,maintick.params.thresh.totalIndicators,0) | maintick.calculations.indicators{1}.eval.IndicatorsCount<- maintick.params.thresh.IndicatorsCount.min;

 maintick.calculations.DirectionPrediction{1}.final= maintick.calculations.DirectionPrediction{1}.Condition*dircmul;
 if (isfield(maintick.params.Strategies,'TotalConditions'))
  maintick.calculations.DirectionPrediction{1}.final= maintick.calculations.DirectionPrediction{1}.final&  maintick.calculations.indicators{1}.eval.uptotalConditions>=  maintick.params.thresh.totalConditions.min ;
 end
 if (isfield(maintick.params.Strategies,'TotalIndicators'))
 maintick.calculations.DirectionPrediction{1}.final= maintick.calculations.DirectionPrediction{1}.final& thresholdCondition(maintick.calculations.indicators{1}.eval.totalIndicators,maintick.params.thresh.totalIndicators,1);% & maintick.calculations.indicators{1}.eval.IndicatorsCount> maintick.params.thresh.IndicatorsCount.min;
 end
 maintick.calculations.DirectionPrediction{2}.final= maintick.calculations.DirectionPrediction{2}.Condition*dircmul;
 if (isfield(maintick.params.Strategies,'TotalConditions'))
 maintick.calculations.DirectionPrediction{2}.final=maintick.calculations.DirectionPrediction{2}.final&  maintick.calculations.indicators{1}.eval.dntotalConditions>= maintick.params.thresh.totalConditions.min ;
 end
 if (isfield(maintick.params.Strategies,'TotalIndicators'))
 maintick.calculations.DirectionPrediction{2}.final=maintick.calculations.DirectionPrediction{2}.final& thresholdCondition(maintick.calculations.indicators{1}.eval.totalIndicators,maintick.params.thresh.totalIndicators,0);% & maintick.calculations.indicators{1}.eval.IndicatorsCount<- maintick.params.thresh.IndicatorsCount.min;
 end
 dailyupcond=min(maintick.calculations.dailytrends(maintick.params.Strategies.DailyManual.Conditions.Entry{1,1}));
 dailydncond=min(maintick.calculations.dailytrends(maintick.params.Strategies.DailyManual.Conditions.Entry{1,2}));
 
 
  maintick.calculations.DirectionPrediction{1}.final= maintick.calculations.DirectionPrediction{1}.final*dailyupcond;
  maintick.calculations.DirectionPrediction{2}.final= maintick.calculations.DirectionPrediction{2}.final*dailydncond;

% indi10_1=shiftpad(maintick.calculations.indicators{1}.eval.totalIndicators,1);
% th=max(100,max(abs(maintick.calculations.indicators{1}.eval.totalIndicators))/5);
% maintick.calculations.DirectionPrediction{1}.final=maintick.calculations.DirectionPrediction{1}.Condition*dircmul |  maintick.calculations.indicators{1}.eval.totalConditions>=  maintick.params.thresh.totalConditions.min |  (indi10_1<-th & maintick.calculations.indicators{1}.eval.totalIndicators>th);
% maintick.calculations.DirectionPrediction{2}.final=maintick.calculations.DirectionPrediction{2}.Condition*dircmul |  maintick.calculations.indicators{1}.eval.totalConditions<=- maintick.params.thresh.totalConditions.min |  (indi10_1> th & maintick.calculations.indicators{1}.eval.totalIndicators<-th);

maintick.calculations.indicators{1}.eval.pbto=(maintick.calculations.DirectionPrediction{1}.final>0)  .*timetablePrimary.High;% .* lxups;
maintick.calculations.indicators{1}.eval.psto=(maintick.calculations.DirectionPrediction{2}.final>0) .*timetablePrimary.Low;% lxdns;

maintick.calculations.StopPrediction{1}.final=maintick.calculations.StopPrediction{1}.Condition*stopcmul;
maintick.calculations.StopPrediction{2}.final=maintick.calculations.StopPrediction{2}.Condition*stopcmul;

%% do not do stop if on direction condition or close to it
% this section needs to be developed properly

% at least give a run 2 minutes from stopping it
delaybeforestopitems=movmax(maintick.calculations.DirectionPrediction{1}.final | maintick.calculations.DirectionPrediction{2}.final,[2 0]);
delaybeforestop=find(delaybeforestopitems>0);

maintick.calculations.StopPrediction{1}.final(delaybeforestop)=0;
maintick.calculations.StopPrediction{2}.final(delaybeforestop)=0;

%%

maintick.calculations.indicators{1}.eval.pstc=(maintick.calculations.StopPrediction{1}.final>0).*maintick.calculations.minDisProfileClose.mindislvl{2}; %next upper level from close
maintick.calculations.indicators{1}.eval.pbtc=(maintick.calculations.StopPrediction{2}.final>0).*maintick.calculations.minDisProfileClose.mindislvl{1}; % next lower level from lcose

prioripoint=0;

stopsignal= shiftpad( ((maintick.calculations.StopPrediction{1}.final>0) | (maintick.calculations.StopPrediction{2}.final>0)),1);
buysellsignal= shiftpad((maintick.calculations.DirectionPrediction{1}.final>0)-(maintick.calculations.DirectionPrediction{2}.final>0),1);
% buysellsignal2= shiftpad((maintick.calculations.net.DirectionPrediction{1}.final>0)-(maintick.calculations.net.DirectionPrediction{2}.final>0),1);
for i=1:tms
  
   if (stopsignal(i))
       prioripoint=0;
   end
   
 %  if (buysellsignal2(i)~=0)
 %      prioripoint=buysellsignal2(i);
 %  end
   
   if (buysellsignal(i)~=0)
       prioripoint=buysellsignal(i);
   end
    
   maintick.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_signals(i)=prioripoint;
   
end

maintick.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_signals(end)=0;
maintick.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_return=signal2return(timetablePrimary,maintick.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_signals);

catch exception
   dumpReport('error.log', exception) 
    
end

end