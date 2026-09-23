function dates=listDatesFromLast(oldtonew,beginning,latestday)
if (beginning==0 && latestday==0)
   dates=datetime('now','TimeZone','America/New_York');
while(~isbusday(dates))
    dates=dates-days(1);
end
return
end

if (oldtonew==1)
        dslist=(latestday-1):-1:beginning;
    else
        dslist=beginning:(latestday-1);
end
    date0 = datetime('now','TimeZone','America/New_York');
    dd0=datestr(date0,"yyyy-mm-dd");
    dates=datetime([dd0 ' 22:00:00'],'TimeZone','America/New_York')-days(dslist);
end