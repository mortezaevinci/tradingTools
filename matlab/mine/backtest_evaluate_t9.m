
try

for si=1:numel(looperEngine.contracts)
    
    
disp(['algo return %' num2str(mainticks{si}.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_return(end))]);

performanceMatrix{si}.conditiona=evaluateConditions(mainticks{si}.params,mainticks{si}.calculations,mainticks{si}.debug);
performanceMatrix{si}.indicators=evaluateIndicators(mainticks{si}.params,mainticks{si}.calculations);
    
    
    
    disp(looperEngine.contracts{si}.Symbol);
    disp('BUY:');
    sind=find(mainticks{si}.calculations.DirectionPrediction{1}.final>0);
    val=(mainticks{si}.calculations.indicators{1}.eval.BestBuyPerformance(sind)-mainticks{si}.params.TimeTables.Minute.Close(sind))./mainticks{si}.params.TimeTables.Minute.Close(sind);
   disp([num2str(val'*100) '% F.S']);
   disp('SELL:');
    sind=find(mainticks{si}.calculations.DirectionPrediction{2}.final>0);
    val=(mainticks{si}.calculations.indicators{1}.eval.BestSellPerformance(sind)-mainticks{si}.params.TimeTables.Minute.Close(sind))./mainticks{si}.params.TimeTables.Minute.Close(sind);
   disp([num2str(val'*100) '% F.S']);
    
end


    disp('strategy performance:');
    
    
catch 
    
end


try
disp('conditions performance matrix:');
nperf=numel(performancematrix);

pmean=zeros(size(performancematrix{1}));
for i=1:nperf
    pmean=pmean+performancematrix{i};
    
end
pmean=pmean/nperf;
 dispPerformanceMatrix(mainticks{1}.debug,pmean);

disp('indicators average performance matrix');
nperf=numel(performanceMatrix.indicators);
pmean=zeros(size(performanceMatrix.indicators.test(1)));
for i=1:nperf
    pmean=pmean+performanceMatrix.indicators.test(1);
    
end
pmean=pmean/nperf;

 dispPerformanceMatrix_indicatorsAverage(mainticks{1}.calculations,pmean);
%  
% indicatorsProfile.mean=(pmean(1,:)+pmean(2,:))/2;
% indicatorsProfile.range=1./((pmean(1,:)-pmean(2,:))/2);

catch
    
end