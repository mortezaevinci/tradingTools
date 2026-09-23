function [params, success]=strategy_getdata(looperParams,params)
try

%looperParams.date
filename=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' minute ' looperParams.date '.mat'];
success=1;
%if this line is commented out, the 5 day intraday week loads
load(filename);
%load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' minute ' looperParams.date '.mat']);
[params.TimeTables.Minute,s]=table2timetable(tm);


%tr=timerange(datetime(date)+hours(9), datetime(date)+hours(16)+minutes(30));
%params.TimeTables.Minute=params.TimeTables.Minute(tr,:);

success=success & s;

%% baseline data

%xxxmor, backdating still not fully implemented

%date='today';
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' daily 5d ' looperParams.date '.mat']);
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' daily 1y ' looperParams.date '.mat']);
%this is retired, now 5 previous days are saved separately, load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' minute 5d ' looperParams. '.mat']);
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' monthly ' looperParams.date(1:(min(7,numel(looperParams.date)))) '.mat']);


[params.TimeTables.Day,s]=table2timetable(td);
success=success & s;
[params.TimeTables.Week,s]=table2timetable(tw);
success=success & s;
%[params.TimeTables.Minute5d,s]=table2timetable(tdw);
%success=success & s;
[params.TimeTables.Month,s]=table2timetable(tmo);
success=success & s;
catch exception
getReport(exception,'extended','hyperlinks','off')
end
end