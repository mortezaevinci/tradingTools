filepostfix={'pre','reg','post'};
for j=1:3 % 1=pre,2=regular,3=postmarket
    for i=1:ptcnt
        try
            
            date0=datestr(possibletriggers{i}.EntryDate,'yyyy-mm-dd');
            fn_intra=[base possibletriggers{i}.Symbol '\' possibletriggers{i}.Symbol ' ' 'minute' ' ' date0 '.mat'];
            fg_intra=[figures 'fig_' possibletriggers{i}.Symbol ' intraday ' filepostfix{j} ' ' date0 '.png'];
            
            if (~exist(fn_intra))
                continue;
            end
            
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
                    
                    entry=ttm.Open(1)<possibletriggers{i}.EntryLevel ...
                        & premax < possibletriggers{i}.EntryLevel ...
                        & ttm.Close > possibletriggers{i}.EntryLevel ...
                        & ttm.Volume > possibletriggers{i}.thresh.Vol ...
                        & ttm.Volume > possibletriggers{i}.thresh.movMaxDiffVol ...
                        & shiftpad(ttm.Open,1) < possibletriggers{i}.EntryLevel;
                    
                    if (j==1)
                        entry(dateind(end):end)=0; %only pre-market
                    end
                    
                    if (j==2)
                        %entry(dateind(end):end)=0; %only pre-market
                    end
                    
                    if (j==3)
                        entry(1:dateind(1))=0; %only pre-market
                    end
                    
                    hasentry=sum(entry)>0;
                    
                    if (hasentry)
                        eplot=entry.*ttm.Close;

                        ax=cndlv(ttm);
                        hold (ax{1},'on');
                        hold (ax{2},'on');
                        plot(ax{1},ttm.Date,eplot);
                        
                        val=possibletriggers{i}.EntryLevel-possibletriggers{i}.thresh.MAtr; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'r');
                        val=possibletriggers{i}.thresh.Target; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'r');
                        val=possibletriggers{i}.EntryLevel; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'g');
                        val=possibletriggers{i}.thresh.maxhigh; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val],'b');
                        %val=possibletriggers{i}.thresh.Close; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val]);
                        %val=possibletriggers{i}.thresh.AbsVol; plot(ax{1},[ttm.Date(1) ttm.Date(end)],[val val]);
                        val=possibletriggers{i}.thresh.Vol; plot(ax{2},[ttm.Date(1) ttm.Date(end)],[val val],'g');
                        val=possibletriggers{i}.thresh.movMaxDiffVol; plot(ax{2},[ttm.Date(1) ttm.Date(end)],[val val],'b');
                        saveas(f,fg_intra);
                        clf(f,'reset')
                    end
                end
            end
        catch exception
            dumpReport('error.log', exception)
        end
    end
end