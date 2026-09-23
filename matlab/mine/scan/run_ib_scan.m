%prepare
ibscan=[];
timetablename{1}='ibscan';
interruptisdone=0;
hasmajorerror=0;
looperEngine.IB.Engine.currentTicker.scanner=1;
disp('ib clean up...');
looperEngine.IB.Engine.ibWrapper.CleanUpScannerData(); 
pause(.01);
%request   
reqid=looperEngine.IB.Engine.ibWrapper.SCANNER_BASE+looperEngine.IB.Engine.currentTicker.scanner;
looperEngine.IB.Engine.ibWrapper.ibClient.ClientSocket.reqScannerSubscription(reqid, subscription,[] , tvs);

disp('waiting for ibwrapper...');
interruptisdone=waitUnlessError(looperEngine.IB.Engine.ibWrapper,5);

disp('waiting for interrupt...');
d0=datetime();
while(interruptisdone==0 && looperEngine.IB.Engine.ibWrapper.RequestEnded==false)
    pause(.05);
    d1=datetime();
    if (seconds(d1-d0)>2)
        break
    end
end

scancsv_in='';
if (~isempty(ibscan))
    for i=1:numel(ibscan)
        scancsv_in=[scancsv_in ibscan{i}.contract.Symbol ','];
    end
    disp(scancsv_in);
else
    disp('empty scan.');
end

looperEngine.IB.Engine.ibWrapper.ibClient.ClientSocket.cancelScannerSubscription(reqid);
