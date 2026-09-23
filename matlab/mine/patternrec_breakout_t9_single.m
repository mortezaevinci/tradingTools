
    mainticks{si}.params=strategy_getdata(looperEngine,mainticks{si}.params);
  mainticks{si}.params=loadprofile_PMATP1(mainticks{si}.params,looperEngine);
  mainticks{si}.params=loadprofile_PAPP1(mainticks{si}.params,looperEngine);
%% evaluate symbols

%% loop


%parfor  (si=1:ncontracts,useparfor)

 

%% update real-time could be lower, if orb level was done a bit differently
[mainticks{si}.calculations,mainticks{si}.debug]=strategy_breakout_t9(looperEngine,mainticks{si}.params,commonticks);

[X,T,t,indices,viewx]=generateNetInputs(looperEngine,mainticks{si}.params,mainticks{si}.calculations,commonticks);



