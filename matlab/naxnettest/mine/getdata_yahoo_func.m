%updateRealtime=0 means do all, but not again for monthly and stuff.
%However, do intra day

% update realtime only does last 10 minutes

function [rq,c] =getdata_yahoo_func(looperParams,params,rq,c,updateRealtime,redo)

dateistoday=strcmp(looperParams.date,'today');

%if (strcmp(looperParams.date,'today')==0)
    %xxxmor grabbing all files for previous days is not implemented
   % return;
%end

symbol=params.symbol;
 failed=0;

disp(['retreiving ' params.symbol ' data...']);
 global SYMBOLDONETODAY; 
alreadydone=0;
    if (~updateRealtime & ~isempty(SYMBOLDONETODAY))
      if (dateistoday)
       alreadydone=contains(SYMBOLDONETODAY,symbol);
      end
    end
   
      try

          
     [tm10,jm10,rq,c]=getMarketDataViaYahooChart(symbol, '10m', '1m',rq,c);   
    if (isempty(tm10))
        disp('10minute data from yahoo failed...');
        failed=1;
    else
      %  disp('10minute data to file...');
   name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' 10minute today.mat']; %only real-time use, if used with date, it is a bug
   save(name,'tm10','jm10');
    end
    
     catch
        disp([symbol ' 10minute data not downloaded.']);
        failed=1;
      end
    
    if (~updateRealtime)
%   dateistoday
   name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' minute ' looperParams.date '.mat'];
   
   if (~exist(name) || dateistoday)
        try
         
       % [tm,jm,rq,c]=getMarketDataViaYahooChart(symbol, params.todayDataPeriod, '1m',rq,c);   
        [tm,jm,rq,c]=getMarketDataViaYahooByPeriod(symbol, looperParams.date,looperParams.dateMinutesNextDay, '1m',rq,c);   
        
    if (isempty(tm))
        failed=1;
    else
   
   save(name,'tm','jm');
    end
        catch 
           disp('Could not recieve intraday.') 
        end
    end
        
    
    if (alreadydone && redo==0)
  
        
    else
       disp('Get full init yahoo.');
       
        datetoday=datetime();
         istoday=datetoday.Day==datetime(looperParams.date).Day & datetoday.Month==datetime(looperParams.date).Month & datetoday.Year==datetime(looperParams.date).Year ;
       
     try
     date2=datestr(datetime(looperParams.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
    
        % [tdw,jdw,rq,c]=getMarketDataViaYahooChart(symbol, '5d', '1m',rq,c);   
   
    % [tdw,jdw,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1m',rq,c);    
     
    % [tdwfull,jdwfull] = getMarketDataViaTDAByPeriod( symbol, 'day',date1,date2,'minute',1,looperParams.TDA.apikey);
    %[tdw,jdw]=getMarketTimeData(tdwfull);
  
    
     
     dates=datetime(date1):datetime(date2);
     for i=1:numel(dates)-1
      
         istoday_loop=datetoday.Day==dates(i).Day & datetoday.Month==dates(i).Month & datetoday.Year==dates(i).Year ;
         date1s=datestr(dates(i),'yyyy-mm-dd');
         date2s=datestr(dates(i+1),'yyyy-mm-dd');
         isweekday=isbusday(dates(i));
         
         name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' minute ' date1s '.mat'];
         if (((istoday_loop && dateistoday) || ~exist(name)) && (isweekday))
         
         %disp(name);
    [tm,jm,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1s,date2s, '1m',rq,c);  
   
    if (isempty(tm))
        failed=1;
    else
        
        save(name,'tm','jm');
    end
    
     end
    
     end
    
    
     catch
        disp([symbol ' minute weekly data not downloaded.']);
        failed=1;
    end
     
    try
        
        name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' daily 5d ' looperParams.date '.mat'];
         if ((istoday && dateistoday) || ~exist(name))
        
    date2=datestr(datetime(looperParams.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
     %[tw,jw,rq,c]=getMarketDataViaYahooChart(symbol, '5d', '1d',rq,c);  
     
     [tw,jw,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1d',rq,c);    
     
    if (isempty(tw))
        failed=1;
    else
   
   save(name,'tw','jw');
    end
    
    
         end
     catch
        disp([symbol ' daily 5d data not downloaded.']);
        failed=1;
    end
   
     try
   %also update daily of today
      name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' daily 1y ' looperParams.date '.mat'];
         if (~exist(name))
             
    date2=datestr(datetime(looperParams.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays

   % [td,jd,rq,c]=getMarketDataViaYahooChart(symbol, '1y', '1d',rq,c);   
   
    [td,jd,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1d',rq,c);    
    if (isempty(td))
        failed=1;
    else
  
   save(name,'td','jd');
    end
    
         end
    
     catch
        disp([symbol ' daily data not downloaded.']);
        failed=1;
     end
   
     try
         currentmonth=datetime().Month;
         
          name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' monthly ' looperParams.date(1:(min(7,numel(looperParams.date)))) '.mat'];
         if (~exist(name) || (currentmonth==str2num(looperParams.date(6:7)) && dateistoday ) )% small data, maybe we use avrage of current month some time, ~exist(name))
         
          date2=datestr(datetime(looperParams.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
         
  % [tmo,jmo,~,~]=getMarketDataViaYahooChart(symbol, '1y', '1mo',rq,c); 
  
   [tmo,jmo,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1mo',rq,c);    
   if (isempty(tmo))
        failed=1;
    else
   
   save(name,'tmo','jmo');
   end
   
         end
    catch
        disp([symbol ' monthly data not downloaded.']);
        failed=1;
     end
     
    
     
    end
    end

     if (failed==0)
         SYMBOLDONETODAY=strcat(SYMBOLDONETODAY,[symbol '.']);
         else
         rq=[];
         c=[];
     end
end