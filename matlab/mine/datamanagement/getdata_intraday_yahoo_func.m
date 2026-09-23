function  getdata_intraday_yahoo_func(basedir,contracts,date1,date2)


rq=[];
c=[];

  version='yahoo';
for i=1:numel(contracts)
	try

name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' minute ' date1 '.mat'];
if (~exist(name) && isbusday(date1))

     directory_=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\'];
   if (~exist(directory_))
    mkdir(directory_);
    end
    
    disp([contracts{i}.Symbol ' ' version ' intraday']);
   [tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(contracts{i}.Symbol, date1,date2, '1m',rq,c); 
   if (~isempty(tmfull))
       
       [tm,jm]=getMarketTimeData(tmfull);
       
       
       sucess=0;
%      if (size(tm,1)<390)
%          [tm2,success]=fixMinuteDataMissingPoint(tm);
%         if (success)
%             tm=tm2;
%         end
%         disp(['size was less than 390 syhthetic data injection success=' success]);
%         
%      end
     tmsize=size(tm,1);
%      if ((tmsize>390 || tmsize<385) && ~contains(contracts{i}.Symbol,'^'))
%          
%         disp('WARNING: Wrong data captured...'); 
%      end
  
       
   save(name,'tm','tmfull','jm','jmfull','version');
   else
       disp('could not grab data.');
      
           
       pause(0.05);
   end
end
   catch exception
       dumpReport('error.log', exception) 
        
   end
end
end

