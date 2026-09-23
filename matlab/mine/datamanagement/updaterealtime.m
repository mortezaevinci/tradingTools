%update realtime
function [TimeTables.Minute,rq,c]=updaterealtime(looperEngine,params,TimeTables.Minute,rq,c,date)
try

if (nargin()<6)
	date='today';
end

%[tm10,j,rq,c]=getMarketDataViaYahooChart(params.contract.Symbol, '10m', '1m');
rq=[];c=[];
[tm10,j,rq,c]=getMarketDataViaYahooByPeriod(symbol, datetime()-minutes(10),datetime()+minutes(1), '1m',rq,c); 
%load([looperEngine.directories.data filefriendlysymbol(params.contract.FileSymbol) '\' filefriendlysymbol(params.contract.FileSymbol)  ' minute ' date '.mat'])
[realtimett,~]=table2timetable(tm10);

realtimett(any(ismissing(realtimett),2),:)=[];
tr5 = timerange(realtimett.Date(2),realtimett.Date(end));

goodpart=realtimett(tr5,:);
TimeTables.Minute(tr5,:)=[];
TimeTables.Minute=[TimeTables.Minute;goodpart];

TimeTables.Minute=retime(TimeTables.Minute,'regular','TimeStep',seconds(1)*60);
TimeTables.Minute(any(ismissing(TimeTables.Minute),2),:)=[];
catch
     
     disp(['could not update realtime data for ' params.contract.Symbol]);
    rq=[];
    c=[];
end
end