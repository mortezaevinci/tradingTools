%compare ib and yahoo volume

contracts_ib;

basedate='2021-01-15';

for c=1:numel(contracts)
    try
        symbol=contracts{c}.FileSymbol
        
        d1=['Z:\My files\Project trading\traderdata\data_other\IB\' symbol '\' symbol ' daily 1y ' basedate '.mat'];
        
        load(d1);
        ttd=table2timetable(td);
        
        
        for i=0:350
            try
                dd=datetime(basedate,'TimeZone',ttd.Date(1).TimeZone)-days(i);
                ds=datestr(dd,'yyyy-mm-dd');
                dd=datetime([ds ' 00:00:00'],'TimeZone',ttd.Date(1).TimeZone);
                if (isbusday(dd))
                    
                    tr=timerange(dd-hour(3),dd+hours(16));
                    daily=ttd(tr,:);
                    
                    d2=['Z:\My files\Project trading\traderdata\data_other\IB\' symbol '\' symbol ' minute ' ds '.mat'];
                    if (exist(d2))
                        
                        load(d2);
                        t2=mean(tm.Open(1));
                        
                        t1=daily.Open;
                        
                        %disp(['symbol=' symbol ' date=' ds ' ib open=' num2str(t2) ' daily open=' num2str(daily.Open)]);
                        
                        if (t1/t2>1.015 | t1/t2<0.985)
                            
                            disp(['removed : ' d2]);
                            delete(d2);
                        end
                    end
                end
            catch exception
                disp(exception.message);
            end
        end
    catch exception
         disp(exception.message);
    end
end