%note this algorithm worked very nice for 2020, but was very bad for years
%before, pointing to this year being exceptional.

date0='2020-12-21';

contracts_penniesm2_trade;
contracts={genContract([],'OCGN')};

looperEngine.directories.basedir=['Z:\My files\Project trading\traderdata\data\'];

looperEngine.directories.figures=['Z:\My files\Project trading\traderdata\figures_swing_backtest\' date0 '\'];
if (~exist(looperEngine.directories.figures))
mkdir(looperEngine.directories.figures);
end

        ncontracts=numel(contracts);
        orders=cell(0);
        ocnt=0;
        
        
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol;
            
            fn=[looperEngine.directories.basedir symbol '\' symbol ' daily 1y ' date0 '.mat'];
            if (~exist(fn))
            continue                                                                            
            end
            
            load(fn);
            tempparams.params.TimeTables.Day=table2timetable(td);
            
            
            occnt=0;
            orderclaims=cell(0);
                try
                    chlength=50;
                    
                    dsize=numel(tempparams.params.TimeTables.Day.Date);
                    dstart=min(chlength,dsize);
                    for di=dstart:dsize
                    
                        %% set for backtest
                    params.TimeTables.Day=tempparams.params.TimeTables.Day(1:di,:);
                    chlength=min(50,numel(params.TimeTables.Day.Date)-1);
                    %% check if data
                    
                    if (size(params.TimeTables.Day.Date)<4)
                        continue;
                    end
                    
                    if (~isempty(find(params.TimeTables.Day.Close<0)))
                        continue;
                    end
                    %params.TimeTables.Day=params.TimeTables.Day(1:end,:);
                         
                    sma20=movmean(params.TimeTables.Day.Open,[20 0]);
                    
                    pump=params.TimeTables.Day.Open>2*sma20;
                    dpump=diff(pump);
                    npump=floor(sum(abs(dpump))/2);
                    issmaller=params.TimeTables.Day.Close(end)<0.5*max(params.TimeTables.Day.High);
                    ispenny=params.TimeTables.Day.Close(end)<30;
                    ispumpable=npump>=1;
                    isvolumeok=mean(params.TimeTables.Day.Volume((end-chlength):end))>200000;
                    selected=ispumpable & issmaller & ispenny;
                    %disp(sprintf([symbol ' \t ' num2str(ispenny) '\t' num2str(issmaller) '\t' num2str(ispumpable)]));
                    
                   if (selected)
                        %% find order parameters
                        
                        mindis=min(30,chlength);
                        [hy,hx] = findpeaks(params.TimeTables.Day.High((end-chlength):end-1),params.TimeTables.Day.Date((end-chlength):end-1),'MinPeakDistance',mindis);
                        [ly,lx] = findpeaks(-params.TimeTables.Day.Low((end-chlength):end-1),params.TimeTables.Day.Date((end-chlength):end-1),'MinPeakDistance',mindis);
                        ly=-ly;
                        
                        perctol=0; %5% diff
                        isbaseok=numel(hx)>=2 & numel(lx)>=2;
                        istargetok=(hy(end-1)-hy(end))/hy(end)>perctol & hy(end)>params.TimeTables.Day.High(end);
                        isstopok=ly(end-1)<ly(end) & ly(end)<params.TimeTables.Day.Low(end);
                        sel2=isbaseok & istargetok & isstopok;
                        if (sel2)
                        occnt=occnt+1;
                        orderclaims{occnt}.entry=hy(end)+0.01;
                        orderclaims{occnt}.target=hy(end-1);
                        orderclaims{occnt}.stop=ly(end);
                        orderclaims{occnt}.date0=params.TimeTables.Day.Date(end);
                        orderclaims{occnt}.date1=params.TimeTables.Day.Date(end)+days(5);
                        tt=[symbol ',' num2str(orderclaims{occnt}.stop) ',' num2str(orderclaims{occnt}.entry) ',' num2str(orderclaims{occnt}.target)];
                        ocnt=ocnt+1;
                        orders{ocnt}=tt;
                        
                        
                       
                        
                        end
                    end
                  
                    end 
                    
                    if (occnt>0)
 
                        f=figure;
                        f.WindowState = 'maximized';
                        cndl5(tempparams.params.TimeTables.Day);
                        hold on;
                        
                        title(tt);
                        
                        for oi=1:occnt
                        plot([orderclaims{oi}.date1 orderclaims{oi}.date0],[orderclaims{oi}.entry orderclaims{oi}.entry],'b');
                        plot([orderclaims{oi}.date1 orderclaims{oi}.date0],[orderclaims{oi}.target orderclaims{oi}.target],'g');
                        plot([orderclaims{oi}.date1 orderclaims{oi}.date0],[orderclaims{oi}.stop orderclaims{oi}.stop],'r');
                        end
                        
                        saveas(f,[looperEngine.directories.figures 'fig_' symbol ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.svg']);
                        saveas(f,[looperEngine.directories.figures '0_fig_' symbol ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.png']);
                        close all;
   
                        end
                    
                catch exception
                    dumpReport('error.log', exception)
                    
                 end
                
        end
        
        orders
               