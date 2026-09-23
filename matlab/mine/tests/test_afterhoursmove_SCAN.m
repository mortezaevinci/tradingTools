basedir='Z:\My files\Project trading\traderdata\data\';
processdir='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
        
%date

dtt=datetime();
date='2020-11-30';
dbase=datetime(date);

tradeamt=1; %$1


    datedate=dbase
    
    if (isbusday(datedate))
        date=datestr(datedate,'yyyy-mm-dd');

      
        contracts_nasdaq;
        %contracts_yahoo;
        %contracts_main;
        %contracts={    genContract([],'AAPL')    };
        
        ncontracts=numel(contracts);
              
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol;
            disp(symbol);

                try
                    fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];
                    if (exist(fn))
                    load(fn);
                    params.TimeTables.Day=table2timetable(td);
                   
                    while(1)
                    
                    %% for evaluation
                    
                    truth=params.TimeTables.Day.Open(end);
                    params.TimeTables.Day=params.TimeTables.Day(1:end-1,:);
                    
                    %% check if data
                    
                    if (size(params.TimeTables.Day.Date)<3)
                        break;
                    end
                    
                    %epnny stock only
                     if (size(params.TimeTables.Day.Close)>50)
                        break;
                    end
                    
                    %% todo
                    dd0=params.TimeTables.Day.Close(end)-params.TimeTables.Day.Open;
                    dd1=params.TimeTables.Day.Close(end-1)-params.TimeTables.Day.Open(end-1);
                    dd2=params.TimeTables.Day.Close(end-2)-params.TimeTables.Day.Open(end-2);
                    af0=params.TimeTables.Day.Open-params.TimeTables.Day.Close(end-1);
                    af1=params.TimeTables.Day.Open(end-1)-params.TimeTables.Day.Close(end-2);
                    %buy signal
                    if ( dd0>0 & dd1>0 & dd2<0 & af0<0 & af1<0)
                        buyat=params.TimeTables.Day.Close(end);
                        sellat=truth;
                        percgain=sellat/buyat;
                        tradeamt=tradeamt.*percgain
                    end
                    
                    end %while
                    
                    end    
                catch exception
                    dumpReport('error.log', exception)
                    
                 end
                
        end
         
    end