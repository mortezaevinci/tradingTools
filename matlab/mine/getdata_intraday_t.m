basedir='Z:\My files\Project trading\traderdata\data\';

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;
disabled=0;


numberofdays=60;
beginning=1;

if (datetime().Hour>=20) %after 8 o'clock, get today's data as well.
    beginning=0;
end

for ds=beginning:(numberofdays-1)
    
    try
        date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
        % date0=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
        if (isbusday(date0))
            date1=date0;%[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
            date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');
            
            
            
            contracts_TDA;
            
            %       contracts={genContract([],'TWTR'),...
            %    };
            getdata_intraday_TDA_func(basedir,contracts,date1,date2);
            
            
        end
        
    catch exception
        dumpReport('error.log', exception)
    end
end