%note this algorithm worked very nice for 2020, but was very bad for years
%before, pointing to this year being exceptional.

basedir='Z:\My files\Project trading\traderdata\data\';
processdir='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
        
%date

dtt=datetime();
date='2020-12-11';
dbase=datetime(date);

tradeamt=5000; %$1
numtrades=0;
numsuccesstrades=0;
totfees=0;
tradeact=5000;

minusfeepertradeperc=.999; %1% for buy and 1% for sell, ideally this is 1.0


    datedate=dbase
    
    if (isbusday(datedate))
        date=datestr(datedate,'yyyy-mm-dd');

      
        contracts_nasdaq;
        %contracts_yahoo;
        %contracts_main;
        %contracts={genContract([],'KBLM')};
        
        ncontracts=numel(contracts);
              
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol;
            
                try
                    fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];
                    if (exist(fn))
                    load(fn);
                    params.TimeTables.Day=table2timetable(td);
                    
                    %% check if data
                    
                    if (size(params.TimeTables.Day.Date)<3)
                        continue;
                    end
                    
                    if (~isempty(find(params.TimeTables.Day.Close<0)))
                        continue;
                    end
                    %params.TimeTables.Day=params.TimeTables.Day(1:end-1000,:);
                                     
                    %% for evaluation
                    maxelim=3;
                    truth=eliminateshift(params.TimeTables.Day.Open,0,maxelim);
                    
                    realmode=1; %0=eval, 1=real scan
                    
                    %% todo
                    afterhoursmove_process;
                        
                    if (sum(enter(end:end))==1)
                       disp(symbol); 
                       cndl5(params.TimeTables.Day);
                       hold on
                        plot(params.TimeTables.Day.Date(maxelim+realmode:end-1+realmode),enter.*truth,'b*','markerSize',30);
                       
                       title(symbol);
                       pause
                       close all;
                    end
                       
                    end
                  
                        
                catch exception
                    dumpReport('error.log', exception)
                    
                 end
                
        end
           
    end