function [calculations,debug]=strategy_dailytrend_t10(looperEngine,params,commonticks)
debug=struct();

[calculations.atr,tr]=indicators_atr(params.TimeTables.Day,14);

timetablePrimary=params.TimeTables.Minute; % because minute open is not available the way we do daily

themorningdate=datetime([datestr(timetablePrimary.Date(end),'yyyy-mm-dd') ' 09:30:00']);
dailytimerange=timerange(themorningdate-days(2000), themorningdate-hours(themorningdate.Hour)-minutes(themorningdate.Minute)-hours(4));
dailybeforetoday=params.TimeTables.Day(dailytimerange,:);

try
    
    lastdayquote=dailybeforetoday(end,:);
    %disp(['using ' datestr(lastdayquote.Date) ' daily data for previous day.']);
    dc=lastdayquote.Close;
    
    lastdcandles=dailybeforetoday.Close-dailybeforetoday.Open;
    calculations.previousClose=dc
    calculations.premarketmoveperc=0;
    calculations.premarketmove=0;
    if (~isempty(params.TimeTables.Minute))
        calculations.premarketmove=(timetablePrimary.Open(1)-dc)
        calculations.premarketmoveperc=(timetablePrimary.Open(1)-dc)/dc
    else
        if (~isempty(params.TimeTables.MinuteFull))
            tr=timerange(themorningdate-minutes(240),themorningdate);
            calculations.premarketmove=(params.TimeTables.MinuteFull(tr,:).Close(end)-dc)
            calculations.premarketmoveperc=(params.TimeTables.MinuteFull(tr,:).Close(end)-dc)/dc
        end
    end
    
catch exception
    exception
    
end

% %here we want the first data after market open
% marketopentimerange=timerange(themorningdate-hours(5), themorningdate+seconds(30));
% marketopensection_open=timetablePrimary(marketopentimerange).Open;
% premarketup=(marketopensection_open(end)-dc)>0;
% premarketdn=(marketopensection_open(end)-dc)<0;

premarketup=(timetablePrimary.Open(1)-dc)>0;
premarketdn=(timetablePrimary.Open(1)-dc)<0;

somedn=lastdcandles(end)>0 & (lastdcandles(end-1)<0 || lastdcandles(end-2)<0 || lastdcandles(end-3)<0);
someup=lastdcandles(end)<0 & (lastdcandles(end-1)>0 || lastdcandles(end-2)>0|| lastdcandles(end-3)>0);

sma50=movmean(dailybeforetoday.Close,[50 0]);
sma200=movmean(dailybeforetoday.Close,[200 0]);

dsma50=diff(sma50);
dsma200=diff(sma200);

trendup=dsma50(end)>0 && dsma200(end)>0;

trenddn=dsma50(end)<0 && dsma200(end)<0;

calculations.dailytrendnames=['premarketup','premarketdn'];
calculations.dailytrends=[premarketup,premarketdn,somedn,someup,... 1,2,3,4
    dsma50(end)>0 ,dsma50(end)<0,dsma200(end)>0,dsma200(end)<0,...  5,6,7,8
    sma50(end)>sma200(end),sma50(end)<sma200(end)... 9,10
    ]; %note somedn is good for market trending up... too much accumulation of candles is not good

end