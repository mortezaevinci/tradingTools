function output=HandledHistoricalDataEndFcn(src,event)



 while (src.HistoricalDataAvailable())
           lastticker=-1;
        m = src.HistoricalDataDQ();
        if (~isempty(m))
            dt=datetime(convertIBDate2MatlabDate(m.Date.ToString().char));
            
            if (hour(dt)>8 &&  hour(dt)<17) %reduce number of checks
            ticker=m.RequestId-src.HISTORICAL_ID_BASE;
            try
                if (lastticker~=ticker)
                    
                      try
     
  assignin('base',ttname,tt);
 catch 
     
 end
                    ttname= evalin('base',['timetablename{' num2str(ticker) '}']);
                end
           try
                if (lastticker~=ticker)
                    tt= evalin('base',ttname);
                end
           
           
           if ~isempty(tt(dt,:))
               if (isnan(tt(dt,:).Open))
%                tt(dt,:).Close=m.Close;
%                tt(dt,:).Open=m.Open;
%                tt(dt,:).High=m.High;
%                tt(dt,:).Low=m.Low;
%                tt(dt,:).Volume=m.Volume;
           
            tt(dt,:)=timetable(dt, m.Open, m.High, m.Low, m.Close, m.Volume*100);
               end
           end
           
           catch 
               
           end
            
            catch 
                
            end
       %
       
       
       
       
       
       
       
       
       
     %  disp([m.Date.ToString().char ': ID=' num2str(m.RequestId), 'OHLCV=' num2str(m.Open),',',num2str(m.High),',',num2str(m.Low),',',num2str(m.Close),',',num2str(m.Volume*100)]);
        lastticker=ticker;
        end
        end
 end
 try
     
  assignin('base',ttname,tt);
 catch 
     
 end
 

 disp('HistoricalDataEndMessages');
m=src.HistoricalDataEndMessages;

for i=1:m.Count-1
    m.Item(i)
end


 
end