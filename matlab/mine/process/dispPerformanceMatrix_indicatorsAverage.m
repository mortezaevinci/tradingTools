function []= dispPerformanceMatrix_indicatorsAverage(calculations,pm)

names={};
cnt=1;
    n=size( calculations.indicators{1}.lower(1,:),2);
    for i=1:n
       name=char(calculations.indicators{1}.lower(1,i).Properties.VariableNames);
       repeated=numel(table2array(calculations.indicators{1}.lower(1,i)));
       for  j=1:repeated
          names{cnt}=name;
          cnt=cnt+1;
       end
    end

    n=size(pm.trendiftest,2);
    for i=1:n
       disp([num2str(i) ':' names{i} ' condtion% if bullish=' num2str(pm.testiftrend(1,i)) ' condition% if bearish=' num2str(pm.testiftrend(2,i))  '  bullish% if condition=' num2str(pm.trendiftest(1,i)) '   bearish% if condition=' num2str(pm.trendiftest(2,i))]); 
       
    end

end