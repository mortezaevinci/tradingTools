
def diff=close-close[1];
plot Data =if (diff<100000000) then diff else double.nan;