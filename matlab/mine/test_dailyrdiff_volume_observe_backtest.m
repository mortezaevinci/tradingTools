base='Z:\My files\Project trading\traderdata\data_other\IB\';
figures='Z:\My files\Project trading\traderdata\figures_rscan\';

date0='2020-12-24';
ptfn=['Z:\My files\Project trading\traderdata\possibletriggers rdiff' datestr(datetime(),'yyyy-mm-dd hh-MM-ss') '.mat']
contracts_penniesm2_trade;

nc=numel(contracts);

type='daily 1y';

close all
f=figure('Visible','off');
f.WindowState = 'maximized';

%possibletriggers need to change to contractTriggers in SCAN to be compatible with
%contracts (indexing wise). Here it is fine because we are collecting
%multiple triggers at different dates
possibletriggers=cell(0);
ptcnt=0;

for c=1:nc
    try
        
        symbol=contracts{c}.FileSymbol;
        
        fg=[figures 'fig_' symbol ' ' date0 '.png'];
        
        fn=[base symbol '\' symbol ' ' type ' ' date0 '.mat'];
        
        load(fn)
        ttd=table2timetable(td);
        voldiff=ttd.Volume;
        
        maxLength=30;
        smaLength=10;
        outlierMultiplier=2;
        
        atrMultiplier=linearMap(ttd{2}.Open,0,30,2,1.5);
        atrMultiplierTarget=linearMap(ttd{2}.Open,0,30,10,2);
        thresh.stpLmtDiffPerc=linearMap(ttd{2}.Open,0,30,1.05,1.005);
        targetByPerc=linearMap(ttd{2}.Open,-10,30,2,1.1);
        
        aveDiffVol = movmean(shiftpad(voldiff,1),[smaLength 0]);
        
        [atr,tr]=indicators_atr(shiftpad(ttd,1),smaLength);
        aveClose= movmean(shiftpad(ttd.Close,1),[smaLength 0]);
        matr=atrMultiplier.*atr;
        tatr=atrMultiplierTarget.*atr;
        thresh.movMaxDiffVol = movmax(shiftpad(voldiff,1),[smaLength 0]);
        thresh.maxhigh= movmax(shiftpad(ttd.High,1),[maxLength 0]);
        thresh.Vol=aveDiffVol*outlierMultiplier;
        thresh.Close=aveClose+matr;
        thresh.AbsVol=25000;
        thresh.AbsAtrPerc=.1; %percentile

        thresh.Target1=thresh.Close+tatr;
        thresh.Target2=thresh.Close.*targetByPerc;
        
        %full pre-conditions
        entry= matr./ttd{2}.Close<thresh.AbsAtrPerc;% & voldiff>thresh.AbsVol;
        
        %main conditions
        entry= entry ...& matr>shiftpad(matr,1) ...
        & voldiff> thresh.movMaxDiffVol ...
            & voldiff>thresh.Vol;
        
        %secondary for final intraday check
        % we want the thing to be actually buyable
        % this is still WRONG because we don't know if
        % the low happened after or before trigger
        % order would be valid if low happened before trigger
        % until we look at intraday (next step)
        % for now, this is to filter out obvious cases)
        % the same to some degree is true for High, we sure know high happens
        % at some point, but not sure if good for premarket
        entry=ttd.High>thresh.maxhigh & entry & ttd.Low<thresh.Close & ttd.High>thresh.Close;
        
        % also superceding
        % if entry exists already in hte earlier few entries,
        % it sholud not trigger again
        priorientry=movmax(shiftpad(entry,1),[5,0]);
        
         %do this after checking priori
         thresh.VolFinal=thresh.Vol;%max(thresh.Vol,thresh.AbsVol); %absVol would cause late triggers on pumps
       
        
        entry=entry & priorientry==0 ...
            & shiftpad(ttd{2}.Close,1)<=thresh.Close ...
            & thresh.VolFinal >=thresh.AbsVol ...
            & thresh.movMaxDiffVol>=thresh.AbsVol ...
            & matr(end)/ttd{2}.Close(end)<=thresh.AbsAtrPerc ...
            ;
        
        hasentry=sum(entry)>0;
        
        if (hasentry)
            disp(symbol);
            
            if (~exist(fg))
                title(symbol);
                eplot=entry.*thresh.Close;
                ax=cndlv(ttd);
                hold (ax{2},'on');
                plot(ax{2},ttd.Date,thresh.Vol);
                plot(ax{2},ttd.Date,thresh.movMaxDiffVol);
                hold (ax{1},'on');
                plot(ax{1},ttd.Date,thresh.Close,'g');
                plot(ax{1},ttd.Date,thresh.Close.*thresh.stpLmtDiffPerc,'g-');
                plot(ax{1},ttd.Date,thresh.Target1,'r-');
                plot(ax{1},ttd.Date,thresh.Target2,'r-');
                plot(ax{1},ttd.Date,aveClose-matr,'r');
                plot(ax{1},ttd.Date,eplot,'m+','MarkerSize',20);
                saveas(f,fg);
                clf(f,'reset')
            end
            
            trigInd=find(entry>0);
            for ti=trigInd'
                try
                    ptcnt=ptcnt+1;
                    possibletriggers{ptcnt}.Symbol=contracts{c}.Symbol;
                    possibletriggers{ptcnt}.EntryLevel=thresh.Close(ti);
                    possibletriggers{ptcnt}.EntryDate=ttd.Date(ti);

                    possibletriggers{ptcnt}.thresh.movMaxDiffVol=thresh.movMaxDiffVol(ti);
                    possibletriggers{ptcnt}.thresh.maxhigh=thresh.maxhigh(ti);
                    possibletriggers{ptcnt}.thresh.Vol=thresh.Vol(ti);
                    
                    possibletriggers{ptcnt}.thresh.DiffVol=voldiff(ti);
                    possibletriggers{ptcnt}.thresh.Target1=thresh.Target1(ti);
                    possibletriggers{ptcnt}.thresh.Target2=thresh.Target2(ti);
                    possibletriggers{ptcnt}.thresh.Target=min(thresh.Target1(ti),thresh.Target2(ti));
                    possibletriggers{ptcnt}.thresh.StpLmtDiffPerc=thresh.stpLmtDiffPerc(ti);
                    
                    possibletriggers{ptcnt}.thresh.Close=thresh.Close(ti);
                    possibletriggers{ptcnt}.thresh.AbsVol=thresh.AbsVol;
                    possibletriggers{ptcnt}.thresh.AbsAtr=thresh.AbsAtr;
                    
                    possibletriggers{ptcnt}.BestPossibleDayPerformance=(ttd.High(ti)-thresh.Close(ti));
                    possibletriggers{ptcnt}.WorstPossibleDayPerformance=(ttd.Low(ti)-thresh.Close(ti));
                    
                catch exception
                    
                end
            end
        end
    catch exception
        exception
    end
end

bestup=0;
worstdn=0;
invest=1000;
for i=1:ptcnt
    qty=invest/possibletriggers{i}.EntryLevel;
    bestup=bestup+possibletriggers{i}.BestPossibleDayPerformance*qty;
    worstdn=worstdn+possibletriggers{i}.WorstPossibleDayPerformance*qty;
end

bestup
worstdn
rr=bestup/-worstdn

save(ptfn,'possibletriggers');
ptcnt=numel(possibletriggers);

test_dailyrdiff_volume_observe_backtest_intraday;
close all