input longLength = 25;
input shortLength = 13;
input signalLength = 8;
input averageType = AverageType.EXPONENTIAL;


input length = 13;
input overBought = -20;
input overSold = -80;

def hh = Highest(high, length);
def ll = Lowest(low, length);
def result = if hh == ll then -100 else (hh - close) / (hh - ll) * (-100);

plot WR = if result > 0 then 0 else result;


def diff = close - close[1];
def doubleSmoothedAbsDiff = MovingAverage(averageType, MovingAverage(averageType, AbsValue(diff), longLength), shortLength);

def TSI;
def Signal;

TSI = if doubleSmoothedAbsDiff == 0 then 0
      else 100 * (MovingAverage(averageType, MovingAverage(averageType, diff, longLength), shortLength)) / doubleSmoothedAbsDiff;
Signal = MovingAverage(averageType, TSI, signalLength);

def LE = TSI crosses above Signal and (WR < overBought within 2 bars);
def SE = TSI crosses below Signal and (WR > overSold within 2 bars);


AddOrder(OrderType.BUY_AUTO, LE, open[-1], 1, tickcolor = GetColor(0), arrowcolor = GetColor(0),"TW");
AddOrder(OrderType.SELL_AUTO, SE, open[-1], 1, tickcolor = GetColor(0), arrowcolor = GetColor(0),"TW");