function output=HandledRealtimeBarFcn(src,event)
    %this is going to need to update somehow. for now directly updating
    %mainticks

 while (src.RealTimeBarsAvailable())

        m = src.RealTimeBarDQ();
        if (~isempty(m))
            
            reqid=m.RequestId;
            si=reqid-src.RT_BARS_ID_BASE;
            
             mainticks= evalin('base','mainticks');
            nmain=numel(mainticks);
           
            
            dt=datetime(convertIBDate2MatlabDate(m.Date.ToString().char));
            
            RealTimeBar.Timestamp=m.Timestamp;
            RealTimeBar.LongVolume=m.LongVolume.double;
                vol=double(m.Volume);
            if (vol=-1) 
                vol=0;
            else
                vol=vol*100;
            end
            RealTimeBar.TimeTable= table2timetable(table(dt, m.Open.double, m.High.double, m.Low.double, m.Close.double, vol,'VariableNames',{'Date','Open','High','Low','Close','Volume'}))

            
 try
            if (si>nmain)
                 basevar=['commonticks{' num2str(si-nmain) '}.params.RealTimeBar'];
                    assignin('base','tempevalvar',RealTimeBar);
                    evalin('base',[basevar '=tempevalvar;']); 
            else
                 basevar=['mainticks{' num2str(si) '}.params.RealTimeBar'];
                    assignin('base','tempevalvar',RealTimeBar);
                    evalin('base',[basevar '=tempevalvar;']); 
                 
                 %maybe commonticks includes something already done
                 if (mainticks{si}.params.commonticks>0)
                      basevar=['commonticks{' num2str(mainticks{si}.params.commonticks) '}.params.RealTimeBar'];
                        assignin('base','tempevalvar',RealTimeBar);
                    evalin('base',[basevar '=tempevalvar;']); 
                 end
            end
 
 catch 
     
 end
        end
        end
    
end