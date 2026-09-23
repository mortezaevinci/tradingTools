try
    
if (ibClient.ClientSocket.IsConnected()==0)
ibWrapper.Connect('', port, ibClient.ClientId);
currentTicker=0;
tickerrequested=0;
hasmajorerror=0;
pause(0.1);
 ibticks=[];
 requests=[];
ibClient.ClientSocket.reqMarketDataType(2); %1 for realtime 2 frozen, 4 delayd frozen, 3 delayed
pause(1);
 end


%ibticks=[];
 %ibWrapper.CleanUpTickPrices();
 
 ibcontract=getGenericContract(contracts{ci});
 currentTicker=currentTicker+1;
nextReqId = ibWrapper.TICK_ID_BASE + (currentTicker);
ibWrapper.reqMktData(nextReqId, ibcontract, '4', true, false, NET.createArray('IBApi.TagValue',0));
requests=[requests;nextReqId];
  wcnt=0;
  
 % interruptisdone=waitUnlessError(ibWrapper,2);

  %use last data
  if (~isempty(ibticks))
    
     last=ibticks(end,5);
     if (last==0)
       %grab average of bid/ask
       if (ibticks(end,2)>0 && ibticks(end,3)>0)
       last=(ibticks(end,2)+ibticks(end,3))/2;
       end
       end
  
     if (last>0)
         last

     end
  end
  
  %if (numel(requests)>50)
      %ibClient.ClientSocket.cancelMktData(requests(1));
      %requests=requests(2:end);
  %end
  
   tickerrequested=tickerrequested+1;
   %if (tickerrequested>48)
   %    ibWrapper.Disconnect();
   %end
   
catch exception
    
    exception
    
end