function output=HandledScannerDataEndFcn(src,event)

fileindex=1; %ignoring it for now, considering that this method is only possible if there is only one request of historical data
                    
 try
      ttname= evalin('base',['timetablename{' num2str(fileindex) '}']);
    reqid=evalin('base','reqid');
   tt=cell(0);
    iscorrect=1;
    cnt=src.ScannerMessages.Count;
    disp(['scan size=' num2str(cnt)]);
    ocnt=1;
    for i=0:cnt-1
    	if (reqid==src.ScannerMessages.Item(i).RequestId)
            tt{ocnt}.contract=getMatlabContract(src.ScannerMessages.Item(i).ContractDetails.Contract);
            tt{ocnt}.rank=src.ScannerMessages.Item(i).Rank;
            tt{ocnt}.distance=transferchar(src.ScannerMessages.Item(i).Distance);
            tt{ocnt}.benchmark=transferchar(src.ScannerMessages.Item(i).Benchmark);
            tt{ocnt}.projection=transferchar(src.ScannerMessages.Item(i).Projection);
            tt{ocnt}.legsStr=transferchar(src.ScannerMessages.Item(i).LegsStr);
        ocnt=ocnt+1;
    	end
    end

    if (iscorrect==1)
       
        assignin('base',ttname,tt);
    else
    	disp('invalid request ids found');
    end
     
 catch exception
     disp(exception.message);
 end
 assignin('base','interruptisdone',1);
end