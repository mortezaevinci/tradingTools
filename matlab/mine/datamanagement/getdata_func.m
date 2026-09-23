%updateRealtime=0 means do all, but not again for monthly and stuff.
%However, do intra day

% update realtime only does last 10 minutes

function [rq,c] =getdata_func(looperEngine,params,rq,c,updateRealtime,redo)

if (strcmp(looperEngine.date,'today')==0)
    %xxxmor grabbing all files for previous days is not implemented
   % return;
end
version='yahoo';
symbol=params.contract.Symbol;
 failed=0;

disp(['retreiving ' params.contract.Symbol ' data...']);
 global SYMBOLDONETODAY; 
alreadydone=0;
    if (~updateRealtime & ~isempty(SYMBOLDONETODAY))
      if (strcmp(looperEngine.date,'today'))
       %alreadydone=contains(SYMBOLDONETODAY,[symbol '.']);
      end
    end
   
      try
        %  disp('getting today data...');
%     if (isempty(c) || isempty(rq))
%         try
%         %disp('getting crumb...');
%    [~,~,rq,c]=getMarketDataViaYahooChart(symbol, '5d', '1d'); 
%         catch
%             %disp('getting crumb failed.');
%         end
%     end
          
     %[tm10,jm10,rq,c]=getMarketDataViaYahooChart(symbol, '10m', '1m',rq,c);   
     [tm10,jm10,rq,c]=getMarketDataViaYahooByPeriod(symbol, datetime()-minutes(10),datetime()+minutes(1), '1m',rq,c); 
    if (isempty(tm10))
        disp('10minute data from yahoo failed...');
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
    
    if (~updateRealtime)
   
        try
       % [tm,jm,rq,c]=getMarketDataViaYahooChart(symbol, params.todayDataPeriod, '1m',rq,c);   
        [tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(symbol, looperEngine.date,looperEngine.dateMinutesNextDay, '1m',rq,c);   
    if (isempty(tmfull))
        failed=1;
    else
 [tm,jm]=getMarketTimeData(tmfull);

   name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' looperEngine.date '.mat'];
     save(name,'tm','tmfull','jm','jmfull','version');
    end
        catch 
           disp('Could not recieve intraday.') 
        end
    
    if (alreadydone && redo==0)
  
        
    else
       disp('Get full init.');
       
        datetoday=datetime();
         istoday=datetoday.Day==datetime(looperEngine.date).Day & datetoday.Month==datetime(looperEngine.date).Month & datetoday.Year==datetime(looperEngine.date).Year ;
       
     try
     date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
    
        % [tdw,jdw,rq,c]=getMarketDataViaYahooChart(symbol, '5d', '1m',rq,c);   
   
    % [tdw,jdw,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1m',rq,c);    
     
    % [tdwfull,jdwfull] = getMarketDataViaTDAByPeriod( symbol, 'day',date1,date2,'minute',1,looperEngine.TDA.apikey);
    %[tdw,jdw]=getMarketTimeData(tdwfull);
  
    
     
     dates=datetime(date1):datetime(date2);
     for i=1:numel(dates)-1
      
         istoday_loop=datetoday.Day==dates(i).Day & datetoday.Month==dates(i).Month & datetoday.Year==dates(i).Year ;
         date1s=datestr(dates(i),'yyyy-mm-dd');
         date2s=datestr(dates(i+1),'yyyy-mm-dd');
         
         name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' date1s '.mat'];
         if (istoday_loop || ~exist(name))
         
    [tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1s,date2s, '1m',rq,c);  
   
    if (isempty(tmfull))
        failed=1;
    else
          [tm,jm]=getMarketTimeData(tmfull);
         save(name,'tm','tmfull','jm','jmfull','version');
    end
    
     end
    
     end
    
    
     catch
        disp([symbol ' minute weekly data not downloaded.']);
        failed=1;
    end
     
%     try
%         
%         name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 5d ' looperEngine.date '.mat'];
%          if (istoday || ~exist(name))
%         
%     date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
%      date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
%      %[tw,jw,rq,c]=getMarketDataViaYahooChart(symbol, '5d', '1d',rq,c);  
%      
%      [tw,jw,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1d',rq,c);    
%      
%     if (isempty(tw))
%         failed=1;
%     else
%    
%    save(name,'tw','jw');
%     end
%     
%     
%          end
%      catch
%         disp([symbol ' daily 5d data not downloaded.']);
%         failed=1;
%     end
   
     try
   %also update daily of today
      name=[looperEngine.directories.data filefriendlysymbol(symbol) '\' filefriendlysymbol(symbol)  ' daily 1y ' looperEngine.date '.mat'];
         if (~exist(name))
             
    date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays

   % [td,jd,rq,c]=getMarketDataViaYahooChart(symbol, '1y', '1d',rq,c);   
   
    [td,jd,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1d',rq,c);    
    if (isempty(td))
        failed=1;
    else
  
   save(name,'td','jd','version');
    end
    
         end
    
     catch
        disp([symbol ' daily data not downloaded.']);
        failed=1;
     end
   
     try
         
          name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' monthly ' looperEngine.date '.mat'];
         if (true)% small data, maybe we use avrage of current month some time, ~exist(name))
         
          date2=datestr(datetime(looperEngine.date)+days(1),'yyyy-mm-dd');
     date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd');  %weekdays, and one extra possible holidays
         
  % [tmo,jmo,~,~]=getMarketDataViaYahooChart(symbol, '1y', '1mo',rq,c); 
  
   [tmo,jmo,rq,c]=getMarketDataViaYahooByPeriod(symbol, date1,date2, '1mo',rq,c);    
   if (isempty(tmo))
        failed=1;
    else
   
   save(name,'tmo','jmo','version');
   end
   
         end
    catch
        disp([symbol ' monthly data not downloaded.']);
        failed=1;
     end
     
    
     
    end
    end

     if (failed==0)
   if (contains(SYMBOLDONETODAY,symbol)==0)
         SYMBOLDONETODAY=strcat(SYMBOLDONETODAY,[symbol '.']);
       end
         else
         rq=[];
         c=[];
     end
end