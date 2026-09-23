function success=initGetdata_t7(looperParams,params)
nsymbols=numel(params);
success=zeros(1,nsymbols);

rq=[];
crumb=[];

for si=1:nsymbols
   
     disp(['init ' filefriendlysymbol(mainticks{si}.params.symbol) '...']);
if (looperParams.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,0,0);
elseif (mainticks{si}.params.getdatainit==2)
    [rq,c]=getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,1,0);
end
    success(si)=0;
    
    [mainticks{si}.params, success(si)]=strategy_getdata(looperParams,mainticks{si}.params);
    if (success(si)==0)
        
        [rq,c]=getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,0,1);
        [mainticks{si}.params, success(si)]=strategy_getdata(looperParams,mainticks{si}.params);
       
    end
    if (success(si)==0)
        disp(['could not get data of' filefriendlysymbol(mainticks{si}.params.symbol) 'successfully.']);
    end
end


end