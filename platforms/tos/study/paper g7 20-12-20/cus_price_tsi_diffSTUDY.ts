declare lower;

rec c0=if (getday()<>getday()[1]) then close else c0[1];


def cdiff = close-c0;

#
# TD Ameritrade IP Company, Inc. (c) 2007-2020
#

input longLength = 25;
input shortLength = 13;
input signalLength = 8;
input averageType = AverageType.EXPONENTIAL;

def diff = close - close[1];
def doubleSmoothedAbsDiff = MovingAverage(averageType, MovingAverage(averageType, AbsValue(diff), longLength), shortLength);

def TSI;
def Signal;

TSI = if doubleSmoothedAbsDiff == 0 then 0
      else 100 * (MovingAverage(averageType, MovingAverage(averageType, diff, longLength), shortLength)) / doubleSmoothedAbsDiff;
Signal = MovingAverage(averageType, TSI, signalLength);

rec tsi0=if (getday()<>getday()[1]) then TSI else tsi0[1];
def tsidiff=tsi-tsi0;

plot ct=cdiff/(tsidiff+100);