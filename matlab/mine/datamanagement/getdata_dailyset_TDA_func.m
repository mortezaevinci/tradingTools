function getdata_dailyset_TDA_func(basedir,contracts,date0,ndays,inname)

date2=datestr(datetime(date0)+days(1),'yyyy-mm-dd');
date1=datestr(datetime(date2)-days(ndays),'yyyy-mm-dd');
%disp(['from ' datestr(date1) ' to ' datestr(date2)]);
apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='year';
period=1;
frequencyType='daily';
frequency=1;

version='tda';
for i=1:numel(contracts)
    
    try
        name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' daily ' inname ' ' date0 '.mat'];
        
        if (~exist(name) && isbusday(datetime(date0)))
            disp( [contracts{i}.Symbol ' ' version ' from ' datestr(date1) ' to ' datestr(date2)]);
            [td,jd] = getMarketDataViaTDAByPeriod( contracts{i}.Symbol, periodType,date1,date2,frequencyType,frequency,apikey);
            if (~isempty(td))
                % [tm,jm]=getMarketTimeData(tmfull);
                
                directory_=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\'];
                if (~exist(directory_))
                    mkdir(directory_);
                end
                
                save(name,'td','jd','version');
            else
                disp('could not grab data.');
                
                
            end
            pause(1);
        end
        
    catch
        
    end

end

end