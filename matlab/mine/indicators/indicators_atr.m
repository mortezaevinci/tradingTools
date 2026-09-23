function [atr,tr]=indicators_atr(timetable,period)
%period of 10, would be for 2 weeks
  
        % True range
        CP=shiftpad(timetable.Close,1);
        hl = timetable.High-timetable.Low;                                  
        hc = abs(timetable.High-CP); 
        lc = abs(timetable.Low -CP); 
        tr = max([hl hc lc],[],2);
        
        % Average true range
        %atr = movmean(tr,period);  
        atr=ones(size(tr));
        if (isempty(tr))
            return;
        end
        atr(1)=tr(1);
        
        for i=2:size(atr,1)
           atr(i)=tr(i)/period + atr(i-1)*(period-1)/period; 
        end
        
end