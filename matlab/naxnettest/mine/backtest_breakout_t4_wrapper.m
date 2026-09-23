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

useparfor=Inf; %0 do not use, Inf use

%looperparams_realtime;
run('config\looperparams_backtestall.m');

%%bypass
looperParams.symbols={'SPY'};


run('config\mainparams_backtest_montecarlo.m');

tic
backtest_breakout_t4;
t=toc