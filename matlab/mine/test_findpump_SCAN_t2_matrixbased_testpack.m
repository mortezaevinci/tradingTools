%note this algorithm worked very nice for 2020, but was very bad for years
%before, pointing to this year being exceptional.

date0='2020-12-21';

estbpackfn=['Z:\My files\Project trading\traderdata\data_processed\testpack\nasdaq\testpack pennies daily 1y ' date0 '.mat'];
looperEngine.directories.figures=['Z:\My files\Project trading\traderdata\figures_swing\' date0 '\'];
if (~exist(looperEngine.directories.figures))
mkdir(looperEngine.directories.figures);
end

        if (~exist('testpack'))
        load(testbpackfn);                                                                            
        end
        
        ncontracts=numel(testpack);
        
        orders=cell(0);
        ocnt=1;
        for ci=1:ncontracts
            symbol=testpack{ci}.contract.FileSymbol;
            
                try
                    if (true)
                    params.TimeTables.Day=testpack{ci}.params.TimeTables.Day;
                    chlength=50;
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
                    ispenny=params.TimeTables.Day.Close(end)<15;
                    ispumpable=npump>=1;
                    isvolumeok=mean(params.TimeTables.Day.Volume((end-20):end))>500000;
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
                        o_entry=hy(end)+0.01;
                        o_target=hy(end-1);
                        o_stop=ly(end);
                        tt=[symbol ',' num2str(o_stop) ',' num2str(o_entry) ',' num2str(o_target)];
                        orders{ocnt}=tt;
                        ocnt=ocnt+1;
                        %%show graph
                        
                        if (true)
 
                        f=figure;
                        f.WindowState = 'maximized';
                        cndl5(params.TimeTables.Day);
                        hold on;
                        
                        title(tt);
                        plot([params.TimeTables.Day.Date(end-20) params.TimeTables.Day.Date(end)],[o_entry o_entry],'b');
                        plot([params.TimeTables.Day.Date(end-20) params.TimeTables.Day.Date(end)],[o_target o_target],'g');
                        plot([params.TimeTables.Day.Date(end-20) params.TimeTables.Day.Date(end)],[o_stop o_stop],'r');
                        
                        saveas(f,[looperEngine.directories.figures 'fig_' symbol ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.svg']);
                        saveas(f,[looperEngine.directories.figures '0_fig_' symbol ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.png']);
                        close all;
   
                        end
                        end
                    end
                  
                    end    
                catch exception
                    dumpReport('error.log', exception)
                    
                 end
                
        end
        
        orders
               