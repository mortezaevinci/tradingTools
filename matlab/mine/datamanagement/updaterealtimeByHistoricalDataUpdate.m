%update realtime
function params=updaterealtimeByHistoricalDataUpdate(params)
try
    if (isempty(params.HistoricalDataUpdate))
        return;
    end
    
    if (datetime()>datetime('13:59:00'))
        return;
    end
    
    realtimett=params.HistoricalDataUpdate.TimeTable;
    if (isempty(realtimett))
        return;
    end
    
    
    %disp('updating historical data by IB...');
    
    tr=timerange(datetime()- minutes(2), datetime()+minutes(1));
    realtimett=realtimett(tr,:);
    
    if (~isempty(realtimett))
        realtimett(any(ismissing(realtimett),2),:)=[];
        tr5 = timerange(realtimett.Date(1)-seconds(30),realtimett.Date(end)+seconds(30));
        
        if (~isempty(tr5))
            goodpart=realtimett(tr5,:);
            if (~isempty(params.TimeTables.Minute))
            currentt=params.TimeTables.Minute(tr5,:);
            
            if (~isempty(currentt))
                params.TimeTables.Minute(tr5,:).Close=goodpart.Close;
                params.TimeTables.Minute(tr5,:).Volume=goodpart.Volume;
                params.TimeTables.Minute(tr5,:).Low=min(params.TimeTables.Minute(tr5,:).Low,goodpart.Low);
                params.TimeTables.Minute(tr5,:).High=max(params.TimeTables.Minute(tr5,:).High,goodpart.High);
            else
                %params.TimeTables.Minute(tr5,:)=[];
                params.TimeTables.Minute=[params.TimeTables.Minute;goodpart];
            end
            else
                params.TimeTables.Minute=goodpart;
            end
        end
        
        params.TimeTables.Minute=retime(params.TimeTables.Minute,'regular','TimeStep',seconds(1)*60);
        params.TimeTables.Minute(any(ismissing(params.TimeTables.Minute),2),:)=[];
    end
    
catch exception
    disp(['could not update realtime data for ' params.contract.Symbol]);
    dumpReport('error.log', exception)
end
end