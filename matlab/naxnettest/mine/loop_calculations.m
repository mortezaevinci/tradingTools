function calculations=loop_calculations(params,commonticks,looperParams)
calculations=0;
ncommon=numel(commonticks);
nsymbols=numel(params);
while(1)
    t0=datetime();
    crumb=[];
rq=[];

for si=1:ncommon
    try
    disp(['common ticks:' commonticks{si}.params.symbol]);
if (looperParams.getalldatainrealtime==1)
            getdata_yahoo_func(looperParams,commonticks{si}.params,rq,crumb,1,0);
end
    catch 
        
    end
end
for si=1:nsymbols

try
    
%% main tester
 %disp(['get data ' filefriendlysymbol(mainticks{si}.params.symbol)]);
if (looperParams.getalldatainrealtime==1)
      getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,0,0);
elseif (looperParams.updaterealtime==1)
      getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,1,0);      
end
catch
    
end
end
pause(30-seconds(datetime()-t0));

end
end