function ThreadConnectIb(C_threadManager,C_setup)
disp('start');
threadManager=C_threadManager.Value
setup=C_setup.Value;
while(threadManager.run)
     disp(num2str(threadManager.run));
%      isconnected=setup.ibWrapper.ibClient.ClientSocket.IsConnected();
%      if (~isconnected)
%          disp('ib not connected. Connecting....');
%          ibConnect(setup.ibWrapper,setup.ports);
%      end
     pause(1);
end
end