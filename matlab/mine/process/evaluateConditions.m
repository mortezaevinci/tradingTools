function performancematrix=evaluateConditions(params,calculations,debug)
try
testsize=size(debug.AllConditions,2);
datasize=numel(calculations.indicators{1}.eval.tradeGroundTruth_signals);

performancematrix.testiftrend=zeros(1,testsize);
performancematrix.trend=zeros(1,testsize);
performancematrix.testandtrend=zeros(1,testsize);
performancematrix.test=zeros(1,testsize);
performancematrix.trendiftest=zeros(1,testsize);
for j=1:2 %for long or short
    if (j==1)
        aa=calculations.indicators{1}.eval.tradeGroundTruth_signals>0;
    else
        aa=calculations.indicators{1}.eval.tradeGroundTruth_signals<0;
    end
    saa=sum(aa);
    if (saa==0)
        saa=1; % performancematrix gonna be all zeros because all aa components are zero
    end

   performancematrix.testiftrend(j,:)= (aa' * debug.AllConditions)/saa;
   performancematrix.trend(j,:)=sum(aa)/datasize;
   performancematrix.testandtrend(j,:)= performancematrix.testiftrend(j,:)*saa/datasize;
   performancematrix.test(j,:)= sum(debug.AllConditions,1)/datasize;
   performancematrix.trendiftest(j,:)=performancematrix.testandtrend(j,:)./performancematrix.test(j,:);

end

 %summ=repmat(sum(performancematrix,1),2,1);
 %summ(summ==0)=1;
 %  performancematrix=performancematrix./summ;
catch exception
   dumpReport('error.log', exception) 
end

end

