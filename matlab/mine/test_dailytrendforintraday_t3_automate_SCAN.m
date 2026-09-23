%% libraries

asmp1 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\Release\CSharpAPI.dll'));
asmp2 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\Release\IBBackEnd.dll'));
asmp3 = NET.addAssembly(('Z:\My files\Project trading\repo\matlab\mine\bin\Release\IBControlDefinition.dll'));

asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;
import MHA.IBControlDefinition.*;
import MHA.IBControlDefinition.Tools.*;
import MHA.IBControlDefinition.Tools.Contracts.*;
import IBApi.*;



%% constants
trade_all=0;
trade_win=0;


version='ib';
currentTicker = 0;

%%  %date


dtt=datetime();
date='2020-08-21';%datestr(datetime()-days(1),'yyyy-mm-dd');

dbase=datetime(date);
for di=0:0
    
    datedate=dbase-days(di)
    
    if (isbusday(datedate))
        date=datestr(datedate,'yyyy-mm-dd');
        %% init
        
        signal=EReaderMonitorSignal;
        ibClient=IBClient(signal);
        ibWrapper=IBWrapper(ibClient,signal);
        
        %% set handles
        
        %all standard handles are available to signal matlab as well
        
        eventhandlerError= addlistener(ibWrapper,'HandledError',@HandledErrorFcn);
        
        eventhandlerTick = addlistener(ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);
        eventhandlerOrderStatus = addlistener(ibWrapper,'HandledOrderStatus',@HandledOrderStatusFcn);
        eventhandlerPositions= addlistener(ibWrapper,'HandledPosition',@HandledPositionFcn);
        
        eventhandlerHistoricalDataUpdate= addlistener(ibWrapper,'HandledHistoricalDataUpdate',@HandledHistoricalDataUpdateFcn);
        eventhandlerHistoricalData= addlistener(ibWrapper,'HandledHistoricalData',@HandledHistoricalDataFcn);
        eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@HandledHistoricalDataEnd_getarray_Fcn);
        
        
        %% connect
        port=4002;
        
        ibClient.ClientId=floor(rand()*10)+101;
        
        
        
        annualinflationrate=0.025;
        
        basedir='Z:\My files\Project trading\traderdata\data\';
        processdir='Z:\My files\Project trading\traderdata\data_processed\dailytrendprofile\';
        
        %contracts_nasdaq;
        contracts_yahoo;
        %contracts_main;
        
        %    ibcontractmanager.DataProvider.Historical={'ib'};
        %     ibcontractmanager.DataProvider.RealTime={'ib'};
        %      contracts={genContract(ibcontractmanager,'AAPL')};
        
        ncontracts=numel(contracts);
        
        bearishList=[];
        bullishList=[];
        
        bearishList_over1=[];
        bullishList_over1=[];
        
     
        
        for ci=1:ncontracts
            symbol=contracts{ci}.FileSymbol;
            disp(symbol);
            trendprofiflename=[processdir 'PDTP1 ' symbol ' ID' '3' '.mat'];
            
            if (exist(trendprofiflename))
                load(trendprofiflename);
                try
                    
                    fn=[basedir symbol '\' symbol ' daily 1y ' date '.mat'];
                    if (exist(fn))
                    load(fn);
                    params.TimeTables.Day=table2timetable(td);
                    
                    if (size(params.TimeTables.Day.Date)<10)
                        continue;
                    end
                    
                    %will need next open
                    % get minute in the morning, and attach it to .Day
                    
                    sub_dailytrend_grabpremarketbyIB;
                     
                        if (last==0)
          disp(['security did not have pre-market data']);
         
      continue;
     end
       
                    
                       params.TimeTables.Day.Close(end)= params.TimeTables.Day.Open(end);
                       params.TimeTables.Day.High(end)= params.TimeTables.Day.Open(end);
                       params.TimeTables.Day.Low(end)= params.TimeTables.Day.Open(end);
                     
                    %% process
                    
                    sub_dailytrendprocess;
                    
                  %  allgoodconditions{1}='gapdn & fullgapdn &  strategy_superposition_main_bearish>2';
                  %  allgoodconditions{2}='gapup & fullgapup &  strategy_superposition_main_bullish>2';
                    
                    
                    if (isempty(allgoodconditions{1}))
                        bearish=0;
                    else
                        bearish=eval(allgoodconditions{1});
                    end
                    
                    if (isempty(allgoodconditions{2}))
                        bullish=0;
                    else
                        bullish=eval(allgoodconditions{2});
                    end
                    %disp(['bearish days:' num2str(sum(bearish)) ' bullish days:' num2str(sum(bullish))]);
                    
                    %    sub_dailytrendplot;
                    %  pause;
                    if (bearish(end)>0 && bullish(end)==0)
                        
                        
                        actualmove=params.TimeTables.Day.Open(end)-params.TimeTables.Day.Low(end);
                        expectedmove=    -intradaymovethreshold(end);
                       
                        disp([symbol ' is bearish for a move of ' num2str(expectedmove) ' which happened:' num2str(-actualmove)]);
                        bearishList=[bearishList {symbol}];
                        if (-expectedmove>1)
                             trade_all=trade_all+1;
                        if (actualmove>-expectedmove)
                            trade_win=trade_win+1;
                        end
                        
                            bl.symbol=symbol;
                            bl.expectedmove=expectedmove;
                            bl.target=params.TimeTables.Day.Open(end)+expectedmove;
                            bl.loss=params.TimeTables.Day.Open(end)-expectedmove*3/4;
                            bl.orders_(1).STP=params.TimeTables.Day.Open(end);
                            bl.orders_(1).LMT=params.TimeTables.Day.Open(end)-max(0.2,expectedmove/10);
                            bl.orders_(2).LMT=bl.target;
                            bl.orders_(3).STP=bl.loss;
                            action={'SELL', 'BUY'};
                            disp([bl.symbol  ' ' action{1} ' STPLMT:' num2str(bl.orders_(1).STP),',' num2str(bl.orders_(1).LMT) ,' ' action{2} ' LMT:' num2str(bl.orders_(2).LMT) ' ' action{2} ' STP:' num2str(bl.orders_(3).STP)]);
                            bearishList_over1=[bearishList_over1 bl];
                            
                        %     sub_dailytrendplot;
                         % pause;
                        end
                           
                        %  cndl5(params.TimeTables.Day(end-60:end,:));
                        %  title(['bearish ' symbol]);
                        %  pause;
                    end
                    
                    
                    if (bullish(end)>0&& bearish(end)==0)
                        actualmove=params.TimeTables.Day.High(end)-params.TimeTables.Day.Open(end);
                        expectedmove=    intradaymovethreshold(end);
                        
                        disp([symbol ' is bullish for a move of ' num2str(expectedmove) ' which happened:' num2str(actualmove)]);
                        bullishList=[bullishList {symbol}];
                        if (expectedmove>1)
                            trade_all=trade_all+1;
                        if (actualmove>expectedmove)
                            trade_win=trade_win+1;
                        end
                        
                            bl.symbol=symbol;
                            bl.expectedmove=expectedmove;
                            bl.target=params.TimeTables.Day.Open(end)+expectedmove;
                            bl.loss=params.TimeTables.Day.Open(end)-expectedmove*3/4;
                            bl.orders_(1).STP=params.TimeTables.Day.Open(end);
                            bl.orders_(1).LMT=params.TimeTables.Day.Open(end)+max(0.2,expectedmove/10);
                            bl.orders_(2).LMT=bl.target;
                            bl.orders_(3).STP=bl.loss;
                        action={'BUY','SELL'};
                            disp([bl.symbol ' ' action{1} ' STPLMT:' num2str(bl.orders_(1).STP),',' num2str(bl.orders_(1).LMT) ,' ' action{2} ' LMT:' num2str(bl.orders_(2).LMT) ' ' action{2} ' STP:' num2str(bl.orders_(3).STP)]);
                                 
                            bullishList_over1=[bullishList_over1 bl];
                            
                           %    sub_dailytrendplot;
                        %  pause;
                        end
                        
                        
                        %  cndl5(params.TimeTables.Day(end-60:end,:));
                        %  title(['bullish ' symbol]);
                        %   pause;
                    end
                    
                    end    
                    
                catch exception
                    dumpReport('error.log', exception)
                    
                 end
                
            else
                %disp('Does not exists');
                
            end
        end
        
        ibWrapper.Disconnect();
        
        bearishList_over1
        bullishList_over1
        
        disp(['success rate: ' num2str(trade_win/trade_all*100) '%']);
         sub_dailytrendforintraday_plotintraday;
        pause(3);
       
        
        
    end
    
end