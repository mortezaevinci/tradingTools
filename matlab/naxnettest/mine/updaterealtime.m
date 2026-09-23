%update realtime
function [TimeTables.Minute,rq,c]=updaterealtime(symbol,TimeTables.Minute,rq,c,date)
try

if (nargin()<6)
	date='today';
end

[tm10,j,rq,c]=getMarketDataViaYahooChart(symbol, '10m', '1m');
%load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' minute ' date '.mat'])
[realtimett,~]=table2timetable(tm10);

realtimett(any(ismissing(realtimett),2),:)=[];
tr5 = timerange(realtimett.Date(2),realtimett.Date(end));

goodpart=realtimett(tr5,:);
TimeTables.Minute(tr5,:)=[];
TimeTables.Minute=[TimeTables.Minute;goodpart];

TimeTables.Minute=retime(TimeTables.Minute,'regular','TimeStep',seconds(1)*60);
TimeTables.Minute(any(ismissing(TimeTables.Minute),2),:)=[];
catch
     
     disp(['could not update realtime data for ' filefriendlysymbol(symbol)]);
    rq=[];
    c=[];
end
end