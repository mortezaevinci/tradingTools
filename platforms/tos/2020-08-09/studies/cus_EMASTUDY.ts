#
# TD Ameritrade IP Company, Inc. (c) 2011-2020
#

input price = FundamentalType.CLOSE;
input aggregationPeriod = AggregationPeriod.DAY;
input length = 50;
input displace = 0;
input showOnlyLastPeriod = no;

plot EMA;

if showOnlyLastPeriod and !IsNaN(close(period = aggregationPeriod)[-1]) {
    EMA = Double.NaN;
} else {
    EMA = MovingAverage(AverageType.EXPONENTIAL,fundamental(price, period = aggregationPeriod)[-displace], length);
}

EMA.SetDefaultColor(GetColor(1));
EMA.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);

