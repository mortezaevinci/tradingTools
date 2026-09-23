#
# TD Ameritrade IP Company, Inc. (c) 2007-2020
#

declare lower;
declare zerobase;

input length = 5;
input multiplier = 5;

script largevolume {
    input length = 20;
    input multiplier = 1;

    def VolAvg = Average(volume(period = AggregationPeriod.DAY), length) / 480 ;
    def volhigh = Highest(volume(period = AggregationPeriod.DAY), length) / 480;


    def largevolume = if (volume > volhigh * multiplier) then volume/volhigh* multiplier else 0;
    plot vol = largevolume;
plot thresh= volhigh * multiplier;
}



def dir;
def VolAvg = Average(volume(period = AggregationPeriod.DAY), length) / 480;
def volhigh = Highest(volume(period = AggregationPeriod.DAY), length) / 480;

if close > open
then
{
    dir = 1;
}
else
{
    dir = -1;
}
;

#VolAvg.SetDefaultColor(GetColor(8));
plot thresh= largevolume()."thresh";# volhigh * multiplier;
plot largevolumeplot = if (volume > volhigh * multiplier) then dir else 0;


def largevolume = fold index = 1 to 5 with p=0 do ( if (p == 0 and volume[index] > volhigh * multiplier) then (index * dir) else p);
plot volindex = largevolume;