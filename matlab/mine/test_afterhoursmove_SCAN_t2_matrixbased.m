%note this algorithm worked very nice for 2020, but was very bad for years
%before, pointing to this year being exceptional.

basedir='Z:\My files\Project trading\traderdata\data\';
processdir='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
        
%date

dtt=datetime();
date='2020-11-30';
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
                    fn=[basedir symbol '\' symbol ' daily 5y ' date '.mat'];
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
                        
                        buyat=params.TimeTables.Day.Close(3:end-1)./minusfeepertradeperc;
                        sellat=params.TimeTables.Day.Open(4:end).*minusfeepertradeperc;
                        qty=tradeamt./buyat;
                        %percgain=(sellat-buyat)./buyat;
                        %trade=(enter.*percgain)+1;
                        %tradep=prod(trade);
                        
                        tradesdiff=enter.*(sellat-buyat).*qty;
                        totdiff=sum(tradesdiff);
                        
                        %ib fee scheme, >1 <1% of trade, $.005 per share
                        buyfee=enter.*qty*.005;
                        buyfee(buyfee>0 & buyfee<1)=1;
                        buyfee(buyfee>tradeamt*.01)=tradeamt*.01;
                        sellfee=enter.*qty*.005;
                        sellfee(sellfee>0 & sellfee<1)=1;
                        sellfee(sellfee>tradeamt*.01)=tradeamt*.01;
                        totdiff=totdiff-sum(buyfee)-sum(sellfee);
                        if (~isnan(totdiff) & sum(enter)>0)
                        tradeact=tradeact+totdiff;
                        totfees=totfees+sum(buyfee+sellfee);
                        numsuccesstrades=numsuccesstrades+sum(tradesdiff>0);
                        numtrades=numtrades+sum(enter);
                        disp([symbol ' ' num2str(totdiff) ' gain in ' num2str(sum(enter)) ' trades. Fees=' num2str(sum(buyfee+sellfee)) ' account=' num2str(tradeact)]);
                        end
                        
                        %%show graph
                        if (false)
                        if(sum(enter)>0)
                        cndl5(params.TimeTables.Day);
                        hold on;
                        title(symbol);
                        plot(params.TimeTables.Day.Date(3:end-1),enter.*buyat,'b*','markerSize',30);
                        pause;
                        close all;
                        end
                        end
                    end
                  
                        
                catch exception
                    dumpReport('error.log', exception)
                    
                 end
                
        end
         
           disp(['total number of trades:' num2str(numtrades)]);
           disp(['sucvess rate:' num2str(numsuccesstrades/numtrades)]);
           disp(['total fees of trades:' num2str(totfees)]);      
    end