%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show

close all

 global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY parf;

%looperparams_realtime;
%run('config\looperparams_backtestall.m');
run('config\looperparams_study_t10_ID3');

%run('config\looperparams_realtime_study_extended.m');

%run('config\commonticks_patternrec_t9_ID4.m');
run('config\commonticks_patternrec_t9_ID3.m');

%%bypass
%contracts_yahoo;
%looperEngine.contracts=contracts;
    looperEngine.contracts=genContractsFromSymbols('ZZZ.TO,ETN');
    looperEngine.runIndices=1:numel(looperEngine.contracts);
%main params
%run('config\mainparams_backtest_test_t7_STUDY.m');
run('config\mainparams_backtest_test_t9_STUDY_ID3.m');

%% prepare
backtest_breakout_t10_ib_prepare;
backtest_breakout_t9_prepare;

%% background workers

% if (looperEngine.data.updaterealtime==1 && looperEngine.IB.run==1)
%     ib_realtime_t10_workeron;
% end

if (looperEngine.data.updaterealtime==1 || looperEngine.data.getalldatainrealtime==1)
    backtest_breakout_t7_workeron;
end

%% divide to sections if more than 16 mainticks

contracts_=looperEngine.contracts;


%% main loop

close all
backtest_breakout_t10;
ibEngine_cancel_disconnect;


%% background workers off

try
 backtest_breakout_t7_workeroff;

catch
    
end