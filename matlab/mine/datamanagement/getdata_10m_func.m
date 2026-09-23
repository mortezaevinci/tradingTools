function [failed,rq,c]=getdata_10m_func(looperEngine,params,rq,c)

      try
    version='yahoo';
     %[tm10,jm10,rq,c]=getMarketDataViaYahooChart(params.contract.Symbol, '10m', '1m',rq,c);  

    [tm10,jm10,rq,c]=getMarketDataViaYahooByPeriod(params.contract.Symbol, datetime()-minutes(10),datetime()+minutes(1), '1m',rq,c);   
       
    if (isempty(tm10))
        disp('10minute data from yahoo failed...');
        failed=1;
    else
      %  disp('10minute data to file...');
   name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' 10minute today.mat']; %only real-time use, if used with date, it is a bug
   save(name,'tm10','jm10','version');
    end
    
      catch exception
        disp([params.contract.Symbol ' 10minute data not downloaded.']);
        failed=1;
      end
      
end