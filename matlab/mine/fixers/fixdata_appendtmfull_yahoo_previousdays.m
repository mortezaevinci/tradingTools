basedir='Z:\My files\Project trading\traderdata\data\';

numberofdays=90;

for ds=1:(numberofdays-1)

try
    date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
   
    if (isbusday(date0))
    date1=date0;%[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
    date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');

    
     contracts_yahoo;
    %      contracts={genContract([],'AAPL'),...
  % };
    appendtmfull_intraday_yahoo_func(basedir,contracts,date1,date2);
 
   
    end

catch exception
   dumpReport('error.log', exception) 
end
end