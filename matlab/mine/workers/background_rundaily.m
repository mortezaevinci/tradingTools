function rundaily()
run('config\mainparams_backtest_test_t7.m');
run('config\looperparams_realtime_daily.m');
run('config\commonticks_patternrec_t1.m');
if (~isempty(bypasscontracts))
looperEngine.contracts=bypasscontracts;
end
backtest_breakout_t8;

end