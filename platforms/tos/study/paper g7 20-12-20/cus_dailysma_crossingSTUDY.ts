#
# TD Ameritrade IP Company, Inc. (c) 2011-2020
#

input price = FundamentalType.CLOSE;
input aggregationPeriod = AggregationPeriod.DAY;

def sma50 = Average(fundamental(price, period = aggregationPeriod), 50);
def sma100 = Average(fundamental(price, period = aggregationPeriod), 100);
def sma200 = Average(fundamental(price, period = aggregationPeriod), 200);

plot bullish=(sma50 crosses above sma100 or sma50 crosses above sma200);
plot bearish=(sma50 crosses below sma100 or sma50 crosses below sma200);


