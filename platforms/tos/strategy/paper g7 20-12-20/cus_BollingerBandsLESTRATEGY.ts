

input length = 12;
input num_devs_dn = 2.0;

input symbol0 = "SPY";

def close0 = Fundamental(FundamentalType.CLOSE, symbol = symbol0, period = AggregationPeriod.DAY);
def high0 = Fundamental(FundamentalType.HIGH, symbol = symbol0, period = AggregationPeriod.DAY);
def value0 = BollingerBands(close0, 0, length, -num_devs_dn, num_devs_dn).LowerBand;
def condition0 = close0 crosses above value0 and high0[1] >= value0;

plot value =BollingerBands(close,0,length,-num_devs_dn,num_devs_dn).LowerBand;
def condition = (close crosses above value or (close > value and low < value)) and high[1] >= value;

AddOrder(OrderType.BUY_AUTO, condition and (condition0 within 1 bar), Max(close, value), tickcolor = GetColor(0), arrowcolor = GetColor(0));