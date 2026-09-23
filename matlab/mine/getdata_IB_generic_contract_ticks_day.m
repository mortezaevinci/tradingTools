function [skipperProfile,currentTicker]=getdata_IB_generic_contract_ticksbyday(basedir,filename,version,timetablename,...
    contract,date0,ibDataHandler,ibWrapper,currentTicker,skipperProfile,intrpTimeout,errorTimeout,startdatetime_, numofticks,...
    whattoshow , RTHonly, ignoreSize,interruptname,ibDataHandlerName,...
    baseclientid)

if (~exist([basedir filefriendlysymbol(contract.FileSymbol) '\' ]))
    mkdir([basedir filefriendlysymbol(contract.FileSymbol) '\' ]);
end
%% get historical ticks
ibcontract=getGenericContract(contract);


if (ibWrapper.ibClient.ClientSocket.IsConnected()==1)
    tickslast = [];
    eval([timetablename{1} '=[];']);
    timedout = 0;
    leaked = false;
    datasuccess=0;
    repeated = 0;
    while (true)
        repeated=repeated+1;
        if (repeated > 3)
            tickslast=[];
        break;
        end
        timedout = 0;
        startdatetime = date2dateib(startdatetime_)
        fprintf('Clean up>');
        ibDataHandler.ResetBase();
        ibWrapper.CleanupHistoricalTick();
        fprintf('Request>');
        ibDataHandler.reqid = ibWrapper.HISTORICAL_TICKS_ID_BASE + currentTicker;
        
        ibWrapper.reqHistoricalTicks(ibDataHandler.reqid, ibcontract, startdatetime, '', numofticks,...
            whattoshow , RTHonly, ignoreSize, NET.createArray('IBApi.TagValue',0));
        currentTicker=currentTicker+1;
        
        skippedbyerror=waitUnlessErrorC(ibWrapper,ibDataHandler,errorTimeout);
        
        if (skippedbyerror==0)
            if (ibDataHandler.Interrupt(interruptname)==0)
                fprintf('Interrupt...');
            end
            d0=datetime();
            while(ibDataHandler.Interrupt(interruptname)==0)
                pause(.2);
                d1=datetime();
                if (seconds(d1-d0)>intrpTimeout)
                    timedout = 1;
                    break
                end
            end
        end
        fprintf('>');
        pause(0.1);
        isconnected=ibWrapper.ibClient.ClientSocket.IsConnected();
        [isconnected,isreset] = getdata_IB_generic_checkConnection(ibDataHandler,ibWrapper,isconnected,baseclientid);
        if (isreset)
            continue;
        end
        
        if (timedout==0 && strcmp(timetablename{1},timetablename))
            tickslast_sub=eval(ibDataHandlerName); %ibDataHandler.historicalTicksLast;
            if (isempty(tickslast_sub))
                continue;
            end
            repeated=0;
            datasuccess=1;
            %Decide whether we leaked into tomorrow,
            
            looksend = isempty(tickslast_sub) || (size(tickslast_sub,1)<=500 && tickslast_sub.Date(end).Hour >= 19 );
            leaked = looksend || tickslast_sub.Date(end).Day ~= startdatetime_.Day;
            %if not leaked to tomorrow,
            %remove last second, and set new startdatetime_
            newstartdatetime_ = tickslast_sub.Date(end);
            if (tickslast_sub.Date(end) == startdatetime_)
                startdatetime_ = startdatetime_+seconds(1);
            else
                % BID_ASK from IB seems to have a bug and still show old
                % dates in requested data
                tickslast_sub = tickslast_sub(tickslast_sub.Date >= startdatetime_,:);
                
                
                % to not include the last second, and reinclude it in the
                % next run to exclude repeated data
                startdatetime_ = tickslast_sub.Date(end);
                tickslast_sub = tickslast_sub(tickslast_sub.Date ~=startdatetime_,:);
                % if we leaked into tomorrow and cut off tomorrow
                if (leaked)
                    tickslast_sub = tickslast_sub(tickslast_sub.Date.Day == startdatetime_.Day,:);
                end
                % append to tickslast
                if (isempty(tickslast))
                    tickslast = tickslast_sub;
                else
                    tickslast=[tickslast;tickslast_sub];
                end
                % if we leaked into tomorrow, and break
                if (leaked)
                    break;
                end
            end
        end
    end
    
    % this name 'tickslast' at this point cannot be changed because it is
    % already used in all files.
    if (~isempty(tickslast) && leaked)
        save(filename,'tickslast','version');
    end
    
    if (datasuccess==0)
        skipperProfile=getdata_IB_generic_manageDataSuccess(ibDataHandler,contract,skipperProfile,date0);
    end
    
    
    
end

end
