function [success,mainticks,commonticks]=initGetdata_t8(looperEngine,mainticks,commonticks)

global initgetdatadone;
initgetdatadone=0;
ncontracts=numel(mainticks);
ncommon=numel(commonticks);
success=zeros(1,ncontracts);

if (looperEngine.mainDataEngine==2)
regularhours=0;
    datafunc=@getdata_TDA_func;
else
dt0=datetime();
dt0hour=dt0.Hour+dt0.Minute/60;
regularhours=0;
    datafunc=@getdata_TDA_func;

if (dt0hour>9.5 && dt0hour<=16)
    regularhours=1;
    datafunc=@getdata_yahoo_func; %use getdata_yahoo_func2 in next version
end
end
    

rq=[];
crumb=[];

for si=1:ncommon
 try  
disp(['init ' commonticks{si}.params.contract.Symbol '...']);
   
if (looperEngine.data.getdatainit==1)
   [rq,c]=datafunc(looperEngine,commonticks{si}.params,rq,crumb,0,0);
elseif (looperEngine.data.getdatainit==2)
    [rq,c]=datafunc(looperEngine,commonticks{si}.params,rq,crumb,1,0);
  elseif (looperEngine.data.getdatainit==3)
    [rq,c]=datafunc(looperEngine,commonticks{si}.params,rq,crumb,0,1);

end

    
commonticks{si}.params=strategy_getdata(looperEngine,commonticks{si}.params);

catch exception
   dumpReport('error.log', exception) 
    
end
end

for si=1:ncontracts
   try
     disp(['init ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) '...']);
if (looperEngine.data.getdatainit==1)
   [rq,c]=datafunc(looperEngine,mainticks{si}.params,rq,crumb,0,0);
elseif (looperEngine.data.getdatainit==2)
    [rq,c]=datafunc(looperEngine,mainticks{si}.params,rq,crumb,1,0);
  elseif (looperEngine.data.getdatainit==3)
    [rq,c]=datafunc(looperEngine,mainticks{si}.params,rq,crumb,0,1);

end
    success(si)=0;
    
    [mainticks{si}.params, success(si)]=strategy_getdata(looperEngine,mainticks{si}.params);
     if (success(si)==0)
         disp('re-doing because it failed.');
         [rq,c]=datafunc(looperEngine,mainticks{si}.params,rq,crumb,0,1);
         [mainticks{si}.params, success(si)]=strategy_getdata(looperEngine,mainticks{si}.params);
        
     end
    if (success(si)==0)
        disp(['could not get data of ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) ' successfully.']);
    end
    catch exception
   dumpReport('error.log', exception) 
    
end
end
initgetdatadone=1;

end