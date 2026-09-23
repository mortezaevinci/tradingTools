function params=loadprofile_PMATP1(params,looperEngine)
try
    filename=[looperEngine.directories.PMAT 'PMATP1 ' filefriendlysymbol(params.contract.FileSymbol) ' ID' num2str(looperEngine.performance.setupId) '.mat'];

if (exist(filename))
    load(filename);

params.Strategies.TotalIndicators.Conditions.Entry{1}.mean=performanceMatrixP1.indicatorsProfile.mean;
params.Strategies.TotalIndicators.Conditions.Entry{1}.range=performanceMatrixP1.indicatorsProfile.range;


    performanceMatrixP1.conditions.trendiftest(isnan(performanceMatrixP1.conditions.trendiftest))=0;

   params.Strategies.TotalConditions.Conditions.Entry{1}= performanceMatrixP1.conditions.trendiftest(1,:);
   params.Strategies.TotalConditions.Conditions.Entry{2}= performanceMatrixP1.conditions.trendiftest(2,:);

else
   disp([filename ' did not exist.']); 

end
   catch exception
   dumpReport('error.log', exception) 
    
end
end