%update realtime
function params=updaterealtimeByRealTimeBars(params)
try

disp('updating realtime data by IB realtime bars...');

realtimett=params.RealTimeBar.TimeTable;

tr=timerange(datetime()- hours(12), datetime()+minutes(5));
realtimett=realtimett(tr,:);
if (~isempty(realtimett))
realtimett(any(ismissing(realtimett),2),:)=[];
tr5 = timerange(realtimett.Date(1)-seconds(30),realtimett.Date(end)+seconds(30));

if (~isempty(tr5))
goodpart=realtimett(tr5,:);
yahootdadata=params.TimeTables.Minute(tr5,:);%keep base volume, and recover from it, and ignore IB volume
params.TimeTables.Minute(tr5,:)=[];
params.TimeTables.Minute=[params.TimeTables.Minute;goodpart];
params.TimeTables.Minute(tr5,:).Volume=yahootdadata.Volume;
else
    disp('tr5 is empty');
end

params.TimeTables.Minute=retime(params.TimeTables.Minute,'regular','TimeStep',seconds(1)*60);
params.TimeTables.Minute(any(ismissing(params.TimeTables.Minute),2),:)=[];
end
catch exception
    disp(['could not update realtime data for ' params.contract.Symbol]);
     dumpReport('error.log', exception)
end
end