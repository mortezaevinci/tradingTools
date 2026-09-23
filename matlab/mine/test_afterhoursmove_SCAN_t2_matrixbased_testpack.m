%note this algorithm worked very nice for 2020, but was very bad for years
%before, pointing to this year being exceptional.

testbpackfn='Z:\My files\Project trading\traderdata\data_processed\testpack\nasdaq\testpack daily 5y 2020-11-30.mat';

tradeamt=5000; %$1
numtrades=0;
numsuccesstrades=0;
totfees=0;
tradeact=5000;

minusfeepertradeperc=.999; %1% for buy and 1% for sell, ideally this is 1.0

summarydates=(1:2500)';
summarygains=zeros(size(summarydates));

    if (true)
        if (~exist('testpack'))
        load(testbpackfn);                                                                            
        end
        
        ncontracts=numel(testpack);
              
        for ci=1:ncontracts
            symbol=testpack{ci}.contract.FileSymbol;
            
                try
                    if (true)
                    params.TimeTables.Day=testpack{ci}.params.TimeTables.Day;
                    
                    %% check if data
                    
                    if (size(params.TimeTables.Day.Date)<4)
                        continue;
                    end
                    
                    if (~isempty(find(params.TimeTables.Day.Close<0)))
                        continue;
                    end
                    %params.TimeTables.Day=params.TimeTables.Day(1:end,:);
                                     
                    %% for evaluation
                    maxelim=3;
                    truth=eliminateshift(params.TimeTables.Day.Open,0,maxelim);
                    
                    
                    
                    realmode=0; %0=eval, 1=real scan
                    enterdates=eliminateshift(params.TimeTables.Day.Date,1-realmode,maxelim);
                    
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
                        disp(sprintf([symbol ' \t' num2str(totdiff) ' \tgain in ' num2str(sum(enter)) ' trades \tFees=' num2str(sum(buyfee+sellfee)) ' \taccount=' num2str(tradeact)]));
                        
                        dindex=floor(days(enterdates-datetime('2015-01-01')));
                        
                        summarygains(dindex)=summarygains(dindex)+tradesdiff;
                        end
                        
                        %%show graph
                        if (false)
                        if(sum(enter)>0)
                        cndl5(params.TimeTables.Day);
                        hold on;
                        title(symbol);
                        plot(enterdates,enter.*buyat,'b*','markerSize',30);
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
           
           figure
           plot(summarydates,summarygains);
           hold on;
           plot(summarydates,cumsum(summarygains),'r');
    end