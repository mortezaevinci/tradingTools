
input length = 12;
input num_devs_up = 2.0;
input price0 = FundamentalType.CLOSE;
input symbol0 = "SPY";


def close0 = Fundamental(price0, symbol = symbol0, period = AggregationPeriod.DAY);
def value0 = BollingerBands(close0, 0, length, -num_devs_up, num_devs_up).LowerBand;
def condition0 = close0 crosses above value0 and high[1] >= value0;

plot value = BollingerBands(close, 0, length, -num_devs_up, num_devs_up).UpperBand;
plot condition =if( close crosses below value and low[1] <= value) then close else 50000;
