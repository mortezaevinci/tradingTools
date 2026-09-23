
basedir='Z:\My files\Project trading\traderdata\data\';
processdir='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
        
%date

dtt=datetime();
date='2021-01-15';
dbase=datetime(date);

        %contracts_nasdaq;
        %contracts_yahoo;
        contracts_main;
        contracts={genContract([],'GOVX')};
        
        ncontracts=numel(contracts);
              
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol
            
                    fn=[basedir symbol '\' symbol ' daily 5y ' date '.mat'];
                    if (exist(fn))
                    load(fn);
                    params.TimeTables.Day=table2timetable(td);
                    
                    af=[0; params.TimeTables.Day.Open(2:end)-params.TimeTables.Day.Close(1:end-1)];
                    afterhours=cumsum(af);
                    tableintra=stocktable_addnum(params.TimeTables.Day,-afterhours);
                    
                    afterhours=afterhours+tableintra.Open(1);
                    
                    f=figure;
                    f.WindowState = 'maximized';
                    cndl5b(tableintra);
                    hold on;
                    title(symbol);
                    cndl5(params.TimeTables.Day);
                    hold on;
                    plot(tableintra.Date,afterhours);
                    vertical_cursors
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    pause
                    close all
                    end

        end