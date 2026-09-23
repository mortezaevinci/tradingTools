
input length = 12;
input num_devs_up = 2.0;

input symbol0 = "SPY";

def close0 = Fundamental(FundamentalType.CLOSE, symbol = symbol0, period = AggregationPeriod.DAY);
def low0 = Fundamental(FundamentalType.LOW, symbol = symbol0, period = AggregationPeriod.DAY);
def value0 =BollingerBands(close0,0,length,-num_devs_up,num_devs_up).UpperBand;
def condition0 = close0 crosses below value0 and low0[1] <= value0;

plot value = BollingerBands(close, 0, length, -num_devs_up, num_devs_up).UpperBand;
def condition = close crosses below value and low[1] <= value;

AddOrder(OrderType.SELL_AUTO, condition and (condition0 within 1 bar), Min(close, value), tickcolor = GetColor(9), arrowcolor = GetColor(9));