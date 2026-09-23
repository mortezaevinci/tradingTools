function [performancematrix]=evaluateIndicators(params,calculations)
try
ttl=table2array(calculations.indicators{1}.lower);

testsize=size(ttl,2);
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
   performancematrix.testiftrend(j,:)= (aa' * ttl)/saa;
   performancematrix.trend(j,:)=sum(aa)/datasize;
   performancematrix.testandtrend(j,:)= performancematrix.testiftrend(j,:)*saa/numel(aa);
   performancematrix.test(j,:)= sum(ttl,1)/datasize;
   performancematrix.trendiftest(j,:)=performancematrix.testandtrend(j,:)./performancematrix.test(j,:);
end
catch exception
   dumpReport('error.log', exception) 
end
end

