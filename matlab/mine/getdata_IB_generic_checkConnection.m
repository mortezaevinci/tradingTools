function [isconnected,isreset] = getdata_IB_generic_checkConnection(ibDataHandler,ibWrapper,isconnected,baseclientid)
isreset=0;
if (ibDataHandler.IbErrorSummary.Connection==1)
    ibDataHandler.IbErrorSummary.Connection=0;
    %restart connection and wait for 2 minutes
    ibWrapper.Disconnect();
    ibDataHandler.ResetBase();
    isreset=1;
    %pause(120);
    ibWrapper.ibClient.ClientId=floor(rand()*10)+baseclientid;
    isconnected=ibConnect(ibWrapper);
end

if (ibWrapper.ibClient.ClientSocket.IsConnected()==0)
    disp('reconnecting...');
    ibWrapper.ibClient.ClientId=floor(rand()*10)+baseclientid;
    isconnected=ibConnect(ibWrapper);
    isreset=1;
else
    
end

end