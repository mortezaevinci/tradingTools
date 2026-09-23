close all

 global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY parf;

%looperparams_realtimeD;
%run('config\looperparams_nn_t9_ID3.m');
%run('config\looperparams_nn_t9_ID3_offline_allsymbols.m');
%run('config\looperparams_nn_t9_ID3_offline.m');
run('config\looperparams_return_t10_ID3');

%looperEngine.contracts={genContract([],'AAL')};

run('config\commonticks_patternrec_t9_ID3.m');
commonticks={};
%main params
run('config\mainparams_backtest_test_t9_STUDY_ID3.m');

% if (looperEngine.data.updaterealtime==1 || looperEngine.data.getalldatainrealtime==1)
%     backtest_breakout_t7_workeron;
% end
patternrec_prepare_t7;
%testdates={'2020-05-12','2020-05-13','2020-05-14','2020-05-15','2020-05-18','2020-05-19','2020-05-20','2020-05-21','2020-05-22','2020-05-27','2020-05-28','2020-05-29','2020-06-01','2020-06-02','2020-06-03','2020-06-04','2020-06-05','2020-06-08','2020-06-09','2020-06-10','2020-06-11','2020-06-12','2020-06-15','2020-06-16','2020-06-17','2020-06-18','2020-06-19'};

numberofdays=60;

dates=datetime()-days(numberofdays:-1:1);
dates(~isbusday(dates))=[];
datestrs=datestr(dates,'yyyy-mm-dd');
for i=1:size(datestrs,1)
   testdates{i}=datestrs(i,:); 
end

crumb=[];
rq=[];

ntdates=numel(testdates);

 for si=1:ncontracts
algoreturn{si}=1;
 end

 for si=1:ncontracts

  for ds=1:ntdates
          
      try
          
    looperEngine.date=testdates{ds};
 looperEngine.dateMinutesNextDay=datetime(testdates{ds})+days(1);
 if (isbusday(looperEngine.date))
   
        for csi=1:ncommon
   
     disp(['init ' commonticks{csi}.params.contract.Symbol '...']);
     disp(['processing ' looperEngine.date]);
if (looperEngine.data.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperEngine,commonticks{csi}.params,rq,crumb,0,0);
end
    
    commonticks{csi}.params=strategy_getdata(looperEngine,commonticks{csi}.params);

end

 %% evaluate commonticks
 %%tic
   %;disp('eval commonticks');
    for si2=1:ncommon
        
        commonticks{si2}.params=strategy_getdata(looperEngine,commonticks{si2}.params);
        commonticks{si2}.params=loadprofile_PMATP1(commonticks{si2}.params,looperEngine);
        commonticks{si2}.params=loadprofile_PAPP1(commonticks{si2}.params,looperEngine);
       commonticks=strategy_pack1_t10(looperEngine,commonticks{si2},[]);
% commonticks{si2}.calculations=strategy_breakout_t10(looperEngine,commonticks{si2}.params,[]);
    end
 %%ticbcommon=toc
 
      disp(['init ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) '...']);
    
if (looperEngine.data.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperEngine,mainticks{si}.params,rq,crumb,0,0);
end
 
    mainticks{si}.params=strategy_getdata(looperEngine,mainticks{si}.params);
    mainticks{si}.params=loadprofile_PMATP1(mainticks{si}.params,looperEngine);
    mainticks{si}.params=loadprofile_PAPP1(mainticks{si}.params,looperEngine);
    %[mainticks{si}.calculations,mainticks{si}.debug]=strategy_breakout_t10(looperEngine,mainticks{si}.params,commonticks);
    mainticks{si}=strategy_pack1_t10(looperEngine,mainticks{si},commonticks);
if (mainticks{si}.calculations.started)

ret1=mainticks{si}.calculations.indicators{1}.eval.tradeStrategyBreakoutT8_return(end);
algoreturn{si}=algoreturn{si}*ret1;

end
 end

      catch exception
           dumpReport('error.log', exception) 
  end
  end
  
  
   disp(['total algo return of ' looperEngine.contracts{si}.Symbol '='  num2str(algoreturn{si})]);

 end 
  
totalret=1;
  for si=1:ncontracts
       totalret=totalret*algoreturn{si};
     disp(['total algo return of ' looperEngine.contracts{si}.Symbol '='  num2str(algoreturn{si}) 'after 5% possible slippage and fees=' num2str(algoreturn{si}*0.95)]);
  end
 
    disp(['total algo return of all='  num2str(totalret) ' after 10% possible slippage and fees=' num2str(totalret*.90)]);

 