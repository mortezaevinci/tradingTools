baseclientid=701;
fundamentalTypes={'ReportSnapshot','ReportsFinSummary','ReportsFinStatements','RESC'};%,'ReportRatios','ReportsOwnership','CalendarReport'};
basedir='Z:\My files\Project trading\traderdata\fundamentals\ib\';

contracts_ib;c1=contracts;
contracts_penniesm2;c2=contracts;
contracts_yahoo;c3=contracts;
contracts_nasdaq;c4=contracts;

contracts={c1{:},c2{:},c3{:},c4{:}};
contracts=uniqueContracts(contracts,'FileSymbol');

ib_libraries;
ib_ibWrapperSetup;

%% constants

version='ib';

%% init

ibDataHandler=IbDataHandler;


%% set handles

%all standard handles are available to signal matlab as well

events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerTick = addlistener(ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);
events.eventhandlerOrderStatus = addlistener(ibWrapper,'HandledOrderStatus',@HandledOrderStatusFcn);
events.eventhandlerFundamentalData = addlistener(ibWrapper,'HandledFundamentaldData',@HandledFundamentalDataFcn);

%% connect
port=[4001]; % has to be by TWS live. Not allowed by gateway!
ibClient.ClientId=floor(rand()*10)+baseclientid;

isconnected=ibConnect(ibWrapper,port);

if (isconnected)
    
    
    %% setup
    date0=datestr(datetime(),'yyyy-mm-dd');
    
    for si=1:numel(contracts)
        try
            contract=  contracts{si};
            disp(contract.Symbol);
            ibcontract=getGenericContract(contract);

            for fi=1:numel(fundamentalTypes)
                fundamentalType=fundamentalTypes{fi};
                
                filename=[basedir filefriendlysymbol(contract.FileSymbol) '\' filefriendlysymbol(contract.FileSymbol) ' ' fundamentalType ' ' date0 '.xml'];
                
                if (~exist(filename))
                    if (~exist([basedir]))
                        mkdir([basedir]);
                    end
                    
                    if (~exist([basedir filefriendlysymbol(contract.FileSymbol) '\']))
                        mkdir([basedir filefriendlysymbol(contract.FileSymbol) '\']);
                    end
                    %% get historical data
                    
                    interruptisdone=0;
                    %hasmajorerror=0;
                    ibDataHandler.ResetIbErrorSummary();
                    if (ibClient.ClientSocket.IsConnected()==0)
                        ibClient.ClientId=floor(rand()*10)+baseclientid;
                        isconnected=ibConnect(ibWrapper,port);
                    end
                    
                    if (ibClient.ClientSocket.IsConnected()==1)
                        
                        disp('Cleaning up...');
                        fundamentalmsg='';
                        ibWrapper.CleanUpFundamentalData();
                        pause(0.2);
                        
                        ibWrapper.reqFundamentalData(ibcontract, fundamentalType);
                        disp('waiting for ibwrapper...');
                        skippedbyerror=waitUnlessErrorC(ibWrapper,ibDataHandler,10);
                        pause(0.25);
                        
                        if (~isempty(fundamentalmsg))
                            disp('Saving XML...');
                            fileID = fopen(filename,'w');
                            fprintf(fileID,'%s',fundamentalmsg);
                            fclose(fileID);
                            
                        end
                        
                        
                        ibWrapper.cancelFundamentalData();
                        %pause(0.25);
                        if(~isempty(ibDataHandler.IbErrorSummary.MajorErrorsList))
                        if (ibDataHandler.IbErrorSummary.MajorErrorsList(end)==430 ...
                            || ibDataHandler.IbErrorSummary.MajorErrorsList(end)==321 ...
                            || ibDataHandler.IbErrorSummary.MajorErrorsList(end)==200 )
                            break;
                        end
                        end
                        
                    end
                    
                else
%                    disp('data already exists.');
                end
            end
        catch exception
            dumpReport('error.log', exception)
        end
    end
    
    %% disconnect
    
    ibWrapper.Disconnect();
else
    disp('did not connect');
end


ibClient.ClientSocket.IsConnected()


