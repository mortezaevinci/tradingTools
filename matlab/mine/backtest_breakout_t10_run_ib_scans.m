

 %% connect
 looperEngine.IB.Engine.ibWrapper.ibClient.ClientId=floor(rand*10+1);
 isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);

if (isconnected)

ibscan_gapup_params;
run_ib_scan;
scancsv_all=scancsv_in;
ibscan_gapdn_params;
run_ib_scan;
scancsv_all=[scancsv_all scancsv_in];

%% disconnect  
                  
looperEngine.IB.Engine.ibWrapper.Disconnect();
else
    disp('did not connect');
end