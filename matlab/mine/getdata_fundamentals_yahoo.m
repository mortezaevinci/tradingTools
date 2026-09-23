basedir='Z:\My files\Project trading\traderdata\fundamentals\yahoo\';

todaydate=datestr(datetime(),'yyyy-mm-dd');
try

  
     contracts_yahoo;
%       contracts={genContract([],'TWTR'),...
%    };
    getdata_fundamentals_yahoo_func(basedir,contracts,todaydate);
    
  contracts_nasdaq;
  
   getdata_fundamentals_yahoo_func(basedir,contracts,todaydate);
   

catch exception
   dumpReport('error.log', exception) 
end
