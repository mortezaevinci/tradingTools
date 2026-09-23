%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show

close all

 global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY;
basedate='20_05_22'; %set to last saturday, where data are gathered


%looperparams_realtime;
run('config\looperparams_backtesthistory.m');
%run('config\looperparams_realtime.m');

run('config\commonticks_test.m');
%%bypass
looperParams.symbols={'LRCX'};

run('config\mainparams_backtest_test_t5.m');

% make sure todayDataPeriod of commonticks and main are the same


tic
backtest_breakout_t5_offline;
t=toc


%close all;