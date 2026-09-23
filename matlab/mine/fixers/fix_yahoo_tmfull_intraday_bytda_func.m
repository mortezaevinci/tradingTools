function  fix_yahoo_tmfull_intraday_bytda_func(basedir,contracts,date1,date2)

% this is to fix only tmfull, tm is already fixed.

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='day';
period=1;
frequencyType='minute';
frequency=1;
disabled=0;


for i=1:numel(contracts)
    
    try
        clear version tm tmfull;


        name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' minute ' date1 '.mat'];
        if (exist(name) && isbusday(date1))
            
            load(name);
            
            validsituation=0;
            if (exist('version')==1)
                if ((strcmp(version,'yahoo')==1 || strcmp(version,'yahoo+tda')==1) && exist('tmfull')==1)
                    validsituation=1;
                end
            else
               continue;
                %should already have version in all files

            end
            
            % only care if there are nan values
            hasnan=max(isnan(tmfull.Open));
            if (hasnan==0)
                validsituation=0;
            end
            
            if (validsituation==1)
                
                disp(contracts{i}.Symbol)
                
                [tmfull_tda,~] = getMarketDataViaTDAByPeriod( contracts{i}.Symbol, periodType,date1,date2,frequencyType,frequency,apikey);
                if (~isempty(tmfull_tda))
                    success=0;
                    tmfull_=tmfull_tda;
                    tmsize_=size(tmfull_,1);
                    if (tmsize_>370)
                        tm.Date=datetime(tm.Date);
                        % first generate almost matching volume info for
                        % tda based tm
                        
                        tmnonan=tmfull;
                        tmnonan(isnan(tmfull.Open),:)=[];
                        yvol_ave=sum(tmnonan.Volume)/numel(tmnonan.Volume);
                        
                        tm_nonan=tmfull_;
                        tm_nonan(isnan(tmfull_.Open),:)=[];
                        tvol_ave=sum(tm_nonan.Volume)/numel(tm_nonan.Volume);
                        
                        tmfull_.Volume=tmfull_.Volume*yvol_ave/tvol_ave;
                        
                        % now replace yahoo nan values with tda non-nan
                        % values
                        
                        nanind0=find(isnan(tmfull.Open));
                        
                        % now, apparenly, when yahoo reports nan, it adds
                        % the volume to next non-nan, so next non-nan
                        % should be added
                        nanind2=nanind0+1;
                        
                        nanind=unique([nanind2,nanind0]);
                        
                        
                        tmfull(nanind,:)=tmfull_(nanind,:);
                        version='yahoo+tda+tmfull';
                        save(name,'tmfull','tmfull_tda','version','-append');
                    end
                    
                else
                    disp('could not grab data.');
       pause(0.05);
                end
            end
        end
    catch exception
        
    end
end
end

