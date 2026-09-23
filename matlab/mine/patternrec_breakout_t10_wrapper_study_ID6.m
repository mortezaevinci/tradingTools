close all

global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY parf XX TT tt viewxx;

%looperparams_realtimeD;
run('config\looperparams_nn_t10_ID6.m');
looperEngine.contracts={genContract([],'AAL')};

run('config\commonticks_patternrec_t10_ID5_airlines.m');
%commonticks = cell(0);

%main params
run('config\mainparams_backtest_test_t10_patternrec_ID5.m');

patternrec_prepare_t7;
trainDataBase.dates={'2020-05-13','2020-05-14','2020-05-15','2020-05-18','2020-05-19','2020-05-20','2020-05-21','2020-05-22','2020-05-27','2020-05-28','2020-05-29','2020-06-01','2020-06-02','2020-06-03','2020-06-04','2020-06-05','2020-06-08','2020-06-09','2020-06-10','2020-06-11','2020-06-12','2020-06-15','2020-06-16','2020-06-17','2020-06-18','2020-06-19'};
%trainDataBase.dates={'2020-05-07','2020-05-08','2020-05-18','2020-06-22'}; % test
%dates for validation
%quick
%traindates={'2020-06-01','2020-06-02','2020-06-03','2020-06-04','2020-06-05','2020-06-08','2020-06-09','2020-06-10','2020-06-11','2020-06-12'};

testdates={'2020-05-18','2020-06-23','2020-06-25'};


crumb=[];
rq=[];


%% net could be stay one for all symbols
net_=net_init_t1(looperEngine);

for si=1:ncontracts
    trainData{si}.dates = trainDataBase.dates;
    prep_net_variables;
    
    disp(mainticks{si}.params.contract.Symbol);
    net=net_;
    
    if (isempty(XX{si}))
        
        for ds=1:numel(trainData{si}.dates)
            
            looperEngine.date=trainData{si}.dates{ds};
            looperEngine.dateMinutesNextDay=datetime(trainData{si}.dates{ds})+days(1);
            
            for csi=1:ncommon
                
                disp(['init ' commonticks{csi}.params.contract.Symbol '...']);
                
                if (looperEngine.data.getdatainit==1)
                    [rq,c]=getdata_yahoo_func(looperEngine,commonticks{csi}.params,rq,crumb,0,0);
                end
            end
            
            [rq,c]=getdata_yahoo_func(looperEngine,mainticks{si}.params,rq,crumb,0,0);
            disp('process data...');
            
            %% evaluate commonticks
            %%tic
            %;disp('eval commonticks');
            for si2=1:ncommon
                
                commonticks{si2}.params=strategy_getdata(looperEngine,commonticks{si2}.params);
                commonticks{si2}.params=loadprofile_PMATP1(commonticks{si2}.params,looperEngine);
                commonticks{si2}.params=loadprofile_PAPP1(commonticks{si2}.params,looperEngine);
                commonticks{si2}=strategy_pack1_t10(looperEngine,commonticks{si2},[]);
                %commonticks{si2}.calculations=strategy_breakout_t10(looperEngine,commonticks{si2}.params,[]);
            end
            
            mainticks{si}.params=strategy_getdata(looperEngine,mainticks{si}.params);
            mainticks{si}.params=loadprofile_PMATP1(mainticks{si}.params,looperEngine);
            mainticks{si}.params=loadprofile_PAPP1(mainticks{si}.params,looperEngine);
            mainticks{si}=strategy_pack1_t10(looperEngine,mainticks{si},commonticks);
            
            %%ticbcommon=toc
            patternrec_breakout_t10_single;
            
            XX{si}=[XX{si} trainData{si}.X{ds}];
            TT{si}=[TT{si} trainData{si}.T{ds}];
            tt{si}=[tt{si} trainData{si}.t{ds}];
            viewxx{si}=[viewxx{si},trainData{si}.viewx{ds}];
        end
        
    end
    
    if (looperEngine.train>0)
        
        for i=1:looperEngine.train
            % % train all together
            %net=net_train_t1(net,XX{si},TT{si});
            %viewNet(looperEngine.date,viewxx,netP1, XX,TT,tt);
            
            % train separately
            for di=1:numel(trainData{si}.dates)
                net = net_train_t1(net, trainData{si}.X{di}, trainData{si}.T{di});
            end
        end
    end
    netP1=net;
    disp('size XX');
    size(XX{si})
    
    netfilename=['Z:\My files\Project trading\traderdata\nets\netP1 ' filefriendlysymbol(mainticks{si}.params.contract.Symbol) ' ID' num2str(looperEngine.net.setupId) '.mat'];
    save(netfilename,'netP1');
    
    if (looperEngine.makeNetDataOnlyIfTheyDoNotExist==0)
        clear XX{si} TT{si} tt{si} viewxx{si}
    end
end


for si=1:ncontracts
    run('config\looperparams_nn_test_t10_ID6.m');
    netfilename=['Z:\My files\Project trading\traderdata\nets\netP1 ' filefriendlysymbol(mainticks{si}.params.contract.Symbol) ' ID' num2str(looperEngine.net.setupId) '.mat'];
    load(netfilename);
    
    for ds=1:numel(testdates)
        
        looperEngine.date=testdates{ds};
        looperEngine.dateMinutesNextDay=datetime(testdates{ds})+days(1);
        
        for csi=1:ncommon
            disp(['init ' commonticks{csi}.params.contract.Symbol '...']);
            
            if (looperEngine.data.getdatainit==1)
                [rq,c]=getdata_yahoo_func(looperEngine,commonticks{csi}.params,rq,crumb,0,0);
            end
            
        end
        
        %% evaluate commonticks
        %%tic
        %;disp('eval commonticks');
        for si2=1:ncommon
            commonticks{si2}.params=strategy_getdata(looperEngine,commonticks{si2}.params);
            commonticks{si2}.params=loadprofile_PMATP1(commonticks{si2}.params,looperEngine);
            commonticks{si2}.params=loadprofile_PAPP1(commonticks{si2}.params,looperEngine);
            commonticks{si2}=strategy_pack1_t10(looperEngine,commonticks{si2},[]);
            % commonticks{si2}.calculations=strategy_breakout_t10(looperEngine,commonticks{si2}.params,[]);
        end
        %%ticbcommon=toc
        mainticks{si}.params=strategy_getdata(looperEngine,mainticks{si}.params);
        mainticks{si}.params=loadprofile_PMATP1(mainticks{si}.params,looperEngine);
        mainticks{si}.params=loadprofile_PAPP1(mainticks{si}.params,looperEngine);
        mainticks{si}=strategy_pack1_t10(looperEngine,mainticks{si},commonticks);
        
        patternrec_breakout_t10_single;
        
        viewNet([mainticks{si}.params.contract.Symbol ' ' looperEngine.date], ...
            trainData{si}.viewx{ds},netP1, trainData{si}.X{ds},trainData{si}.T{ds},trainData{si}.t{ds});
    end
    
end
