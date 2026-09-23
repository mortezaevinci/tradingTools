function []= dispPerformanceMatrix(debug,pm)

    n=numel(debug.AllConditionsnames);
    for i=1:n
       disp([num2str(i) ':' debug.AllConditionsnames{i} ' condtion% if bullish=' num2str(pm.testiftrend(1,i)) ' condition% if bearish=' num2str(pm.testiftrend(2,i))  '  bullish% if condition=' num2str(pm.trendiftest(1,i)) '   bearish% if condition=' num2str(pm.trendiftest(2,i))]); 
       
    end

end