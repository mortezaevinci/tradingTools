function [params, success]=strategy_getdata(looperEngine,params)



try
filename=['generic' ' minute ' 'empty' '.mat'];
load(filename);
emptytt=tm;
catch exception
dumpReport('error.log', exception)
end

try

%looperEngine.date
filename=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' looperEngine.date '.mat'];
success=1;s=0;
%if this line is commented out, the 5 day intraday week loads
load(filename);

if (~isempty(tmfull))
[params.TimeTables.MinuteFull,s]=table2timetable(tmfull);
success=success & s;
elseif (exist('tmfull_tda') && ~isempty(tmfull_tda))
[params.TimeTables.MinuteFull,s]=table2timetable(tmfull_tda);
success=success & s;
else
  params.TimeTables.MinuteFull=emptytt;  
end


if (~isempty(tm))
[params.TimeTables.Minute,s]=table2timetable(tm);
success=success & s;
elseif (~isempty(params.TimeTables.MinuteFull) && isempty(tm))
   params.TimeTables.Minute=params.TimeTables.MinuteFull; 
else
    params.TimeTables.Minute=emptytt;
end
%tr=timerange(datetime(date)+hours(9), datetime(date)+hours(16)+minutes(30));
%params.TimeTables.Minute=params.TimeTables.Minute(tr,:);


catch exception
dumpReport('error.log', exception)
params.TimeTables.Minute=emptytt;
success=0;
end

%% baseline data

%xxxmor, backdating still not fully implemented

%date='today';
% try
% load([looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 5d ' looperEngine.date '.mat']);
% [params.TimeTables.Week,s]=table2timetable(tw);
% success=success & s;
% catch exception
% dumpReport('error.log', exception)
% params.TimeTables.Week=emptytt;
% end
try
if (~isfield(params.TimeTables,'Day') || isempty(params.TimeTables.Day) || strcmp(looperEngine.date,'today') == 0)
load([looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' daily 1y ' looperEngine.date '.mat']);
%this is retired, now 5 previous days are saved separately, load([looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute 5d ' looperEngine. '.mat']);
[params.TimeTables.Day,s]=table2timetable(td);
success=success & s;
else

end
catch exception
dumpReport('error.log', exception)
params.TimeTables.Day=emptytt;
success=0;
end
try
if (~isfield(params.TimeTables,'Month') || isempty(params.TimeTables.Month) || strcmp(looperEngine.date,'today') == 0)
dd=datestr(datetime(looperEngine.date),'yyyy-mm');
load([looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' monthly ' dd '.mat']);
[params.TimeTables.Month,s]=table2timetable(tmo);
success=success & s;
else

end
catch exception
dumpReport('error.log', exception)
params.TimeTables.Month=emptytt;
success=0;
end


end