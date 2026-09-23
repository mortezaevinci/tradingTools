#
# TD Ameritrade IP Company, Inc. (c) 2007-2020
#

declare lower;
declare zerobase;

input length = 5;
input multiplier=5;

def dir;
def VolAvg = Average(volume(period=aggregationperiod.DAY), length)/480;
def volhigh=highest(volume(period=aggregationperiod.DAY), length)/480;

if close > open then 
{
dir=1;
}
 else 
{
dir=0;
}
;

#VolAvg.SetDefaultColor(GetColor(8));

plot largevolume=if (dir==1 and volume>volhigh*multiplier) then 1 else 0;

AssignBackgroundColor(if largevolume then CreateColor(0, 0, 255) else Color.BLACK);
