#
# TD Ameritrade IP Company, Inc. (c) 2014-2020
#

input length = 14;
input averageType = AverageType.WILDERS;

plot ATR = MovingAverage(averageType, TrueRange(high(period = AggregationPeriod.DAY), close(period = AggregationPeriod.DAY), low(period = AggregationPeriod.DAY)), length);

AddLabel(1, "ATR:" + ATR);

def cc = close(period = AggregationPeriod.DAY);
def dd = AbsValue(cc - cc[1]);
AddLabel(1, "move:" + dd);
AddLabel(1, "room:" + (ATR - dd));