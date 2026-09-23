load('z:\My files\Project Trading\traderdata\data\BNTX\BNTX minute 2020-08-20.mat');

tmd=tm.Date;

dtmd=diff(tm.Date);

if (sum(dtmd~=minutes(1))>0)
    'error'
end



badindex=find(diff(tm.Date)==minutes(2))+1;


if (~isempty(tmfull))
    
    badindex=find(dtmd~=minutes(1));
                             
                            [tm_,~]=getMarketTimeData(tmfull);
                            tm(badindex:end,:)=tm_(badindex:end,:);
                           
                            fixed=1;
else
    %find fix pattern (All that can be done really)
    skippedinds=find(dtmd==minutes(2))+1;
    ns=numel(skippedinds);
    for j=1:ns
        try
            skippedind=skippedinds(j);
    if (dtmd(skippedind+1)==minutes(0))
        repeatedindex=skippedind+1;
        tm(repeatedindex,:)=tm(skippedind,:);
        tm(skippedind,:).Date=(datetime(tm(skippedind,:).Date)-minutes(1));
        tm(skippedind,2:7)=table(NaN,NaN,NaN,NaN,NaN,NaN);
        
        
    end
        catch
            
        end
    end
end