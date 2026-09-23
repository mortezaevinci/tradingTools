dographs=0;
RPL=0;
WUPL=0;

% getdata_IB_generic_config_intraday_pennies_dateless;
% getdata_IB_generic_init;
% checkhs=0;
% shutdown=0;

contracts_penniesm2_trade;
nc=numel(contracts);

filepostfix={'pre','reg','post'};
for j=jlist % 1=pre,2=regular,3=postmarket
    
    datefs=fieldnames(entryForTomorrows);
    nd=numel(datefs);
    for k=1:nd
        datef=cell2mat(datefs(k));
        nci=numel(entryForTomorrows.(datef));
        for ci=1:nci
            
            try
                %contract=contracts{ci};
                %fsym=contract.FileSymbol;
                selectedtrigger=contractTriggers.(datef)(ci,:);
                sym=cell2mat(contractTriggers.(datef)(ci,:).Symbol);
                fsym=filefriendlysymbol(sym);
                date0=[datef(2:5) '-' datef(6:7) '-' datef(8:9)];
                
                fn_intra=[base fsym '\' fsym ' ' 'minute' ' ' date0 '.mat'];
                fg_intra=[figures fsym ' intraday ' filepostfix{j} ' ' date0 '.png'];
                
                if(~exist(fn_intra))
                    si=ci;
                    dateib=datestr(datetime(date0),'yyyymmdd');
                    enddatetime = [dateib ' 22:00:00']; %//empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false
                    
%                     getdata_IB_generic_contract;
%                     if(~exist(fn_intra))
%                         disp('intraday not found');
%                         continue;
%                     end
                end
                tmfull=[];
                load(fn_intra);
                
                if (~exist('tmfull'))
                    disp('no tmfull data');
                else
                    if (~exist(fg_intra))
                        ttm=table2timetable(tmfull);
                        ttm.Volume=cumsum(ttm.Volume);
                        
                        %now intraday conditions
                        [h,m,s]=hms(ttm.Date);
                        mins=h*60+m;
                        if (j==1)
                            dateind=find(mins<570);
                        end
                        if (j==2)
                            dateind=find(mins>=570 & mins<=960);
                        end
                        if (j==3)
                            dateind=find(mins>960);
                            ttm.Volume(dateind)= ttm.Volume(dateind)- ttm.Volume(dateind(1));
                        end
                        
                        premax=cummax(shiftpad(ttm.High,1));
                        
                        entry= ttm.High > selectedtrigger.ThEntryStp ...
                            & ttm.Low < selectedtrigger.ThEntryLmt...
                            & ttm.Volume > selectedtrigger.ThVol;
                        
                        
                        if (j==1)
                            if (isempty(dateind)); continue; end
                            entry(dateind(end):end)=0; %only pre-market
                        end
                        
                        if (j==2)
                            %entry(dateind(end):end)=0; %only pre-market
                        end
                        
                        if (j==3)
                            if (isempty(dateind)); continue; end
                            entry(1:dateind(1))=0; %only pre-market
                        end
                        
                        hasentry=sum(entry)>0;
                        
                        
                        
                        if (hasentry)
                            %eval
                            eind=find(entry>0);
                            firstentry=eind(1);
                            ttme=ttm(firstentry:end,:);
                            trailmove=cummax(ttme.High);
                            traildmove=trailmove-trailmove(1);
                            trail=traildmove+selectedtrigger.ThEntryStp-selectedtrigger.ThTrailAmt;
                            trailStped=find(ttme.Low<=trail);
                            targetReached=find(ttme.High>=selectedtrigger.ThTarget);
                            qty=1000/selectedtrigger.ThEntryStp;
                            realizedPL=0;
                            worstUnrealizedPL=0;
                            if (~isempty(targetReached))
                                realizedPL=(selectedtrigger.ThTarget-selectedtrigger.ThEntryStp)*qty;
                            elseif (~isempty(trailStped))
                                
                                stpedat=trail(trailStped(1));
                                realizedPL=(stpedat-selectedtrigger.ThEntryStp)*qty;
                            else
                                worstUnrealizedPL=(trail(end)-selectedtrigger.ThEntryStp)*qty;
                            end
                            RPL=RPL+realizedPL;
                            WUPL=WUPL+worstUnrealizedPL;
                            
                            %graphs
                            if (dographs)
                                eplot=entry.*ttm.Close;
                                ax=cndlv(ttm);
                                hold (ax{1},'on');
                                hold (ax{2},'on');
                                plot(ax{1},ttm.Date,eplot);
                                plot(ax{1},ttme.Date,trail,'r--');
                                val=selectedtrigger.ThEntryStp-selectedtrigger.ThMAtr; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'r');
                                val=selectedtrigger.ThTarget; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'r');
                                val=selectedtrigger.ThEntryStp; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'g');
                                val=selectedtrigger.ThEntryLmt; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'g-');
                                %val=selectedtrigger.thresh.MaxHigh; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'b');
                                val=selectedtrigger.ThVol; plot(ax{2},[ttm.Date(1) ttm.Date(end)],[val val],'g');
                                val=selectedtrigger.ThDiffVolMax; plot(ax{2},[ttm.Date(1) ttm.Date(end)],[val val],'b');
                                saveas(f,fg_intra);
                                clf(f,'reset')
                            end
                            
                            
                            
                            
                            
                        end
                    end
                end
            catch exception
                dumpReport('error.log', exception)
            end
        end
    end
end


ibWrapper.Disconnect();
getdata_IB_generic_close;

RPL
WUPL