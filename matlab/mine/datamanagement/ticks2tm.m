function tm = ticks2tm(tickslast)
date0 = datestr(tickslast.Date(1),'yyyy-mm-dd');
jct.datetime = datetime(date0,'TimeZone','America/New_York')+minutes(240+(0:959))';
jct.open = zeros(size(jct.datetime));
jct.high = zeros(size(jct.datetime));
jct.low = 100000*ones(size(jct.datetime));
jct.close = zeros(size(jct.datetime));
jct.volume = zeros(size(jct.datetime));
tm = table(jct.datetime,jct.open,jct.high,jct.low,jct.close,jct.volume,...
    'VariableNames',{'Date','Open','High','Low','Close','Volume'});

cntti = 1;
cnttm = 1;
% if not same minute, copy last minute values to next minute, then go
basec = tickslast.Price(cntti);

tm.Open(cnttm) = basec;
tm.High(cnttm) = max([tm.High(cnttm),basec]);
tm.Low(cnttm) = min([tm.Low(cnttm),basec]);
tm.Close(cnttm) = basec;

while cnttm <= size(tm.Date,1)
    if (cnttm>1)
        basec = tm.Close(cnttm-1);
    end
    tm.Open(cnttm) = basec;
    tm.High(cnttm) = basec;
    tm.Low(cnttm) = basec;
    tm.Close(cnttm) = basec;
    
    ind = find(tickslast.Date >= tm.Date(cnttm) & tickslast.Date <= tm.Date(cnttm)+minutes(1));
    if (size(ind)>0)
    tm.Open(cnttm) = tickslast.Price(ind(1));
    tm.High(cnttm) = max(tickslast.Price(ind));
    tm.Low(cnttm) = min(tickslast.Price(ind));
    tm.Close(cnttm) = tickslast.Price(ind(end));
    tm.Volume(cnttm) = sum(tickslast.Size(ind));
    end
    cnttm = cnttm+1;
end

end

% function tm = ticks2tm(tickslast)
% date0 = datestr(tickslast.Date(1),'yyyy-mm-dd');
% jct.datetime = datetime(date0,'TimeZone','America/New_York')+minutes(240+(0:959))';
% jct.open = zeros(size(jct.datetime));
% jct.high = zeros(size(jct.datetime));
% jct.low = 100000*ones(size(jct.datetime));
% jct.close = zeros(size(jct.datetime));
% jct.volume = zeros(size(jct.datetime));
% tm = table(jct.datetime,jct.open,jct.high,jct.low,jct.close,jct.volume,...
%     'VariableNames',{'Date','Open','High','Low','Close','Volume'});
% 
% cntti = 1;
% cnttm = 1;
% % if not same minute, copy last minute values to next minute, then go
% basec = tickslast.Price(cntti);
% 
% tm.Open(cnttm) = basec;
% tm.High(cnttm) = max([tm.High(cnttm),basec]);
% tm.Low(cnttm) = min([tm.Low(cnttm),basec]);
% tm.Close(cnttm) = basec;
% 
% % back to loop
% minute0 = minute(tickslast.Date(cntti));
% minute1 = minute(tickslast.Date(cntti));
% 
% while cntti <= size(tickslast.Date,1)
%     if (cnttm>1)
%     basec = tm.Close(cnttm-1);
%     end
%     
%     tm.Open(cnttm) = basec;
%     tm.High(cnttm) = max([tm.High(cnttm),basec]);
%     tm.Low(cnttm) = min([tm.Low(cnttm),basec]);
%     tm.Close(cnttm) = basec;
%     
%     % for any item, update until datetime is in the same minute
%     
%     while(minute1 == minute0)
%         
%         basec = tickslast.Price(cntti);
%         
%         tm.High(cnttm) = max([tm.High(cnttm),basec]);
%         tm.Low(cnttm) = min([tm.Low(cnttm),basec]);
%         tm.Close(cnttm) = basec;
%         tm.Volume(cnttm) = tm.Volume(cnttm)+tickslast.Size(cntti);
%         
%         cntti=cntti+1;
%         if (cntti > size(tickslast.Date,1))
%             continue;
%         end
%         minute1 = minute(tickslast.Date(cntti));
%     end
%     minute0 = minute1;
%     cnttm = cnttm+1;
% end
% 
% end