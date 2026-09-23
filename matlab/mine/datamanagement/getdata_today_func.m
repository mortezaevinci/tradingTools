%updateRealtime=0 means do all, but not again for monthly and stuff.
%However, do intra day

% update realtime only does last 10 minutes

function [rq,c] =getdata_today_func(params,rq,c,updateRealtime,redo)
symbol=params.contract.Symbol;
 failed=0;
version='yahoo';
disp(['retreiving ' params.contract.Symbol ' data...']);
 global SYMBOLDONETODAY; 
alreadydone=0;
    if (~updateRealtime & ~isempty(SYMBOLDONETODAY))
      
       alreadydone=contains(SYMBOLDONETODAY,[symbol '.']);
       
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
     rq=[];c=[];
     [tm10,jm10,rq,c]=getMarketDataViaYahooByPeriod(symbol, datetime()-minutes(10),datetime()+minutes(1), '1m',rq,c);  
    if (isempty(tm10))
        disp('10minute data from yahoo failed...');
        failed=1;
    else
      %  disp('10minute data to file...');
   name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' 10minute today.mat'];
   save(name,'tm10','jm10','version');
    end
    
     catch
        disp([symbol ' 10minute data not downloaded.']);
        failed=1;
      end
      
    
    if (~updateRealtime)
   
        try
        [tm,jm,rq,c]=getMarketDataViaYahooChart(symbol, params.todayDataPeriod, '1m',rq,c);   
    if (isempty(tm))
        failed=1;
    else
   name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute today.mat'];
   save(name,'tm','jm','version');
    end
        catch 
           disp('Could not recieve intraday.') 
        end
    
    if (alreadydone && redo==0)
  
        
    else
     
%      try
%    disp('Get full init.');
%      [tdw,jdw,rq,c]=getMarketDataViaYahooChart(symbol, '5d', '1m',rq,c);   
%     if (isempty(tdw))
%         failed=1;
%     else
%    name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute 5d today.mat'];
%    save(name,'tdw','jdw','version');
%     end
%      catch
%         disp([symbol ' minute weekly data not downloaded.']);
%         failed=1;
%     end
     
    %try
   
     %[tw,jw,rq,c]=getMarketDataViaYahooChart(symbol, '5d', '1d',rq,c);   
   % if (isempty(tw))
   %     failed=1;
   % else
   %name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 5d today.mat'];
   %save(name,'tw','jw','version');
   % end
   %  catch
   %     disp([symbol ' daily 5d data not downloaded.']);
   %     failed=1;
   % end
   
     try
   %also update daily of today
    [td,jd,rq,c]=getMarketDataViaYahooChart(symbol, '1y', '1d',rq,c);   
    if (isempty(td))
        failed=1;
    else
   name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 1y today.mat'];
   save(name,'td','jd','version');
    end
     catch
        disp([symbol ' daily data not downloaded.']);
        failed=1;
     end
   
     try
   [tmo,jmo,~,~]=getMarketDataViaYahooChart(symbol, '1y', '1mo',rq,c); 
   if (isempty(tmo))
        failed=1;
    else
   name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' monthly today.mat'];
   save(name,'tmo','jmo','version');
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