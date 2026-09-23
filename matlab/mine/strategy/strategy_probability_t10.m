function maintick=strategy_probability_t10(looperEngine,maintick)

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

if (maintick.params.Strategies.TotalConditions.perform)
    tms=size(maintick.debug.AllConditions,1);
    maintick.calculations.indicators{1}.eval.totalConditions=zeros(tms,1);
    alloccured=sum(maintick.debug.AllConditions,2);
     maintick.calculations.indicators{1}.eval.uptotalConditions=(maintick.debug.AllConditions *maintick.params.Strategies.TotalConditions.Conditions.Entry{1}')./alloccured;%numel(maintick.params.Strategies.TotalConditions.Conditions.Entry{1});
     maintick.calculations.indicators{1}.eval.dntotalConditions=(maintick.debug.AllConditions *maintick.params.Strategies.TotalConditions.Conditions.Entry{2}')./alloccured;%numel(maintick.params.Strategies.TotalConditions.Conditions.Entry{2});
     %maintick.calculations.indicators{1}.eval.totalConditionsLikelihood=(maintick.debug.AllConditions *maintick.params.Strategies.TotalConditions.Conditions.Entry{1}');
     maintick.calculations.indicators{1}.eval.totalConditions=maintick.calculations.indicators{1}.eval.totalConditions-maintick.calculations.indicators{1}.eval.totalConditions;
end

if (maintick.params.Strategies.TotalIndicators.perform)
    tms=size(maintick.debug.AllConditions,1);
    maintick.calculations.indicators{1}.eval.totalIndicators=zeros(tms,1);
     ttl=table2array(maintick.calculations.indicators{1}.lower);
    subsm=ttl-repmat(maintick.params.Strategies.TotalIndicators.Conditions.Entry{1}.mean,size(timetablePrimary,1),1);
   maintick.calculations.indicators{1}.eval.totalIndicators=(subsm)*maintick.params.Strategies.TotalIndicators.Conditions.Entry{1}.range';
maintick.calculations.indicators{1}.eval.totalIndicators(isnan(maintick.calculations.indicators{1}.eval.totalIndicators))=0;
maintick.calculations.indicators{1}.eval.totalIndicatorscumsum=cumsum(maintick.calculations.indicators{1}.eval.totalIndicators);
maintick.calculations.indicators{1}.eval.totalIndicators10=movmean(maintick.calculations.indicators{1}.eval.totalIndicators,[10 0]);
maintick.calculations.indicators{1}.eval.totalIndicators21=movmean(maintick.calculations.indicators{1}.eval.totalIndicators,[21 0]);
end

%if (maintick.params.Strategies.IndicatorsCount.perform)
%tms=size(maintick.debug.AllConditions,1);
%maintick.calculations.indicators{1}.eval.IndicatorsCount=zeros(tms,1);%retiring this, it's hard to manage

%    ttl=table2array(maintick.calculations.indicators{1}.lower);
%    abovecondmat=repmat(maintick.params.Strategies.IndicatorsCount.Conditions.Entry{1}.above,size(timetablePrimary,1),1);
%    abovecondmat(isnan(abovecondmat))=0;
%   upc=sum(ttl>abovecondmat,2);
%   belowcondmat=repmat(maintick.params.Strategies.IndicatorsCount.Conditions.Entry{1}.below,size(timetablePrimary,1),1);
%    belowcondmat(isnan(belowcondmat))=0;
%    dnc=sum(ttl<belowcondmat,2);
%   maintick.calculations.indicators{1}.eval.IndicatorsCount=upc-dnc;
%
%end

% just becasue temporarily this is set only for amzn, and should be trained
% separately
  % maintick.calculations.indicators{1}.eval.totalIndicators=maintick.calculations.indicators{1}.eval.totalIndicators*1000./max(maintick.calculations.indicators{1}.eval.totalIndicators);
 
  
  maintick.calculations.finished=1;

end