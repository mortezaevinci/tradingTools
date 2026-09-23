#
# TD Ameritrade IP Company, Inc. (c) 2007-2020
#

declare lower;
declare zerobase;

input length = 20;
input multiplier = 1;


def volhigh = Highest(volume(period = AggregationPeriod.DAY), length) / 480;


#VolAvg.SetDefaultColor(GetColor(8));
plot thresh= volhigh * multiplier;
