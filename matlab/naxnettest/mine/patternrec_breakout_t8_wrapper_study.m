close all

 global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY parf;

%looperparams_realtime;
run('config\looperparams_nn_t1.m');

run('config\commonticks_patternrec_t1.m');

%main params
run('config\mainparams_backtest_test_t7_STUDY.m'); 

% if (looperParams.updaterealtime==1 || looperParams.getalldatainrealtime==1)
%     backtest_breakout_t7_workeron;
% end
patternrec_prepare_t7;
traindates={'2020-06-03','2020-05-28','2020-05-29','2020-06-01','2020-06-02','2020-06-03','2020-05-27','2020-05-22','2020-05-21','2020-05-20','2020-05-19','2020-05-18','2020-05-15'};

XX=[];
TT=[];
tt=[];
viewxx=[];
    for ds=1:numel(traindates)
    looperParams.date=traindates{ds};
    looperParams.dateMinutesNextDay=minutenextday;
    patternrec_breakout_t8;
    XX=[XX X];
    TT=[TT T];
    tt=[tt t];
    viewxx=[viewxx,mainticks{si}.params.TimeTables.Minute.Open'];
    end
   

for si=1:nsymbols
if (looperParams.train>0)
for i=1:looperParams.train
trainingdata{si}.net=net_train_t1(trainingdata{si}.net,XX,TT);
viewNet(looperParams.date,viewxx,trainingdata{si}, XX,TT,tt);
end
end

 
end
    

testdates={'2020-06-01','2020-06-05'};

 for si=1:nsymbols
 run('config\looperparams_nn_test_t1.m');
  for ds=1:numel(testdates)
    looperParams.date=testdates{ds};
looperParams.dateMinutesNextDay=minutenextday;
 patternrec_breakout_t8; 
 viewx=mainticks{si}.params.TimeTables.Minute.Open';
 viewNet(looperParams.date,viewx,trainingdata{si}, X,T,t);
  end
 end 

 save('trained net.mat');

 zip(['../backup ' datestr(datetime(),'yyyy-mm-dd HH_MM')],{'*.*'});