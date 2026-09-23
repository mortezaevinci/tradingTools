function setConId(ibWrapper,cd,ibDataHandler,conIdMap)

if (cd.contract.ConId==0)
    %% setting ConId's
    
    if (isKey(conIdMap,cd.contract.Symbol.char))
        cd.contract.ConId=conIdMap(cd.contract.Symbol.char);
    else 
        
        ibDataHandler.ResetInterrupt('conid');
        ibWrapper.getConId(cd);
        timeout=5;
        d0=datetime();
        while (ibDataHandler.Interrupt('conid')==0 && seconds(datetime()-d0)<timeout)
            pause(0.2);
        end
        if (ibWrapper.resolvedContracts.Count==1)
            rc=ibWrapper.resolvedContracts.Item(0);
            cd.contract.ConId=rc.ConId;
        end
    end
end

end