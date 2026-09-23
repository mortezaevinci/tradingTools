def IV = imp_volatility();
def IVMARKET = imp_volatility("SPY");

def tradeSize = 1;
input length = 20;
input basis = {Annual, default Monthly, Weekly, Daily};

def ap = GetAggregationPeriod();

Assert(ap >= AggregationPeriod.MIN, "Study can only be calculated for time-aggregated charts: " + ap);

def barsPerDay = (RegularTradingEnd(GetYYYYMMDD()) - RegularTradingStart(GetYYYYMMDD())) / ap;
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

def clLog = Log(close / close[1]);
def HV = StDev(clLog, length) * Sqrt(barsPerYear / basisCoeff * length / (length - 1));

def clLogMARKET = Log(close("SPY") / close("SPY")[1]);
def HVMARKET = StDev(clLog, length) * Sqrt(barsPerYear / basisCoeff * length / (length - 1));


def IHV = (IV / HV) / (IVMARKET / HVMARKET);

def IHVave = MovingAverage(AverageType.SIMPLE, IHV, 5);

def movesignal = (IHV crosses above IHVave * 1.2) and (close-open)>0;

input aveLength = 21;

def ave = MovingAverage(AverageType.SIMPLE, close, aveLength);
def aveMARKET = MovingAverage(AverageType.SIMPLE, close("SPY"), aveLength);

def betarate = Log(close / ave * Beta(aveLength, 1, "SPX") * Beta(aveLength, 1, "SPX") / (close("SPY") / aveMARKET));

def enter = movesignal and betarate > 0;

AddOrder(OrderType.BUY_TO_OPEN, enter, close, tradeSize, Color.GREEN, Color.GREEN,"@"+ close);
AddOrder(OrderType.SELL_TO_CLOSE, enter, open[-1], tradeSize, Color.RED, Color.RED,"@"+ open[-1]);