function output=HandledHistoricalDataUpdateFcn(src,event)
        
 while (src.HistoricalDataAvailable())

        m = src.HistoricalDataDQ();
        if (~isempty(m))
            
            reqid=m.RequestId;
            si=reqid-src.HISTORICAL_ID_BASE;
            
            mainticks= evalin('base','mainticks');
            nmain=numel(mainticks);
           
            
            dt=datetime(convertIBDate2MatlabDate(m.Date.ToString().char));
            
            %ignore old data, only interested in lastest
            if (dt<datetime()-minutes(5))
                return;
            end
            
            vol=double(m.Volume);
            if (vol==-1) 
                vol=0;
            else
                vol=vol*100;
            end
            HistoricalDataUpdate.status=1;
            HistoricalDataUpdate.TimeTable= table2timetable(table(dt, m.Open, m.High, m.Low, m.Close, vol,'VariableNames',{'Date','Open','High','Low','Close','Volume'}));
           
 try
     
            if (si>nmain)
                 %disp(['NEW IB DATA UPDATE: OHLC=' num2str(m.Open) ' ' num2str(m.High) ' ' num2str(m.Low) ' ' num2str(m.Close) ' at ' datestr(dt,'hh:MM:ss') ' of common at index ' num2str(si-nmain) ]);
                 basevar=['commonticks{' num2str(si-nmain) '}.params.HistoricalDataUpdate'];
                 assignin('base','tempevalvar',HistoricalDataUpdate);
                 evalin('base',[basevar '=tempevalvar;']); 

                 cmd=['commonticks{' num2str(si-nmain) '}.params=updaterealtimeByHistoricalDataUpdate(commonticks{' num2str(si-nmain) '}.params);'];
                 evalin('base',cmd); 
            else
                 %disp(['NEW IB DATA UPDATE: OHLC=' num2str(m.Open) ' ' num2str(m.High) ' ' num2str(m.Low) ' ' num2str(m.Close) ' at ' datestr(dt,'hh:MM:ss')  ' of ' mainticks{si}.params.contract.Symbol]);
                 basevar=['mainticks{' num2str(si) '}.params.HistoricalDataUpdate'];
                 assignin('base','tempevalvar',HistoricalDataUpdate);
                 evalin('base',[basevar '=tempevalvar;']); 
                 
                  cmd=['mainticks{' num2str(si) '}.params=updaterealtimeByHistoricalDataUpdate(mainticks{' num2str(si) '}.params);'];
                 evalin('base',cmd); 
                 
%                   %debug
%                      disp(['HistoricalDataUpdate for ' basevar]);
%                  HistoricalDataUpdate.TimeTable
                 %maybe commonticks includes something already done
                 if (mainticks{si}.params.commonticks>0)
                      basevar=['commonticks{' num2str(mainticks{si}.params.commonticks) '}.params.HistoricalDataUpdate'];
                       assignin('base','tempevalvar',HistoricalDataUpdate);
                    evalin('base',[basevar '=tempevalvar;']); 
                    
                    
                     cmd=['commonticks{' num2str(mainticks{si}.params.commonticks) '}.params=updaterealtimeByHistoricalDataUpdate(commonticks{' num2str(mainticks{si}.params.commonticks) '}.params);'];
                 evalin('base',cmd); 
                    
%                       %debug
%                        disp(['HistoricalDataUpdate for ' basevar]);
%                     HistoricalDataUpdate.TimeTable
                 end
            end
 
 catch exception
     
 end
        end
        end
        
        
end



% 
% function output=HandledHistoricalDataUpdateFcn(src,event)
%         
%  while (src.HistoricalDataAvailable())
% 
%         m = src.HistoricalDataDQ();
%         if (~isempty(m))
%             
%             reqid=m.RequestId;
%             si=reqid-src.HISTORICAL_ID_BASE;
%             
%             mainticks= evalin('base','mainticks');
%             nmain=numel(mainticks);
%            
%             
%             dt=datetime(convertIBDate2MatlabDate(m.Date.ToString().char));
%             
%             %ignore old data, only interested in lastest
%             if (dt<datetime()-minutes(5))
%                 return;
%             end
%             
%             vol=double(m.Volume);
%             if (vol==-1) 
%                 vol=0;
%             else
%                 vol=vol*100;
%             end
%             HistoricalDataUpdate.status=1;
%             HistoricalDataUpdate.TimeTable= table2timetable(table(dt, m.Open, m.High, m.Low, m.Close, vol,'VariableNames',{'Date','Open','High','Low','Close','Volume'}));
%            
%  try
%      
%             if (si>nmain)
%                  %disp(['NEW IB DATA UPDATE: OHLC=' num2str(m.Open) ' ' num2str(m.High) ' ' num2str(m.Low) ' ' num2str(m.Close) ' at ' datestr(dt,'hh:MM:ss') ' of common at index ' num2str(si-nmain) ]);
%                  basevar=['commonticks{' num2str(si-nmain) '}.params.HistoricalDataUpdate'];
%                   assignin('base','tempevalvar',HistoricalDataUpdate);
%                  evalin('base',[basevar '=tempevalvar;']); 
% 
%                  
%             else
%                  %disp(['NEW IB DATA UPDATE: OHLC=' num2str(m.Open) ' ' num2str(m.High) ' ' num2str(m.Low) ' ' num2str(m.Close) ' at ' datestr(dt,'hh:MM:ss')  ' of ' mainticks{si}.params.contract.Symbol]);
%                  basevar=['mainticks{' num2str(si) '}.params.HistoricalDataUpdate'];
%                  assignin('base','tempevalvar',HistoricalDataUpdate);
%                  evalin('base',[basevar '=tempevalvar;']); 
% %                   %debug
% %                      disp(['HistoricalDataUpdate for ' basevar]);
% %                  HistoricalDataUpdate.TimeTable
%                  %maybe commonticks includes something already done
%                  if (mainticks{si}.params.commonticks>0)
%                       basevar=['commonticks{' num2str(mainticks{si}.params.commonticks) '}.params.HistoricalDataUpdate'];
%                        assignin('base','tempevalvar',HistoricalDataUpdate);
%                     evalin('base',[basevar '=tempevalvar;']); 
% %                       %debug
% %                        disp(['HistoricalDataUpdate for ' basevar]);
% %                     HistoricalDataUpdate.TimeTable
%                  end
%             end
%  
%  catch exception
%      
%  end
%         end
%         end
%         
%         
% end