#
# TD Ameritrade IP Company, Inc. (c) 2011-2020
#

input price = FundamentalType.LOW;
input aggregationPeriod = AggregationPeriod.DAY;
input length = 50;
input displace = 0;
input showOnlyLastPeriod = no;

plot DailySMA;

if showOnlyLastPeriod and !IsNaN(low(period = aggregationPeriod)[-1]) {
    DailySMA = Double.NaN;
} else {
    DailySMA = Average(fundamental(price, period = aggregationPeriod)[-displace], length);
}

DailySMA.SetDefaultColor(Color.Green);
DailySMA.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);