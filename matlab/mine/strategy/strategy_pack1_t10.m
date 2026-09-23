function maintick=strategy_pack1_t10(looperEngine,maintick,commonticks)
    maintick.calculations=struct();
    maintick.calculations.started=0;
    maintick.calculations.finished=0;
    [maintick.calculations,maintick.debug_daily]=strategy_dailytrend_t10(looperEngine,maintick.params,commonticks);
    [maintick,debug]=strategy_breakout_t11(looperEngine,maintick,commonticks);
    maintick.debug=debug;
    
    %also calculates levels
    maintick.calculations.finished=0;
    [maintick,debug]=strategy_gaprevisit_t11(looperEngine,maintick,commonticks);
    
    maintick.calculations.finished=0;
    maintick=strategy_probability_t10(looperEngine,maintick);
    maintick.calculations.finished=0;
    maintick=strategy_guides_t10(looperEngine,maintick);
    maintick.calculations.finished=0;
    maintick=strategy_finalize_t10(looperEngine,maintick,commonticks);
end