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
%run('config\looperparams_backtestall.m');
run('config\looperparams_realtime.m');

%run('config\commonticks_test.m');
run('config\commonticks_realtime.m');
%%bypass

looperParams.symbols={'AAL','AMZN','TSLA','AAPL','NFLX','NVDA','BA','SPY'};
looperParams.symbols={'AAL','AMZN','TSLA','ROKU','BYND','NVDA','BA','SPY'};
%looperParams.symbols={'AAL','AMZN'};
%looperParams.symbols={'AMD'};
%main params
run('config\mainparams_backtest_test_t6.m');

%;tic;
backtest_breakout_t6;
%;ticmain=toc