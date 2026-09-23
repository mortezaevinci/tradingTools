date0=datestr(date_,'yyyy-mm-dd');
dateib=datestr(date_,'yyyymmdd');


% these are treated as newyork time because date_ is set that way
enddatetime_ = date_;
enddatetime_.Minute = 0;
enddatetime_.Second=0;
enddatetime_.Hour = 22;
startdatetime_ = date_;
startdatetime_.Minute = 0;
startdatetime_.Second=0;
startdatetime_.Hour = 1;

% enddatetime = date2dateib(enddatetime_);% [dateib ' 22:00:00']; %//empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false
% startdatetime = date2dateib(startdatetime_);% [dateib ' 01:00:00']; %//empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false
