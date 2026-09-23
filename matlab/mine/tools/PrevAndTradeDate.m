
function [prevdate,tradedate]=PrevAndTradeDate()

dtest=datetime()-hours(20);
while(~isbusday(dtest))
    dtest=dtest-days(1);
end

prevdate=datestr(dtest,'yyyy-mm-dd');% '2021-01-08';
disp(prevdate);

dtest=datetime()+hours(6);
while(~isbusday(dtest))
    dtest=dtest+days(1);
end

tradedate=datestr(dtest,'yyyy-mm-dd');%'2021-01-12';
disp(tradedate);

end

