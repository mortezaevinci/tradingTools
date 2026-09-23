% setup is an struct containing all possible inputs including contracts,
% ibWrapper,base,etc, remainder setter for circulating contracts
function ThreadRequestSnapshots(threadManager,setup)
%supposedly ibWrapper's connection is managed somewhere else.
cycle=0;
tags=NET.createArray('IBApi.TagValue',0);
while(threadManager.run)
currentTicker=cycle*setup.cycleRemainder; %e.g. cycleRemainder=10000
nc=numel(setup.contracts);
for ci=1:nc
    if (true) %xxxmor,setup.contracttriggers.Marked(ci))
    ibcontract=getGenericContract(setup.contracts{ci});
    currentTicker=currentTicker+1;
    nextReqId = ibWrapper.TICK_ID_BASE + (currentTicker);
    setup.ibWrapper.reqMktData(nextReqId, ibcontract, setup.genericTickTypes, true, false, tags);
    
    if (threadManager.run==0)
        break;
    end
    pause(.011);
    end
end

% should be disconnect/reconnect ibWrapper here?
% In that sense no cycling is needed.

cycle=cycle+1;
end
end