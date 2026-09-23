function getdata_daily1y_TDA_func(basedir,contracts,date0)
getdata_dailyset_TDA_func(basedir,contracts,date0,500,'1y')
%  date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd')
% date1=datestr(datetime(date2)-days(500),'yyyy-mm-dd')
% 
% apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
% periodType='year';
% period=1;
% frequencyType='daily';
% frequency=1;
% 
% version='tda';
% for i=1:numel(contracts)
%     
%    try
%         name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' daily 1y ' date0 '.mat'];
%         
%         if (~exist(name) && isbusday(datetime(date0)))
%        disp( contracts{i}.Symbol);
%     [td,jd] = getMarketDataViaTDAByPeriod( contracts{i}.Symbol, periodType,date1,date2,frequencyType,frequency,apikey);
%    if (~isempty(td))
%     % [tm,jm]=getMarketTimeData(tmfull);
%  
%   
%    save(name,'td','jd','version');
%    else
%        disp('could not grab data.');
% 
%        pause(.05);
%    end
%         end
%    
%    catch
%        
%    end
% end


end