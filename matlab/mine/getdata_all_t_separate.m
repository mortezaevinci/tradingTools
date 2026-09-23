
apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;
disabled=0;

numberofdays=90;

basedir='Z:\My files\Project trading\traderdata\data_other\tda\';
beginning=1;

if (datetime().Hour>=20) %after 8 o'clock, get today's data as well.
    beginning=0;
end
for ds=beginning:(numberofdays-1)
try
    date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
if (isbusday(date0))
    date1=date0;
    date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');

    contracts_TDA;
    getdata_daily5y_TDA_func(basedir,contracts,date0);
    getdata_intraday_TDA_func(basedir,contracts,date1,date2);

end
catch exception
    
end
end
