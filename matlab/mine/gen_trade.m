base='../../traderdata/data_other/IB/';
perc_win=0.37;
%perc_long=0.8;
date0='2019-01-01';

contracts_main;
cn=numel(contracts);

tdicnt=1;
tradeInfo=cell(0);

fntradeinfo_csv=[base 'tradeinfo' ' ' date0 ' ' '-' ' ' datestr(datetime(),'yyyy-mm-dd HH_MM') '.csv'];
fid = fopen(fntradeinfo_csv, 'a+');
tpl=0;

for day0=0:700

for ci=1:cn
   tradeInfo{tdicnt}.symbol=contracts{ci}.FileSymbol;
    
    date1=datestr(datetime(date0)+days(day0),'yyyy-mm-dd');
    
    fn=[base tradeInfo{tdicnt}.symbol '/' tradeInfo{tdicnt}.symbol ' ' 'minute' ' ' date1 '.mat'];
    tradeInfo{tdicnt}.valid=0;
    
    if (exist(fn))
        load(fn);
        if (exist('tm'))
            ttm=table2timetable(tm);
            minval=min(ttm.Low);
            maxval=max(ttm.High);
            rval=roundRange(ttm.Close(1));
            tradeInfo{tdicnt}.minlvl=ceil(minval/rval(2))*rval(2);
            tradeInfo{tdicnt}.maxlvl=floor(maxval/rval(2))*rval(2);
            if (tradeInfo{tdicnt}.minlvl<tradeInfo{tdicnt}.maxlvl)
                %decide whether
                rand_win=rand<perc_win;
                %rand_long=rand<perc_long;
                
                works_long= (tradeInfo{tdicnt}.minlvl-rval(1) > minval);
                works_short= (tradeInfo{tdicnt}.maxlvl+rval(1) < maxval);
                if (works_long)
                    works_short=0;
                end
                
                if (works_long || works_short)
                    
                    if (works_short)
                        tradeInfo{tdicnt}.ordertype='short';
                        tradeInfo{tdicnt}.plsign=-1;
                        tradeInfo{tdicnt}.stplvl=tradeInfo{tdicnt}.maxlvl+rval(1);
                        tradeInfo{tdicnt}.entry=tradeInfo{tdicnt}.maxlvl+rval(1)*rand*.02-rval(1)*rand*0.2;
                        if (rand_win)
                            tradeInfo{tdicnt}.exit=tradeInfo{tdicnt}.minlvl+rval(1)*rand*.02-rval(1)*rand*0.2;
                        else
                            tradeInfo{tdicnt}.exit=tradeInfo{tdicnt}.stplvl+rval(1)*rand*.02-rval(1)*rand*0.2;
                        end
                    end
                    
                    if (works_long)
                        tradeInfo{tdicnt}.ordertype='long';
                        tradeInfo{tdicnt}.plsign=1;
                        tradeInfo{tdicnt}.stplvl=tradeInfo{tdicnt}.minlvl-rval(1);
                        tradeInfo{tdicnt}.entry=tradeInfo{tdicnt}.minlvl+rval(1)*rand*.02-rval(1)*rand*0.2;
                        if (rand_win)
                            tradeInfo{tdicnt}.exit=tradeInfo{tdicnt}.maxlvl+rval(1)*rand*.02-rval(1)*rand*0.2;
                        else
                            tradeInfo{tdicnt}.exit=tradeInfo{tdicnt}.stplvl+rval(1)*rand*.02-rval(1)*rand*0.2;
                        end
                    end
                    
                    % find the time of entry and exit
                    % first find the candle that contains entry (based on its
                    % position write approx datetime of it happening)
                    % then, find exit (should happen after entry)
                    
                    einds=find(ttm.High > tradeInfo{tdicnt}.entry & ttm.Low < tradeInfo{tdicnt}.entry);
                    if (~isempty(einds))
                        
                        entry_ind=einds(1);
                        entry_approx=(tradeInfo{tdicnt}.entry-ttm.Low(entry_ind))/(ttm.High(entry_ind)-ttm.Low(entry_ind))*(1+0.1*(rand-rand));
                        tradeInfo{tdicnt}.entry_datetime=ttm.Date(entry_ind)+seconds(60*entry_approx);
                        einds=find(ttm.High > tradeInfo{tdicnt}.exit & ttm.Low < tradeInfo{tdicnt}.exit);
                        eii=find(einds > entry_ind);
                        einds=einds(eii);
                        if (~isempty(einds))
                            
                            exit_ind=einds(1);
                            exit_approx=(tradeInfo{tdicnt}.exit-ttm.Low(exit_ind))/(ttm.High(exit_ind)-ttm.Low(exit_ind))*(1+0.1*(rand-rand));
                            tradeInfo{tdicnt}.exit_datetime=ttm.Date(exit_ind)+seconds(60*exit_approx);
                            
                            %define size of trade
                            tradeInfo{tdicnt}.account=10000;
                            tradeInfo{tdicnt}.qty=ceil(tradeInfo{tdicnt}.account/tradeInfo{tdicnt}.entry/20)*20;
                            tradeInfo{tdicnt}.change=((tradeInfo{tdicnt}.exit-tradeInfo{tdicnt}.entry)*tradeInfo{tdicnt}.plsign);
                            tradeInfo{tdicnt}.pl=tradeInfo{tdicnt}.qty* tradeInfo{tdicnt}.change;
                            
                            tpl=tpl+tradeInfo{tdicnt}.pl;
                            
                            
                            
                            fprintf('%s,%s,%d,%0.2f,%s,%0.2f,%s,%0.2f,%0.2f\n',...
                                string(tradeInfo{tdicnt}.symbol),...
                                string(tradeInfo{tdicnt}.ordertype),...
                                tradeInfo{tdicnt}.qty,...
                                tradeInfo{tdicnt}.entry,...
                                datestr(tradeInfo{tdicnt}.entry_datetime,'yyyy-mm-dd hh:MM:ss'),...
                                tradeInfo{tdicnt}.exit,...
                                datestr(tradeInfo{tdicnt}.exit_datetime,'yyyy-mm-dd hh:MM:ss'),...
                                 tradeInfo{tdicnt}.change,...
                                tradeInfo{tdicnt}.pl);
                            
                             fprintf(fid, '%s,%s,%d,%0.2f,%s,%0.2f,%s,%0.2f,%0.2f\n',...
                                string(tradeInfo{tdicnt}.symbol),...
                                string(tradeInfo{tdicnt}.ordertype),...
                                tradeInfo{tdicnt}.qty,...
                                tradeInfo{tdicnt}.entry,...
                                datestr(tradeInfo{tdicnt}.entry_datetime,'yyyy-mm-dd hh:MM:ss'),...
                                tradeInfo{tdicnt}.exit,...
                                datestr(tradeInfo{tdicnt}.exit_datetime,'yyyy-mm-dd hh:MM:ss'),...
                                 tradeInfo{tdicnt}.change,...
                                tradeInfo{tdicnt}.pl);
                            
%                             close all
%                             ax=cndlv(ttm);
%                             hold (ax{1},'on');
%                             plot(ax{1},[ttm.Date(entry_ind)],[tradeInfo{tdicnt}.entry],'g*');
%                             plot(ax{1},[ttm.Date(exit_ind)],[tradeInfo{tdicnt}.exit],'r*');
%                             
%                             pause
                            
                            tradeInfo{tdicnt}.valid=1;
                            tdicnt=tdicnt+1;
                        end
                    end
                end
            end
        end
    end
    
    
end

end

fclose(fid);

fntradeinfo=[base 'tradeinfo' ' ' date0 ' ' '-' ' ' datestr(datetime(),'yyyy-mm-dd HH_MM') '.mat'];
save(fntradeinfo,'tradeInfo');

tpl