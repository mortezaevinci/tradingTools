function [skipperProfile,currentTicker]=getdata_IB_generic_contract_process(basedir,filename,version,timetablename,...
    contract,date0,ibDataHandler,ibWrapper,currentTicker,skipperProfile,intrpTimeout,errorTimeout,enddatetime_, duration,...
    barsize, whattoshow , RTHonly, keepuptodate)

enddatetime = date2dateib(enddatetime_);
if (~exist([basedir filefriendlysymbol(contract.FileSymbol) '\' ]))
    mkdir([basedir filefriendlysymbol(contract.FileSymbol) '\' ]);
end
%% get historical data
ibcontract=getGenericContract(contract);
%and put it in some timetable
%tmfull=[];
%eval([timetablename{1} '=[];']);
ibDataHandler.ResetBase();


if (ibWrapper.ibClient.ClientSocket.IsConnected()==1)
    % ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
    fprintf('Clean up>');
    ibWrapper.CleanUpHistoricalData();
    ibWrapper.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time
    fprintf('Request>');
    ibDataHandler.reqid = ibWrapper.HISTORICAL_ID_BASE + currentTicker;
    
    ibWrapper.reqHistoricalData(ibDataHandler.reqid, ibcontract, enddatetime, duration, barsize,whattoshow , RTHonly, 1, keepuptodate, NET.createArray('IBApi.TagValue',0));
    currentTicker=currentTicker+1;
    
    skippedbyerror=waitUnlessErrorC(ibWrapper,ibDataHandler,errorTimeout);
    
    if (skippedbyerror==0)
        if (ibDataHandler.interruptIsDone==0)
            fprintf('Interrupt...');
        end
        d0=datetime();
        while(ibDataHandler.interruptIsDone==0)
            pause(.1);
            d1=datetime();
            if (seconds(d1-d0)>intrpTimeout)
                break
            end
        end
    end
    fprintf('>');
    pause(0.2);
    
    if (ibWrapper.RequestEnded==0 && ibWrapper.HistoricalDataMessages.Count>0)
        disp('no interrupt, but there is data...');
        ibDataHandler.HandledHistoricalDataEnd_getarray_Fcn(ibWrapper,0);
    end
    datasuccess=0;
    if (strcmp(timetablename{1},'td'))
        td=ibDataHandler.historicalData;
        disp(['grabbed all tdsize=' num2str(size(td,1))]);
        if (~isempty(td))
            save(filename,'td','version');
            datasuccess=1;
        end
    end
    if (strcmp(timetablename{1},'tmfull'))
        tmfull=ibDataHandler.historicalData;
        disp(['grabbed all at ' date0 ' tmfullsize=' num2str(size(tmfull,1))]);
        if (~isempty(tmfull))
            [tm,~]=getMarketTimeData(tmfull);
            disp(['grabbed all at ' date0 ' tmsize=' num2str(size(tm,1))]);
            save(filename,'tm','tmfull','version');
            datasuccess=1;
        end
    end
    
    if (strcmp(timetablename{1},'tm'))
        tm=ibDataHandler.historicalData;
        disp(['grabbed all at ' date0 ' tmsize=' num2str(size(tm,1))]);
        if (~isempty(tm))
            save(filename,'tm','version');
            datasuccess=1;
        end
    end
    
    if (datasuccess==0)
        skipperProfile=getdata_IB_generic_manageDataSuccess(ibDataHandler,contract,skipperProfile,date0);
    end
    
    
end

end
