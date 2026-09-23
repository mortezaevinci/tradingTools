basedir='Z:\My files\Project trading\traderdata\data\';

lastopenday=datetime();
while(~isbusday(lastopenday))
    lastopenday=lastopenday-days(1);
end


try
    date0=datestr(lastopenday,'yyyy-mm-dd');
    % date0=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
    if (isbusday(date0))
        date1=date0;%[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
        date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');
        
        
        contracts_TDA_FRED;
        getdata_dailyset_TDA_func(basedir,contracts,date0,20000,'max');
        
    end
    
catch exception
    dumpReport('error.log', exception)
end
