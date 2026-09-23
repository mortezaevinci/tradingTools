apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;
disabled=0;

basedir='Z:\My files\Project trading\traderdata\data\';
numberofdays=90;

for ds=1:(numberofdays-1)

try
    date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
   % date0=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
    if (isbusday(date0))
    date1=date0;
    date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');

   
    contracts_TDA;
   % contracts={genContract([],'SPY')};
  
    fix_yahoo_intraday_bytda_func(contracts,date1,date2);
    end
catch exception
    
end
end