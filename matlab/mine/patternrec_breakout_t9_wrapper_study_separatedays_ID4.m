close all

 global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY parf;

%looperparams_realtimeD;
run('config\looperparams_nn_t9_trainsseparate_ID3.m');
looperEngine.contracts={genContract([],'AAL')};

run('config\commonticks_patternrec_t9_ID4.m');

%main params
run('config\mainparams_backtest_test_t9_STUDY_ID4.m');

% if (looperEngine.data.updaterealtime==1 || looperEngine.data.getalldatainrealtime==1)
%     backtest_breakout_t7_workeron;
% end
patternrec_prepare_t7;
traindates={'2020-05-07','2020-05-08','2020-05-11','2020-05-12','2020-05-13','2020-05-14','2020-05-15','2020-05-18','2020-05-19','2020-05-20','2020-05-21','2020-05-22','2020-05-27','2020-05-28','2020-05-29','2020-06-01','2020-06-02','2020-06-03','2020-06-04','2020-06-05','2020-06-08','2020-06-09','2020-06-10','2020-06-11','2020-06-12','2020-06-15','2020-06-16','2020-06-17','2020-06-18','2020-06-19'};
traindates={'2020-05-07','2020-05-18','2020-06-22','2020-06-23'}; % test

crumb=[];
rq=[];


 
 %% net could be stay one for all symbols
net_=net_init_t1(looperEngine);

for si=1:ncontracts

disp(mainticks{si}.params.contract.Symbol);
   net=net_; 
    
     
  
    if (looperEngine.train>0)

    for i=1:looperEngine.train
   
    for ds=1:numel(traindates)
           
        
    looperEngine.date=traindates{ds};
    looperEngine.dateMinutesNextDay=datetime(traindates{ds})+days(1);
    
        
        
        
        for csi=1:ncommon
   
     disp(['init ' commonticks{csi}.params.contract.Symbol '...']);
    
if (looperEngine.data.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperEngine,commonticks{csi}.params,rq,crumb,0,0);
end
    
    commonticks{csi}.params=strategy_getdata(looperEngine,commonticks{csi}.params);

end

initGetdata_t7(looperEngine,params);
disp('process data...');

 %% evaluate commonticks
  %%;tic
   %;disp('eval commonticks');
    for si2=1:ncommon
        
        commonticks{si2}.params=strategy_getdata(looperEngine,commonticks{si2}.params);
        commonticks{si2}.calculations=strategy_breakout_t8(looperEngine,commonticks{si2}.params,[]);
    end
  %%;ticbcommon=toc

        
    patternrec_breakout_t8_single;
    

    net=net_train_t1(net,X,T);
    %viewNet(looperEngine.date,viewxx,netP1, XX,TT,tt);
    end

    end
    
    end
   



netP1=net;


netfilename=['Z:\My files\Project trading\traderdata\nets\netP1 ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) ' ID' num2str(looperEngine.net.setupId) '.mat'];
save(netfilename,'netP1');

end
    

testdates={'2020-05-07','2020-05-18','2020-06-22','2020-06-23'};

 for si=1:ncontracts
run('config\looperparams_nn_test_t9_ID4.m');
 

netfilename=['Z:\My files\Project trading\traderdata\nets\netP1 ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) ' ID' num2str(looperEngine.net.setupId) '.mat'];
load(netfilename);
 
 
  for ds=1:numel(testdates)
          
      
    looperEngine.date=testdates{ds};
 looperEngine.dateMinutesNextDay=datetime(testdates{ds})+days(1);
 
   
        for csi=1:ncommon
   
     disp(['init ' commonticks{csi}.params.contract.Symbol '...']);
    
if (looperEngine.data.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperEngine,commonticks{csi}.params,rq,crumb,0,0);
end
    
    commonticks{csi}.params=strategy_getdata(looperEngine,commonticks{csi}.params);

end

initGetdata_t7(looperEngine,params);
    

 %% evaluate commonticks
  %%;tic
   %;disp('eval commonticks');
    for si2=1:ncommon
        
        commonticks{si2}.params=strategy_getdata(looperEngine,commonticks{si2}.params);
        commonticks{si2}.calculations=strategy_breakout_t8(looperEngine,commonticks{si2}.params,[]);
    end
  %%;ticbcommon=toc
 
 patternrec_breakout_t8_single; 

 viewNet([mainticks{si}.params.contract.Symbol ' ' looperEngine.date],viewx,netP1, X,T,t);
  end

  end 
 