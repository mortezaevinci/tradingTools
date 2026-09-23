nc=numel(contracts);

for ci=1:nc
        if (isKey(conIdMap,contracts{ci}.Symbol)==0)

            ow=IBCD.orderWatchlists.Item(0);
            cd=ow.contractDefinitions.Item(0);
            cd.contract.Symbol=contracts{ci}.Symbol;
            
            %% setting ConId's
            ibDataHandler.ResetInterrupt('conid');
            ibWrapper.getConId(cd);
            timeout=5;
            d0=datetime();
            while (ibDataHandler.Interrupt('conid')==0 && seconds(datetime()-d0)<timeout)
                pause(0.1);
            end
            if (ibWrapper.resolvedContracts.Count==1)
               
                rc=ibWrapper.resolvedContracts.Item(0);
                conIdMap(contracts{ci}.Symbol)=rc.ConId;
               disp([contracts{ci}.Symbol '=' num2str(rc.ConId)]);
            else
                disp([contracts{ci}.Symbol ':Con id not found...']);
            end
        else
            disp([contracts{ci}.Symbol ':Con id exists...']);
        end 
    end 
    
    save(conidmapfn,'conIdMap');