function maintick=strategy_guides_t10(looperEngine,maintick)

    maintick.calculations.plotPointsW=findw(maintick.params.TimeTables.Minute,maintick.calculations);

maintick.calculations.finished=1;
end