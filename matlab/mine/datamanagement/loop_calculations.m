function calculations=loop_calculations(mainticks,commonticks,looperEngine)
global loop_calculations_run
loop_calculations_run=1;
calculations=0;
ncommon=numel(commonticks);
ncontracts=numel(mainticks);

%prepare directories

for si=1:ncommon
directory_=[looperEngine.directories.data filefriendlysymbol(commonticks{si}.params.contract.FileSymbol) '\'];
if (~exist(directory_))
    mkdir(directory_);
end
end

for si=1:ncontracts
 directory_=[looperEngine.directories.data filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) '\'];
if (~exist(directory_))
    mkdir(directory_);
end   
end

while(loop_calculations_run)
    t0=datetime();
    crumb=[];
rq=[];

for si=1:ncommon
    try
    disp(['common ticks:' commonticks{si}.params.contract.Symbol]);
if (looperEngine.data.getalldatainrealtime==1)
            getdata_yahoo_func(looperEngine,commonticks{si}.params,rq,crumb,0,0);
elseif (looperEngine.data.updaterealtime==1)
      getdata_yahoo_func(looperEngine,commonticks{si}.params,rq,crumb,1,0);
end
    catch 
        
    end
    pause(.5);
end
for si=1:ncontracts

try
    
%% main tester
 %disp(['get data ' filefriendlysymbol(mainticks{si}.params.contract.Symbol)]);
if (looperEngine.data.getalldatainrealtime==1)
      getdata_yahoo_func(looperEngine,mainticks{si}.params,rq,crumb,0,0);
elseif (looperEngine.data.updaterealtime==1)
      getdata_yahoo_func(looperEngine,mainticks{si}.params,rq,crumb,1,0);      
end
catch
    
end
pause(.5);
end
pause(20-seconds(datetime()-t0));

end
end