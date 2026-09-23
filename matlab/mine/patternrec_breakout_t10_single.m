
%% evaluate symbols

%% loop

%parfor  (si=1:ncontracts,useparfor)


%% update real-time could be lower, if orb level was done a bit differently
%[mainticks{si}.calculations,mainticks{si}.debug]=strategy_breakout_t10(looperEngine,mainticks{si}.params,commonticks);
[X,C,T,t,indices,viewx,indicators] = generateNetInputs_t10(looperEngine,mainticks{si}.params,mainticks{si}.calculations,commonticks);
trainData{si}.X{ds}=X;
trainData{si}.C{ds}=C;
trainData{si}.T{ds}=T;
trainData{si}.t{ds}=t;
trainData{si}.indices{ds}=indices;
trainData{si}.viewx{ds}=viewx;
trainData{si}.indicators{ds}=indicators;
