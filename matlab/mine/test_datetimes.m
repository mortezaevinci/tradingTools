date0='2020-10-05';


dates=datetime(date0,'TimeZone','America/New_York');


[dt,~] = tzoffset(dates)

gmcbad=(-hours(dt)==5)
