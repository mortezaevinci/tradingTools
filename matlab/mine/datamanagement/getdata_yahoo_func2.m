%updateRealtime=0 means do all, but not again for monthly and stuff.
%However, do intra day

% update realtime only does last 10 minutes

function [rq,c] =getdata_yahoo_func2(looperEngine,params,rq,c,get10,getm,getd,getmo)
version='yahoo';
dateistoday=strcmp(looperEngine.date,'today');

symbol=params.contract.Symbol;
failed=0;

disp(['retreiving ' params.contract.Symbol ' data...']);
global SYMBOLDONETODAY;
alreadydone=0;
if (~updateRealtime & ~isempty(SYMBOLDONETODAY))
    if (dateistoday)
        alreadydone=contains(SYMBOLDONETODAY,[symbol '.']);
    end
end

% grab 10m data only if today is used for realtime work
if (dateistoday && get10)
    [failed_(1),rq,c]=getdata_10m_func(looperEngine,params,rq,c);
end



if (getm==2 || (getm==1 && alreadydone==0))
    name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' looperEngine.date '.mat'];
    if (~exist(name) || dateistoday)
        [failed_(2),rq,c]=getdata_minute_func(looperEngine,params,name,rq,c);
    end
end

if (getd==2 || (getd==1 && alreadydone==0))
    [failed_(3),rq,c]=getdata_minutes_week_func(looperEngine,params,rq,c);
    
    
    %also update daily of today
    name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 1y ' looperEngine.date '.mat'];
    if (~exist(name) || dateistoday)
        [failed_(4),rq,c]=getdata_daily_func(looperEngine,params,name,rq,c);
    end
end

if (getmo==2 || (getmo==1 && alreadydone==0))
    currentmonth=datetime().Month;
    dd=datestr(datetime(looperEngine.date),'yyyy-mm');
    name=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' monthly ' dd '.mat'];
    if (~exist(name) || (currentmonth==datetime(looperEngine.date).Month && dateistoday ) )% small data, maybe we use avrage of current month some time, ~exist(name))
        [failed_(5),rq,c]=getdata_month_func(looperEngine,params,name,rq,c);
    end
end

if (sum(failed_)==0)
    if (isempty(SYMBOLDONETODAY) || contains(SYMBOLDONETODAY,symbol)==0)
        SYMBOLDONETODAY=strcat(SYMBOLDONETODAY,[symbol '.']);
    end
else
    rq=[];
    c=[];
end
end