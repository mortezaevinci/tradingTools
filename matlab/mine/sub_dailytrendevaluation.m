%nc=numel(conditions);
conditionid=1;
for i=1:nc
   condition=conditions{i};
   result=eval(condition);
   [probability,cdays]=condition2probability(result,direction);
   probabilities(allindex,conditionid)=probabilities(allindex,conditionid)+probability;
   cdayss(allindex,conditionid)=       cdayss(allindex,conditionid)+cdays;
      if (isempty(conditionnames{1,conditionid}))
       conditionnames{1,conditionid}=condition;
   end
conditionid=conditionid+1;
  %disp([num2str(100*probability) '% of ' num2str(cdays) '-' dirtext ' forecast/' condition]);
end

for i=1:nc-1
   for j=(i+1):nc 
   condition=['(' conditions{i} ') &(' conditions{j} ')'];
   result=eval(condition);
  [probability,cdays]=condition2probability(result,direction);
   probabilities(allindex,conditionid)=probabilities(allindex,conditionid)+probability;
   cdayss(allindex,conditionid)=       cdayss(allindex,conditionid)+cdays;
     if (isempty(conditionnames{1,conditionid}))
       conditionnames{1,conditionid}=condition;
   end
conditionid=conditionid+1;
%    if (probability>0.5 && cdays>2)
%   disp([num2str(100*probability) '% of ' num2str(cdays) '-' dirtext ' forecast/' condition]);
%    end
   end
end


for i=1:nc-2
   for j=(i+1):nc-1
       for k=(j+1):nc 
   condition=['(' conditions{i} ') &(' conditions{j} ') &(' conditions{k} ')'];
   result=eval(condition);
   [probability,cdays]=condition2probability(result,direction);
   probabilities(allindex,conditionid)=probabilities(allindex,conditionid)+probability;
   cdayss(allindex,conditionid)=       cdayss(allindex,conditionid)+cdays;
   if (isempty(conditionnames{1,conditionid}))
       conditionnames{1,conditionid}=condition;
   end
   conditionid=conditionid+1;
%   if (probability>0.5 && cdays>2)
%    disp([num2str(100*probability) '% of ' num2str(cdays) '-' dirtext ' forecast/' condition]);
%   end
   
%   if (probability>0.8 && cdays>5)
%       figure;
%    cndl5(params.TimeTables.Day);
% hold on;
% plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*updays,'b^','linewidth',2,'markersize',2);
% plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*dndays,'bv','linewidth',2,'markersize',2);
% 
% signalup=(params.TimeTables.Day.Low-0.5) .*(result);
% 
% plot(params.TimeTables.Day.Date,signalup,'g*','linewidth',5,'markersize',5);
% title(condition);
% % pause;
% % close all;
%    end
       end
   end
end


goodindex=find(probabilities(allindex,:)>0.75 & cdayss(allindex,:)>10);
conditionnames{goodindex}

allgoodconditions{allindex}='';
for i=goodindex
    if (i==goodindex(1))
        allgoodconditions{allindex}=['(' conditionnames{i} ')'];
    
    else
        allgoodconditions{allindex}=[allgoodconditions{allindex} '|' '(' conditionnames{i} ')'];   
    end
end
