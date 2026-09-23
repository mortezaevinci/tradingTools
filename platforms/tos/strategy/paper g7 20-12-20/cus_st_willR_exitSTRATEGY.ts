
input length = 13;
input overBought = -20;
input overSold = -80;

def hh = Highest(high, length);
def ll = Lowest(low, length);
def result = if hh == ll then -100 else (hh - close) / (hh - ll) * (-100);

plot wrr = if result > 0 then 0 else result;
plot WR=MovingAverage(AverageType.EXPONENTIAL, wrr, 3);
def LX = WR < -50;
def SX = WR > -50;


AddOrder(OrderType.SELL_TO_CLOSE, LX, open[-1],1, tickcolor = GetColor(0), arrowcolor = GetColor(0));
AddOrder(OrderType.BUY_TO_CLOSE, SX, open[-1], 1,tickcolor = GetColor(0), arrowcolor = GetColor(0));