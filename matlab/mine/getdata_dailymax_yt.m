basedir='Z:\My files\Project trading\traderdata\data\';


try
    d0=datetime();
    while(isbusday(d0)==0)
        d0=d0-days(1);
    end
    date0=datestr(d0,'yyyy-mm-dd');
    if (true)%isbusday(date0))
        
        date1=date0;%[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
        date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');
        
        contracts_yahoo;
        %     contracts={genContract([],'AAPL'),...
        %     };
        getdata_dailyset_yahoo_func(basedir,contracts,date0,20000,'max');
        
        
        contracts_TDA;
        getdata_dailyset_TDA_func(basedir,contracts,date0,20000,'max');
        
        contracts_nasdaq;
        getdata_dailyset_yahoo_func(basedir,contracts,date0,20000,'max');
        getdata_dailyset_TDA_func(basedir,contracts,date0,20000,'max');
        
        contracts_penniesm2;
        getdata_dailyset_yahoo_func(basedir,contracts,date0,20000,'max');
        getdata_dailyset_TDA_func(basedir,contracts,date0,20000,'max');
        
    end
    
catch exception
    dumpReport('error.log', exception)
end
