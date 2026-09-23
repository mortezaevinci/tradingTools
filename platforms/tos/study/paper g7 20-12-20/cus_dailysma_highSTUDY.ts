#
# TD Ameritrade IP Company, Inc. (c) 2011-2020
#

input price = FundamentalType.HIGH;
input aggregationPeriod = AggregationPeriod.DAY;
input length = 50;
input displace = 0;
input showOnlyLastPeriod = no;

plot DailySMA;

if showOnlyLastPeriod and !IsNaN(high(period = aggregationPeriod)[-1]) {
    DailySMA = Double.NaN;
} else {
    DailySMA = Average(fundamental(price, period = aggregationPeriod)[-displace], length);
}

DailySMA.SetDefaultColor(Color.Red);
DailySMA.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);