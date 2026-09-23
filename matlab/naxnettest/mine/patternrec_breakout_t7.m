crumb=[];
rq=[];

for si=1:ncommon
   
     disp(['init ' commonticks{si}.params.symbol '...']);
    
if (commonticks{si}.params.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperParams,commonticks{si}.params,rq,crumb,0,0);
end
    
    commonticks{si}.params=strategy_getdata(looperParams,commonticks{si}.params);

end

initGetdata_t7(looperParams,params);
    
%init graph
for  si=1:nsymbols
disp(mainticks{si}.params.symbol);
    mainticks{si}.params=strategy_getdata(looperParams,mainticks{si}.params);
end


%% keep loop

disp('Go!');

%% evaluate symbols

%% loop

 %% evaluate commonticks
 %;tic
   %;disp('eval commonticks');
    for si2=1:ncommon
        
        commonticks{si2}.params=strategy_getdata(looperParams,commonticks{si2}.params);
        commonticks{si2}.calculations=strategy_breakout_t8(looperParams,commonticks{si2}.params,[]);
    end
 %;ticbcommon=toc

%parfor  (si=1:nsymbols,useparfor)
for si=1:nsymbols
disp(mainticks{si}.params.symbol);
 

%% update real-time could be lower, if orb level was done a bit differently
mainticks{si}.calculations=strategy_breakout_t8(looperParams,mainticks{si}.params,commonticks);

[X,T,t]=generateNetInputs(mainticks{si}.params,mainticks{si}.calculations,commonticks);

if (looperParams.train>0)
for i=1:looperParams.train
trainingdata{si}.net=net_train_t1(trainingdata{si}.net,X,T);
end
end



end



