#
# TD Ameritrade IP Company, Inc. (c) 2007-2020
#

declare lower;

input longLength = 25;
input shortLength = 13;
input signalLength = 8;
input averageType = AverageType.EXPONENTIAL;

def diff = close - close[1];
def doubleSmoothedAbsDiff = MovingAverage(averageType, MovingAverage(averageType, AbsValue(diff), longLength), shortLength);

plot TSI;
plot Signal;

TSI = if doubleSmoothedAbsDiff == 0 then 0
      else 100 * (MovingAverage(averageType, MovingAverage(averageType, diff, longLength), shortLength)) / doubleSmoothedAbsDiff;
Signal = MovingAverage(averageType, TSI, signalLength);

plot ZeroLine = 0;
plot xorder=TSI-Signal;
TSI.SetDefaultColor(GetColor(1));
Signal.SetDefaultColor(GetColor(8));
ZeroLine.SetDefaultColor(GetColor(5));