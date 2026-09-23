run('config\looperparams_study_premarket_t10_ID3');
looperEngine.IB.Engine=ibEngineInit(looperEngine.directories.ibapi);
looperEngine.IB.Engine.events= setIbWrapperEvents(looperEngine.IB.Engine.ibWrapper);

 %% connect
  looperEngine.IB.Engine.ibWrapper.ibClient.ClientId=floor(rand*10+1);
 isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);

if (isconnected)
ibscan_gapup_params;
ibscan_params_PM1;
run_ib_scan;
%% disconnect  
                  
looperEngine.IB.Engine.ibWrapper.Disconnect();
else
    disp('did not connect');
end
     