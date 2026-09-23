function  fix_yahoo_intraday_bytda_func(basedir,contracts,date1,date2)

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='day';
period=1;
frequencyType='minute';
frequency=1;
disabled=0;



for i=1:numel(contracts)
    
    try
        clear version;
        clear tmfull;
        name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' minute ' date1 '.mat'];
        if (exist(name) && isbusday(date1))
            
            load(name);
            
            validsituation=0;
            if (exist('version')==1)
                if (strcmp(version,'yahoo')==1)
                    validsituation=1;
                end
            else
                if (~exist('tmfull'))
                    validsituation=1;
                end
            end
            
            % only care if there are nan values
            hasnan=max(isnan(tm.Open));
            if (hasnan==0)
                validsituation=0;
            end
            
            if (validsituation==1)
                
                
                [tmfull_tda,jmfull_tda] = getMarketDataViaTDAByPeriod( contracts{i}.Symbol, periodType,date1,date2,frequencyType,frequency,apikey);
                if (~isempty(tmfull_tda))
                    success=0;
                    [tm_,jm_]=getMarketTimeData(tmfull_tda);
                    
                    tmsize_=size(tm_,1);
                    tmsize=size(tm,1);
                    if (tmsize_==tmsize)
                        tm.Date=datetime(tm.Date);
                        % first generate almost matching volume info for
                        % tda based tm
                        
                        tmnonan=tm;
                        tmnonan(isnan(tm.Open),:)=[];
                        yvol_ave=sum(tmnonan.Volume)/numel(tmnonan.Volume);
                        
                        tm_nonan=tm_;
                        tm_nonan(isnan(tm_.Open),:)=[];
                        tvol_ave=sum(tm_nonan.Volume)/numel(tm_nonan.Volume);
                        
                        tm_.Volume=floor(tm_.Volume*yvol_ave/tvol_ave);
                        
                        % now replace yahoo nan values with tda non-nan
                        % values
                        
                        nanind0=find(isnan(tm.Open));
                        
                        % now, apparenly, when yahoo reports nan, it adds
                        % the volume to next non-nan, so next non-nan
                        % should be added
                        nanind2=nanind0+1;
                        
                        nanind=unique([nanind2,nanind0]);
                        
                        
                        tm(nanind,:)=tm_(nanind,:);
                        version='yahoo+tda';
                        save(name,'tm','tmfull_tda','version','-append');
                        disp([name 'fixed.']);
                    end
                    
                else
                    
                    pause(.05);
                end
            end
        end
    catch exception
        
    end
end
end

