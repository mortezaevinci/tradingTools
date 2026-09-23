function params=updaterealtimeSecondaries(looperEngine,params)
if (strcmp(looperEngine.date,'today'))
dateistoday=1;
else
dateistoday=0;
end

if (isempty(params.TimeTables.Minute))
    return;
end

if (dateistoday)
%update Day data
%update today data
    %get default time for consistency
    %deftime=datestr(params.TimeTables.Day.Date(end),'hh:MM:ss');

    todaydatetime=params.TimeTables.Minute.Date(1);
    temptt=params.TimeTables.Day(end,:);
    temptt.Date=todaydatetime;
    temptt.Open=params.TimeTables.Minute.Open(1);
    temptt.High=max(params.TimeTables.Minute.High);
    temptt.Low=min(params.TimeTables.Minute.Low);
    temptt.Close=params.TimeTables.Minute.Close(end);
    params.TimeTables.Day(temptt.Date,:)=temptt;
end

end