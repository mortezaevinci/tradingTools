basedir='Z:\My files\Project trading\traderdata\data\';

beginning=1;

if (datetime().Hour>=20) %after 8 o'clock, get today's data as well.
    beginning=0;
end

numberofdays=beginning+1;

for ds=beginning:(numberofdays-1)

try
    date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
    if (isbusday(date0))
    date1=date0;%[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
    date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');

    contracts_tsx;
    getdata_intraday_yahoo_func(basedir,contracts,date1,date2);
    getdata_dailyset_yahoo_func(basedir,contracts,date0,500,'1y');
    end

catch exception
   dumpReport('error.log', exception) 
end
end