function date0=lastBusDay()
    dtest=datetime();
    while(~isbusday(dtest))
        dtest=dtest-day(1);
    end
    date0=datestr(dtest,'yyyy-mm-dd');
end