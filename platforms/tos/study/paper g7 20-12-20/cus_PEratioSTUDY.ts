declare lower;
def AE = if IsNaN(GetActualEarnings()) then 0 else GetActualEarnings();
plot EPS_TTM = Sum(AE, 252);
def pe = close / EPS_TTM;
AddLabel(yes, "P/E Ratio: " + pe);