genfigsdaily=1;

base='Z:\My files\Project trading\traderdata\data_other\IB\';


contracts_penniesm2_trade;
%contracts=genContractsFromSymbols('WWR');

ptfn=['Z:\My files\Project trading\traderdata\test possibletriggers xdiff' datestr(datetime(),'yyyy-mm-dd hh-MM-ss') '.mat']

nc=numel(contracts);
date0='2020-12-28';

figures=['M:\temp\figures_xscan ' date0 '\'];
   if (~exist(figures))
      mkdir (figures);
   end

types={'daily 1y','dailyx1y'};

close all
f=figure%('Visible','off');
f.WindowState = 'maximized';

%possibletriggers need to change to contractTriggers in SCAN to be compatible with
%contracts (indexing wise). Here it is fine because we are collecting
%multiple triggers at different dates
possibletriggers=cell(0);
ptcnt=0;
clear ttd;
for c=1:nc
    try
        
        symbol=contracts{c}.FileSymbol;
        fprintf('%d/%d\t%s ',ci,nc,symbol);
        fg=[figures symbol ' ' date0 '.png'];
        
        
        for i=1:2
            fn=[base symbol '\' symbol ' ' types{i} ' ' date0 '.mat'];
            
            load(fn)
            ttd{i}=table2timetable(td);
            
            %disp(['size of ' num2str(i) ' = ' num2str(size(ttd{i}))]);;
            
        end
        
        dates=intersect(ttd{1}.Date,ttd{2}.Date);
        ttd{1}=ttd{1}(dates,:);
        ttd{2}=ttd{2}(dates,:);
        
        voldiff=ttd{2}.Volume-ttd{1}.Volume;
        
        ttd{1}.Volume=voldiff;
        
        maxLength=30;
        
        smaLength=10;
        outlierMultiplier=2;
        
        atrMultiplier=linearMap(ttd{2}.Open,0,30,2,1.5);
        atrMultiplierTarget=linearMap(ttd{2}.Open,0,30,10,2);
        thresh.stpLmtDiffPerc=linearMap(ttd{2}.Open,0,30,1.05,1.005);
        targetByPerc=linearMap(ttd{2}.Open,-10,30,2,1.1);
        
        aveDiffVol = movmean(shiftpad(voldiff,1),[smaLength 0]);
        
        [atr,tr]=indicators_atr(shiftpad(ttd{2},1),smaLength);
        aveClose= movmean(shiftpad(ttd{2}.Close,1),[smaLength 0]);
        
        sma10= movmean(shiftpad(ttd{2}.Close,1),[10 0]);
        sma50= movmean(shiftpad(ttd{2}.Close,1),[50 0]);
        sma100= movmean(shiftpad(ttd{2}.Close,1),[100 0]);
        sma200= movmean(shiftpad(ttd{2}.Close,1),[200 0]);
        
        matr=atrMultiplier.*atr;
        tatr=atrMultiplierTarget.*atr;
        thresh.movMaxDiffVol = movmax(shiftpad(voldiff,1),[smaLength 0]);
        thresh.maxhigh= movmax(shiftpad(ttd{2}.High,1),[maxLength 0]);
        thresh.Vol=aveDiffVol*outlierMultiplier;
        thresh.Close=aveClose+matr;
        thresh.AbsVol=25000;
        thresh.AbsAtrPerc=.25; %percentile

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
        entry=ttd{2}.High>thresh.maxhigh & entry & ttd{2}.Low<thresh.Close & ttd{2}.High>thresh.Close;
        
         undermajorsma=(shiftpad(ttd{2}.Close,1)<sma50...
            | shiftpad(ttd{2}.Close,1)<sma100...
            | shiftpad(ttd{2}.Close,1)<sma200...
            );
        
        % also superceding
        % if entry exists already in hte earlier few entries,
        % it sholud not trigger again
        priorientry=movmax(shiftpad(entry,1),[5,0]);
        
         %do this after checking priori
        thresh.VolFinal=thresh.Vol;%max(thresh.Vol,thresh.AbsVol); %absVol would cause late triggers on pumps
        
        conditions=[priorientry==0, ...
            shiftpad(ttd{2}.Close,1)<=thresh.Close, ...
            thresh.VolFinal >=thresh.AbsVol, ...
             thresh.movMaxDiffVol>=thresh.AbsVol, ...
             matr./shiftpad(ttd{2}.Close,1)<=thresh.AbsAtrPerc , ...
             shiftpad(ttd{2}.Close,1)>sma10,...
             undermajorsma ...
            ];
        
        %fprintf('conds:[%s]',num2str(conditions));
        
        entry=entry & sum(conditions,2)==7  ;
        
        hasentry=sum(entry)>0;
        
        if (hasentry)
            disp(symbol);
            
            if (genfigsdaily==1)
                title(symbol);
                eplot=entry.*thresh.Close;
                ax=cndlv(ttd{2});
                hold (ax{2},'on');
                plot(ax{2},ttd{2}.Date,thresh.VolFinal);
                plot(ax{2},ttd{2}.Date,thresh.movMaxDiffVol);
                hold (ax{1},'on');
                plot(ax{1},ttd{2}.Date,thresh.Close,'g');
                plot(ax{1},ttd{2}.Date,thresh.Close.*thresh.stpLmtDiffPerc,'g-');
                plot(ax{1},ttd{2}.Date,thresh.Target1,'r-');
                plot(ax{1},ttd{2}.Date,thresh.Target2,'r-');
                plot(ax{1},ttd{2}.Date,aveClose-matr,'r');
                plot(ax{1},ttd{2}.Date,eplot,'m+','MarkerSize',20);
                saveas(f,fg);
                clf(f,'reset')
            end
            
            trigInd=find(entry>0);
            for ti=trigInd'
                try
                    ptcnt=ptcnt+1;
                    possibletriggers{ptcnt}.Symbol=contracts{c}.Symbol;
                    possibletriggers{ptcnt}.EntryLevel=thresh.Close(ti);
                    possibletriggers{ptcnt}.EntryDate=ttd{2}.Date(ti);
                    
                    possibletriggers{ptcnt}.thresh.movMaxDiffVol=thresh.movMaxDiffVol(ti);
                    possibletriggers{ptcnt}.thresh.maxhigh=thresh.maxhigh(ti);
                    possibletriggers{ptcnt}.thresh.Vol=thresh.Vol(ti);
                    
                    possibletriggers{ptcnt}.thresh.DiffVol=voldiff(ti);
                    possibletriggers{ptcnt}.thresh.MAtr=matr(ti);
                    possibletriggers{ptcnt}.thresh.Target1=thresh.Target1(ti);
                    possibletriggers{ptcnt}.thresh.Target2=thresh.Target2(ti);
                    possibletriggers{ptcnt}.thresh.Target=min(thresh.Target1(ti),thresh.Target2(ti));
                    possibletriggers{ptcnt}.thresh.StpLmtDiffPerc=thresh.stpLmtDiffPerc(ti);
                    
                    possibletriggers{ptcnt}.thresh.Close=thresh.Close(ti);
                    possibletriggers{ptcnt}.thresh.AbsVol=thresh.AbsVol;
                    possibletriggers{ptcnt}.thresh.AbsAtrPerc=thresh.AbsAtrPerc;
                    
                    possibletriggers{ptcnt}.BestPossibleDayPerformance=(ttd{2}.High(ti)-thresh.Close(ti));
                    possibletriggers{ptcnt}.WorstPossibleDayPerformance=(ttd{2}.Low(ti)-thresh.Close(ti));
                    
                catch exception
                    
                end
            end
        end
    catch exception
        dumpReport('error.log', exception) 
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
jlist=[1,3];
test_dailyxdiff_volume_observe_backtest_intraday;
    close all