function isconnected=ibConnect(ibWrapper,ports)
try
    isconnected=ibWrapper.ibClient.ClientSocket.IsConnected() ;
if (isconnected ==0)
    disp('connecting ib...');
    if (nargin>1)
    ibWrapper.allowedPorts=ports;
    end
    ibWrapper.Connect('');
    isconnected=ibWrapper.ibClient.ClientSocket.IsConnected();
    if (isconnected)
       disp(['connected ib to port: ' num2str(ibWrapper.port)]);
    end
end

catch exception
   exception 
end

end
% 
% function isconnected=ibConnect(ibWrapper,port)
% try
% if (ibWrapper.ibClient.ClientSocket.IsConnected()  ==0)
%     disp('connecting ib...');
%    
% for i=1:numel(port)
%     disp(['trying port ' num2str(port(i)) '...']); 
% %ibWrapper.ibClient.ClientId=floor(rand*10+1);
% ibWrapper.Connect('', port(i), ibWrapper.ibClient.ClientId);
% isconnected=ibWrapper.ibClient.ClientSocket.IsConnected();
% if (isconnected)
% break;
% end
% end
% else
%    isconnected=true; 
% end
% 
% catch exception
%    exception 
% end
% 
% end