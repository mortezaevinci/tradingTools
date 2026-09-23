function  getdata_intraday_TDA_func(basedir,contracts,date1,date2)

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='day';
period=1;
frequencyType='minute';
frequency=1;
disabled=0;

version='tda';
for i=1:numel(contracts)
   
   try
        name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' minute ' date1 '.mat'];
       if (~exist(name) && isbusday(date1))
           
   directory_=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\'];
   if (~exist(directory_))
    mkdir(directory_);
    end

      disp([contracts{i}.Symbol version ' ' frequencyType]);
       
    [tmfull_tda,jmfull_tda] = getMarketDataViaTDAByPeriod( contracts{i}.Symbol, periodType,date1,date2,frequencyType,frequency,apikey);
   if (~isempty(tmfull_tda))
    success=0;
     [tm,jm]=getMarketTimeData(tmfull_tda);
 
     if (size(tm,1)<390 && size(tm,1)>385)
         [tm2,success]=fixMinuteDataMissingPoint(tm);
        if (success)
            tm=tm2;
        end
        disp(['size was less than 390 syhthetic data injection success=' success]);
        
     end
     
   tmsize=size(tm,1);
     if ((tmsize>390 || tmsize<385) && ~contains(contracts{i}.Symbol,'^'))
         
        disp('WARNING: Wrong data captured...'); 
     end
  
   save(name,'tm','tmfull_tda','jmfull_tda','version');
   
   else
       disp('could not grab data.');

   end

       pause(1);   
       end
   catch exception
       
   end

end

end

