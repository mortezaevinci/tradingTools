

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='year';
period=1;
frequencyType='monthly';
frequency=1;

disabled=0;

currentmonth=datetime().Month;
currentyear=datetime().Year;

numberofmonths=12;

for i=0:numberofmonths
    dd=datetime();
    dd=dd-days(dd.Day)+days(15)-calmonths(i)
    
    if (true)%%dd.Month~=currentmonth || dd.Year~=currentyear)

  date0=[num2str(dd.Year) '-' num2str(dd.Month,'%02.f') '-01']

 date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd');
 date1=datestr(datetime(date2)-calmonths(60),'yyyy-mm-dd');
     
for i=1:numel(contracts)
    
   try
 
        name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' monthly ' date0(1:7) '.mat'];
        
        directory_=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\'];
   if (~exist(directory_))
    mkdir(directory_);
    end

        
        if ((~exist(name) || i==currentmonth) )
        contracts{i}.Symbol
    [tmo,jmo] = getMarketDataViaTDAByPeriod( contracts{i}.Symbol, periodType,date1,date2,frequencyType,frequency,apikey);
   if (~isempty(tmo))
    % [tm,jm]=getMarketTimeData(tmfull);
 
  
   save(name,'tmo','jmo');
   
  disabled=0;
   else
       disp('could not grab data.');
       pause(0.2);
   end
        end
   
   catch exception
       
   end
end

    end

end
%mm=table2timetable(tm)