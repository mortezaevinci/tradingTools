function getdata_daily5d_TDA_func(symbols,date0)

  date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd')
 date1=datestr(datetime(date2)-days(8),'yyyy-mm-dd')
     
 apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;
disabled=0;
 version='tda';
for i=1:numel(symbols)
    
   try
        name=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbols{i}) '\' filefriendlysymbol(symbols{i})  ' daily 5d ' date0 '.mat'];
        
        if (~exist(name) && isbusday(datetime(date0)))
         disp( contracts{i}.Symbol);
    [tw,jw] = getMarketDataViaTDAByPeriod( symbols{i}, periodType,date1,date2,frequencyType,frequency,apikey);
   if (~isempty(tw))
    % [tm,jm]=getMarketTimeData(tmfull);
 
  
   save(name,'tw','jw','version');
 
   else
      disp('could not grab data.');
       pause(0.05);
   end
        end
   
   catch exception
       
   end
end


end