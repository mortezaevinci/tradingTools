skipBySkipper=0;

% skip by symbol and date
sid=[contract.Symbol date0];
if (isKey(skipperProfile,sid))
    if (skipperProfile(sid)>2)
        %disp(['skipping ' sid ' by repeated failure profile.']);
        skipBySkipper=1;
    end
end

% skip the whole unavailable symbol
sid=[contract.Symbol];
if (isKey(skipperProfile,sid))
    if (skipperProfile(sid)>5)
        %disp(['skipping ' sid ' by repeated failure profile.']);
        skipBySkipper=1;
    end
end

if (skipBySkipper==0)
    if (strcmp(whattoshow,"TRADES")==1)
        filename=[basedir filefriendlysymbol(contract.FileSymbol) '\' filefriendlysymbol(contract.FileSymbol) ' ' fndataid ' ' date0 '.mat'];
    else
        filename=[basedir filefriendlysymbol(contract.FileSymbol) '\' filefriendlysymbol(contract.FileSymbol) ' ' fndataid ' ' '-' char(whattoshow) ' ' date0 '.mat'];
    end
    
    if (~exist(filename))
        
        %check internet
        while (hasInternet()==0)
            disp('No internet connection...');
            if (FS.Stop())
                break;
            end
            pause(1);
        end
        
        %check farms
        cnth=0;
        while(checkhs==1 && ibDataHandler.historicalFarmOk==0)
            disp('Historical farm not connected...');
            if (FS.Stop())
                break;
            end
            pause(1);
            cnth=cnth+1;
            if (cnth==10)
                cnth=0;
                %% reconnect
                disp('disconnecting ib...');
                ibWrapper.Disconnect();
                ibDataHandler.ResetBase();
                
                port=port(randperm(length(port)));
                ibWrapper.ibClient.ClientId=floor(rand()*10)+baseclientid;
                isconnected=ibConnect(ibWrapper,port);
                
            end
        end
        
        [isconnected,isreset] = getdata_IB_generic_checkConnection(ibDataHandler,ibWrapper,isconnected,baseclientid);
        if (isreset)
            currentTicker = 1;
        end
        
        disp([contract.Symbol  ' @ ' date0 ' ' num2str(si) '/' num2str(nc)]);
        
        exchangeOptions = {"NYSE","ARCA","NASDAQ"};
        numOptions = numel(exchangeOptions);
        
        for i = 0:numOptions
            % might be a case of wrong exchange
            ibDataHandler.IbErrorSummary.Exchange=0;
            if (i>0)
                contract.Exchange=exchangeOptions{i};
            end
            if (operation == 0 )
                [skipperProfile,currentTicker]=getdata_IB_generic_contract_process(basedir,filename,version,timetablename,...
                    contract,date0,ibDataHandler,ibWrapper,currentTicker,skipperProfile,intrpTimeout,errorTimeout,enddatetime_,...
                    duration, barsize, whattoshow , RTHonly, keepuptodate);
            end
            if (operation == 1 )
                [skipperProfile,currentTicker]=getdata_IB_generic_contract_ticks_day(basedir,filename,version,timetablename,...
                    contract,date0,ibDataHandler,ibWrapper,currentTicker,skipperProfile,intrpTimeout,errorTimeout,startdatetime_,...
                    numofticks, whattoshow , RTHonly, ignoreSize,interruptname,ibDataHandlerName,...
                    baseclientid);
                
            end
            if (ibDataHandler.IbErrorSummary.Exchange==0)
                break;
            end
        end
        
        checkhs=1;
    else
        %disp(['data already exists: ' contract.FileSymbol ' @ ' date0]);
        fprintf('.');
    end
    
    if (currentTicker>maxRequestPerConnection)
        ibWrapper.Disconnect();
        ibDataHandler.ResetBase();
        pause(0.5);
    end
    
end