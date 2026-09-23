%updateRealtime=0 means do all, but not again for monthly and stuff.
%However, do intra day

% update realtime only does last 10 minutes

function [rq,c] =getdata_TDA_func(looperEngine,params,rq,c,updateRealtime,redo)

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='day';
period=1;
frequencyType='minute';
frequency=1;
disabled=0;


version='tda';
dateistoday=strcmp(looperEngine.date,'today');

%if (dateistoday==0)
    %xxxmor grabbing all files for previous days is not implemented
   % return;
%end

symbol=params.contract.Symbol;
 failed=0;

disp(['retreiving ' params.contract.Symbol ' data...']);
 global SYMBOLDONETODAY; 
alreadydone=0;
    if (~updateRealtime & ~isempty(SYMBOLDONETODAY))
      if (dateistoday)
       alreadydone=contains(SYMBOLDONETODAY,[symbol '.']);
      end
    end
   
    % grab 10m data only if today is used for realtime work
    if (dateistoday && updateRealtime)
      try
    
     %[tm10,jm10,rq,c]=getMarketDataViaYahooChart(symbol, '10m', '1m',rq,c);   
     rq=[];c=[];
     [tm10,jm10,rq,c]=getMarketDataViaYahooByPeriod(symbol, datetime()-minutes(20),datetime()+minutes(1), '1m',rq,c);  
    if (isempty(tm10))
        disp('10minute data from tda failed...');
        failed=1;
    else
      %  disp('10minute data to file...');
   name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' 10minute today.mat']; %only real-time use, if used with date, it is a bug
   save(name,'tm10','jm10','version');
    end
    
     catch
        disp([symbol ' 10minute data not downloaded.']);
        failed=1;
      end
    end
    
    if (~updateRealtime)
%   dateistoday
   name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' looperEngine.date '.mat'];
   
   if (~exist(name) || dateistoday)
        try
         
    %[tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(symbol, looperEngine.date,looperEngine.dateMinutesNextDay, '1m',rq,c);   
    [tmfull,jmfull] = getMarketDataViaTDAByPeriod( symbol, periodType,looperEngine.date,looperEngine.dateMinutesNextDay,'minute',frequency,apikey);
    currentdatetime=datetime();
    refdatetime=datetime([datestr(currentdatetime(),'yyyy-mm-dd') ' 09:30:00']);
    if (~isempty(tmfull) || (dateistoday && currentdatetime<refdatetime)) %or is pre-market of today
        [tm,jm]=getMarketTimeData(tmfull);
           %xxxmor, temporary solution for real-time data not including
            %previous day if not asked for
             if (dateistoday)
                 try  %just to bypass empty tm
                  dd=datetime(looperEngine.date);
                 tm(tm.Date<dd,:)=[];
                 catch
                 end
             end
        
      save(name,'tm','tmfull','jm','jmfull','version');
       
    else
        failed=1;
    end
  
        catch 
           disp('Could not recieve intraday.') 
        end
    end
        
    
    if (alreadydone && redo==0)
  
        
    else
       disp('Get full init tda.');
       
        datetoday=datetime();
         istoday=datetoday.Day==datetime(looperEngine.date).Day & datetoday.Month==datetime(looperEngine.date).Month & datetoday.Year==datetime(looperEngine.date).Year ;
       
     try
            if(dateistoday==0)
     date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
    
     
     dates=datetime(date1):datetime(date2);
     for i=1:numel(dates)-1
      
         istoday_loop=datetoday.Day==dates(i).Day & datetoday.Month==dates(i).Month & datetoday.Year==dates(i).Year ;
         date1s=datestr(dates(i),'yyyy-mm-dd');
         date2s=datestr(dates(i+1),'yyyy-mm-dd');
         isweekday=isbusday(dates(i));
         
         name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' date1s '.mat'];
         if (( ~exist(name)) && (isweekday))
         
  %  [tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1s,date2s, '1m',rq,c);  
     [tmfull,jmfull] = getMarketDataViaTDAByPeriod( symbol, periodType,date1s,date2s,'minute',frequency,apikey);
  
   
    if (~isempty(tmfull))
        [tm,jm]=getMarketTimeData(tmfull);
       save(name,'tm','tmfull','jm','jmfull','version');
       
    else
        failed=1;
    end
    
     end
    
     end
    
            end
     catch
        disp([symbol ' minute weekly data not downloaded.']);
        failed=1;
    end
     
   
     try
   %also update daily of today
      name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 1y ' looperEngine.date '.mat'];
         if (~exist(name) || dateistoday)
             
    date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays

    [td,jd,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1d',rq,c);    
    if (isempty(td))
        failed=1;
    else
  
   save(name,'td','jd','version');
    end
    
         end
    
     catch
        disp([symbol ' daily data not downloaded properly.']);
        failed=1;
     end
   
     try
         currentmonth=datetime().Month;
         dd=datestr(datetime(looperEngine.date),'yyyy-mm');
          name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' monthly ' dd '.mat'];
         if (~exist(name) || (currentmonth==datetime(looperEngine.date).Month && dateistoday ) )% small data, maybe we use avrage of current month some time, ~exist(name))
         
          date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
         

   [tmo,jmo,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1mo',rq,c);    
   if (isempty(tmo))
        failed=1;
    else
   
   save(name,'tmo','jmo','version');
   end
   
         end
     catch exception
        disp([symbol ' monthly data not downloaded properly.']);
        failed=1;
     end
     
    
     
    end
    end

     if (failed==0)
         if (isempty(SYMBOLDONETODAY) || contains(SYMBOLDONETODAY,symbol)==0)
         SYMBOLDONETODAY=strcat(SYMBOLDONETODAY,[symbol '.']);
       end
         else
         rq=[];
         c=[];
     end
end