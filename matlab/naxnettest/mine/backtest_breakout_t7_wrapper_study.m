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
run('config\looperparams_realtime_study.m');

%run('config\commonticks_test.m');
run('config\commonticks_realtime.m');
%%bypass

%looperParams.symbols={'AAL','AMZN','TSLA','AAPL','NFLX','NVDA','BA','SPY'};
%looperParams.symbols={'AAL','AMZN','TSLA','ROKU','BYND','NVDA','BA','SPY'};
%looperParams.symbols={'AAPL','SPY'};
%looperParams.symbols={'BA'};
%main params
run('config\mainparams_backtest_test_t7_STUDY.m');
%run('config\mainparams_backtest_test_t7_loose.m');

if (looperParams.updaterealtime==1 || looperParams.getalldatainrealtime==1)
    backtest_breakout_t7_workeron;
end

%;tic;
backtest_breakout_t7;
%;ticmain=toc

try
 backtest_breakout_t7_workeroff;
catch
    
end