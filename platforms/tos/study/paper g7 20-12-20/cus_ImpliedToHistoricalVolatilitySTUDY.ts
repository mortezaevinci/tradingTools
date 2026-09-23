
declare lower;

def IV = IMP_VOLATILITY();
def IVMARKET=IMP_VOLATILITY("SPY");

input length = 20;
input basis = {Annual, default Monthly, Weekly, Daily};

def ap = getAggregationPeriod();

assert(ap >= AggregationPeriod.MIN, "Study can only be calculated for time-aggregated charts: " + ap);

def barsPerDay = (regularTradingEnd(getYyyyMmDd()) - regularTradingStart(getYyyyMmDd())) / ap;
def barsPerYear =
    if ap > AggregationPeriod.WEEK then 12
    else if ap == AggregationPeriod.WEEK then 52
    else if ap >= AggregationPeriod.DAY then 252 * AggregationPeriod.DAY / ap
    else 252 * barsPerDay;

def basisCoeff;
switch (basis) {
case Annual:
    basisCoeff = 1;
case Monthly:
    basisCoeff = 12;
case Weekly:
    basisCoeff = 52;
case Daily:
    basisCoeff = 252;
}

def clLog = log(close / close[1]);
def HV = stdev(clLog, length) * Sqrt(barsPerYear / basisCoeff * length / (length - 1));

def clLogMARKET = log(close("SPY") / close("SPY")[1]);
def HVMARKET = stdev(clLog, length) * Sqrt(barsPerYear / basisCoeff * length / (length - 1));


plot IHV=(IV/HV)/(IVMARKET/HVMARKET);

plot IHVave=movingAverage(AverageType.SIMPLE,IHV,5);

plot movesignal=(IHV crosses above IHVave*1.2) and (close-open)>0;
