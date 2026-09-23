apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;
disabled=0;

basedir='Z:\My files\Project trading\traderdata\data\';
numberofdays=200;

contracts_yahoo;
%     contracts={
% genContract([],'BNTX'),...
% };
nc=numel(contracts);

for ds=0:(numberofdays-1)
    
    try
        date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
        % date0=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
        if (isbusday(date0))
            date1=date0;
            date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');
            
            
            for i=1:nc
                try
                    name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' minute ' date1 '.mat'];
                    load(name);
                    fixed=0;
                    dtmd=diff(tm.Date);
                    needsfix=sum(dtmd~=minutes(1))>0;
                    if (needsfix)
                        %disp(name);
                        
                        if (~isempty(tmfull))
                            try
                                
                            badindex=find(dtmd~=minutes(1));
                            
                            [tm_,~]=getMarketTimeData(tmfull);
                            if (size(tm,1)==size(tm_,1))
                            tm(badindex:end,:)=tm_(badindex:end,:);
                            else
                              tm=tm_;  
                            end
                            fixed=1;
                            catch exception
                                exception
                            end
                        else
                            %find fix pattern (All that can be done really)
                            skippedinds=find(dtmd==minutes(2))+1;
                            ns=numel(skippedinds);
                            for j=1:ns
                                try
                                    skippedind=skippedinds(j);
                                    if (dtmd(skippedind+1)==minutes(0))
                                        repeatedindex=skippedind+1;
                                        tm(repeatedindex,:)=tm(skippedind,:);
                                        tm(skippedind,:).Date=(datetime(tm(skippedind,:).Date)-minutes(1));
                                        tm(skippedind,2:7)=table(NaN,NaN,NaN,NaN,NaN,NaN);
                                        
                                        fixed=2;
                                    end
                                catch
                                    
                                end
                            end
                            
                         
                            
                        end
                        
                          disp([num2str(fixed) ':' name]);
                           save(name,'tm','-append');
                    end
                    
             
                      
               
                catch
                    
                end
            end
            
        end
    catch exception
        
    end
end