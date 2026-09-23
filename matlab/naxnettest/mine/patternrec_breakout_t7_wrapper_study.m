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

for i=1:5
    for ds=1:numel(traindates)
    looperParams.date=traindates{ds};
    looperParams.dateMinutesNextDay=minutenextday;
    patternrec_breakout_t7;
     showtrained;
    end
   
end



 run('config\looperparams_nn_test_t1.m');
 
 looperParams.date='2020-06-01';
looperParams.dateMinutesNextDay=minutenextday;
 patternrec_breakout_t7;
 showtrained;

 looperParams.date='2020-06-05';
looperParams.dateMinutesNextDay=minutenextday;
 patternrec_breakout_t7; 
 showtrained;
 

 save('trained net.mat');

 zip(['../backup ' datestr(datetime(),'yyyy-mm-dd HH_MM')],{'*.*'});