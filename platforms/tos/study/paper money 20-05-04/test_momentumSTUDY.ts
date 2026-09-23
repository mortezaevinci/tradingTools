declare lower;

def Momentum_m = close(period = AggregationPeriod.MONTH) - open(period = AggregationPeriod.MONTH);
def momentum_d = close - open(period = AggregationPeriod.DAY);
def thresh = .02 * close;
plot Momentum = if (Momentum_m > -thresh and momentum_d > -thresh) then 1 else (if (Momentum_m < thresh and momentum_d < thresh) then -1 else 0);