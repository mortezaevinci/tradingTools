#
# TD Ameritrade IP Company, Inc. (c) 2011-2020
#

input numDevDn5 = -2.5;
input numDevDn4 = -2;
input numDevDn3 = -1.5;
input numDevDn2 = -1.0;
input numDevDn1 = -.5;
input numDevUp1 = .5;
input numDevUp2 = 1.0;
input numDevUp3 = 1.5;
input numDevUp4 = 2;
input numDevUp5 = 2.5;
input timeFrame = {default DAY, WEEK, MONTH};

def cap = getAggregationPeriod();
def errorInAggregation =
    timeFrame == timeFrame.DAY and cap >= AggregationPeriod.WEEK or
    timeFrame == timeFrame.WEEK and cap >= AggregationPeriod.MONTH;
assert(!errorInAggregation, "timeFrame should be not less than current chart aggregation period");

def yyyyMmDd = getYyyyMmDd();
def periodIndx;
switch (timeFrame) {
case DAY:
    periodIndx = yyyyMmDd;
case WEEK:
    periodIndx = Floor((daysFromDate(first(yyyyMmDd)) + getDayOfWeek(first(yyyyMmDd))) / 7);
case MONTH:
    periodIndx = roundDown(yyyyMmDd / 100, 0);
}
def isPeriodRolled = compoundValue(1, periodIndx != periodIndx[1], yes);

def volumeSum;
def volumeVwapSum;
def volumeVwap2Sum;

if (isPeriodRolled) {
    volumeSum = volume;
    volumeVwapSum = volume * vwap;
    volumeVwap2Sum = volume * Sqr(vwap);
} else {
    volumeSum = compoundValue(1, volumeSum[1] + volume, volume);
    volumeVwapSum = compoundValue(1, volumeVwapSum[1] + volume * vwap, volume * vwap);
    volumeVwap2Sum = compoundValue(1, volumeVwap2Sum[1] + volume * Sqr(vwap), volume * Sqr(vwap));
}
def price = volumeVwapSum / volumeSum;
def deviation = Sqrt(Max(volumeVwap2Sum / volumeSum - Sqr(price), 0));

plot VWAP = price;
plot UpperBand5 = price + numDevUp5 * deviation;
plot UpperBand4 = price + numDevUp4 * deviation;
plot UpperBand3 = price + numDevUp3 * deviation;
plot UpperBand2 = price + numDevUp2 * deviation;
plot UpperBand1 = price + numDevUp1 * deviation;
plot LowerBand1 = price + numDevDn1 * deviation;
plot LowerBand2 = price + numDevDn2 * deviation;
plot LowerBand3 = price + numDevDn3 * deviation;
plot LowerBand4 = price + numDevDn4 * deviation;
plot LowerBand5 = price + numDevDn5 * deviation;

VWAP.setDefaultColor(getColor(0));
