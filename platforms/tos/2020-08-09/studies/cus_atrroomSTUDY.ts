#
# TD Ameritrade IP Company, Inc. (c) 2014-2020
#

input length = 14;
input averageType = AverageType.WILDERS;

plot ATR = MovingAverage(averageType, TrueRange(high(period = AggregationPeriod.DAY), close(period = AggregationPeriod.DAY), low(period = AggregationPeriod.DAY)), length);

def cc = close(period = AggregationPeriod.DAY);
def dd = AbsValue(cc - cc[1]);

AddLabel(1, "room:" + (ATR - dd),createcolor(255*  ((ATR - dd)<0),255* ((ATR - dd)>0),0));