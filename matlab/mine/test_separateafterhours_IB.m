
basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
     
%date

dtt=datetime();
date='2021-01-14';
dbase=datetime(date);

        %contracts_nasdaq;
        %contracts_yahoo;
        contracts_main;
        contracts={genContract([],'BB')};
        
        ncontracts=numel(contracts);
              
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol
            
                    fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];
                    fn2=[basedir symbol '\' symbol ' dailyx1y ' date '.mat'];
                    if (exist(fn) & exist(fn2))
                    load(fn);
                    ttd1=table2timetable(td);
                    load(fn2);
                    ttd2=table2timetable(td);
                  
                    premarket=ttd2;
                    premarket.Close=ttd1.Open;
                    postmarket=ttd2;
                    postmarket.Open=ttd1.Close;
                    
                    f=figure;
                    %f.WindowState = 'maximized';
                    cndlv(premarket);
                    f=figure;
                    %f.WindowState = 'maximized';
                    cndlv(postmarket);
                      
                    pause
                    close all
                    end

        end