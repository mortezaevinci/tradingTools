nc=numel(contracts);
for ci=1:nc
    try
        isf=isfield(contractDetailsMap,fieldfriendlysymbol(contracts{ci}.Symbol));
        if (isf)
            ise=isempty(fieldnames(contractDetailsMap.(fieldfriendlysymbol(contracts{ci}.Symbol))));
        end
        
        if (~isf || ise)
            

            
            %% setup
            
            ibcontract=getGenericContract(contracts{ci});
            ibWrapper.CleanUpContractDetails();
            ibDataHandler.ResetBase();            
            ibWrapper.ibClient.ClientSocket.reqContractDetails(reqid, ibcontract);
            reqid=reqid+1;
            disp('waiting for ibwrapper...');
            skippedbyerror=waitUnlessErrorC(ibWrapper,ibDataHandler,5);
            if (skippedbyerror==0)
                disp('waiting for interrupt...');
                waitForInterruptC(ibDataHandler,'contractdetails',5);
            end
            
           % pause(0.1);
            
            %add key
            try
            if (~isempty(ibDataHandler.contractDetails))
                try
                if (strcmp(contracts{ci}.Symbol,ibDataHandler.contractDetails.Contract.Symbol)==0)
                    disp(['Unmatching symbol ' fieldfriendlysymbol(contracts{ci}.Symbol) ' != ' ibDataHandler.contractDetails.MarketName]);
                    pause(1);
                else
                    contractDetailsMap.(fieldfriendlysymbol(contracts{ci}.Symbol))=ibDataHandler.contractDetails;
                end
                catch
                    
                end
            end
            catch
                
            end

            cnth=0;
            while(ibDataHandler.historicalFarmOk==0)
                disp('Historical farm not connected...');                pause(1);
                cnth=cnth+1;
                if (cnth==50)
                    cnth=0;
                    %% reconnect
                    disp('disconnecting ib...');
                    ibWrapper.Disconnect();
                    ibClient.ClientId=floor(rand()*10)+baseclientid;
                    isconnected=ibConnect(ibWrapper,port);
                    
                end
            end
            
        else
            disp([contracts{ci}.Symbol ':Already exists.']);
        end
    catch exception
        dumpReport('error.log', exception)
    end
end