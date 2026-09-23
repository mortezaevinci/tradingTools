%update realtime
function params=updaterealtimeByFile(looperEngine,params,date)
try
if (nargin()<3)
	date='today';
end

    %disp('updating realtime data by file...');
fn=[looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' 10minute ' date '.mat'];
if(exist(fn)==0)
    return
end
load(fn);


[realtimett,~]=table2timetable(tm10);


if(isempty(realtimett))
    return
end

if(isempty(params.TimeTables.Minute))
    params.TimeTables.Minute=realtimett;
    params.TimeTables.Minute(any(ismissing(params.TimeTables.Minute),2),:)=[];
    return
end

tr=timerange(datetime()- hours(12), datetime()+minutes(5));
realtimett=realtimett(tr,:);
if (~isempty(realtimett))
realtimett(any(ismissing(realtimett),2),:)=[];
tr5 = timerange(realtimett.Date(1)-seconds(30),realtimett.Date(end)+seconds(30));

if (~isempty(tr5))
goodpart=realtimett(tr5,:);
params.TimeTables.Minute(tr5,:)=[];
params.TimeTables.Minute=[params.TimeTables.Minute;goodpart];
else
    disp('realtime file is empty');
end

params.TimeTables.Minute=retime(params.TimeTables.Minute,'regular','TimeStep',seconds(1)*60);
params.TimeTables.Minute(any(ismissing(params.TimeTables.Minute),2),:)=[];
end
catch exception
    disp(['could not update realtime data for ' params.contract.Symbol]);
     dumpReport('error.log', exception)

end
end