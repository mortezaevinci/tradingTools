%update realtime
function [params,rq,c]=updaterealtime(params,rq,c,date)
try
if (nargin()<4)
	date='today';
end

    disp('updating realtime data by file...');
%[tm10,j,rq,c]=getMarketDataViaYahooChart(symbol, '10m', '1m');
load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' 10minute today.mat'])
[realtimett,~]=table2timetable(tm10);

tr=timerange(datetime()- hours(12), datetime()+minutes(5));
realtimett=realtimett(tr,:);
if (~isempty(realtimett))
realtimett(any(ismissing(realtimett),2),:)=[];
tr5 = timerange(realtimett.Date(2),realtimett.Date(end));

goodpart=realtimett(tr5,:);
params.TimeTables.Minute(tr5,:)=[];
params.TimeTables.Minute=[params.TimeTables.Minute;goodpart];

params.TimeTables.Minute=retime(params.TimeTables.Minute,'regular','TimeStep',seconds(1)*60);
params.TimeTables.Minute(any(ismissing(params.TimeTables.Minute),2),:)=[];
end
catch exception
    disp(['could not update realtime data for ' params.symbol]);
     getReport(exception,'extended','hyperlinks','off')
     
    rq=[];
    c=[];
end
end