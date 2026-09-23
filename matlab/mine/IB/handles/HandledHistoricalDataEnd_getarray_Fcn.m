function output=HandledHistoricalDataEnd_getarray_Fcn(src,event)

fileindex=1; %ignoring it for now, considering that this method is only possible if there is only one request of historical data
                   
 try
      ttname= evalin('base',['timetablename{' num2str(fileindex) '}']);
    reqid=evalin('base','reqid');
    
    iscorrect=1;
    cnt=src.HistoricalDataMessages.Count;
    for i=[1:(cnt/10):cnt-1 cnt-1]
    	if (reqid~=src.HistoricalDataMessages.Item(i).RequestId)
        iscorrect=0;
        
        break;
    	end
    end

    if (iscorrect==1)
      % disp(['processing ' num2str(cnt) ' historical data...']);
       hda=src.HistoricalDataArray;
       
          att=hda.cell;
       
          att=att(~cellfun('isempty',att));
          atm=vertcat(att{:});
         if (isempty(atm))
             return;
         end
         
         
         
          Date=datetime(atm(:,1),'ConvertFrom','posixtime','TimeZone','America/New_York');
        %%tt=array2timetable(atm(:,2:end),'RowDates',Date,'VariableNames',{'Open','High','Low','Close','Volume'});
         tt=table(Date,atm(:,2),atm(:,3),atm(:,4),atm(:,5),atm(:,6),'VariableNames',{'Date','Open','High','Low','Close','Volume'});
        %disp(['setting ' ttname '...']);
        assignin('base',ttname,tt);
    else
        %disp(['reqid to be:' num2str(reqid) ' reqid returned:' num2str(src.HistoricalDataMessages.Item(1).RequestId)]);
    	disp('invalid request ids found');
    end
     
 catch exception
     disp(exception.message);
 end
 assignin('base','interruptisdone',1);
end