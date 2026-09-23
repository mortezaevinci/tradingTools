if (looperEngine.IB.run>0)
    looperEngine.IB.Engine=ibEngineInit(looperEngine.directories.ibapi);
    
%% set handles

%all standard handles are available to signal matlab as well
  looperEngine.IB.Engine.events= setIbWrapperEvents(looperEngine.IB.Engine.ibWrapper);

%% client setup
looperEngine.IB.Engine.ibWrapper.ibClient.ClientId=looperEngine.IB.clientId;
    
end