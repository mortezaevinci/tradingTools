function getdata_daily5d_yahoo_func(symbols,date0)

  date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd')
 date1=datestr(datetime(date2)-days(2000),'yyyy-mm-dd')
     
 c=[];
 rq=[];
  version='yahoo';
for i=1:numel(symbols)
    
   try
        name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbols{i}) '\' filefriendlysymbol(symbols{i})  ' daily 5y ' date0 '.mat']
        
        if (~exist(name) && isbusday(datetime(date0)))
        symbols{i}
     [td,jd,rq,c]=getMarketDataViaYahooByPeriod(symbols{i}, date1,date2, '1d',rq,c); 
   if (~isempty(td))
          
   save(name,'td','jd','version');
 
   else
       disp('could not grab data.');
     
       pause(0.05);
   end
        end
   
   catch exception
       
   end
end


end