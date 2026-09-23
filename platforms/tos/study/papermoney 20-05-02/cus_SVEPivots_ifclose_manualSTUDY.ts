#
# TD Ameritrade IP Company, Inc. (c) 2009-2020
#
input aggregationPeriod=aggregationPeriod.daY;

def h = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyHigh";
def l = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyLow";

def extra = (h - l) * 10 / 100;

def hh_ = h + extra;
def ll_ = l - extra;

plot R3;
plot R2;
plot R1;
plot HH;
plot PP;
plot LL;
plot S1;
plot S2;
plot S3;

def PH = high(period = aggregationPeriod)[1];
def PL = low(period = aggregationPeriod)[1];
def PC = close(period = aggregationPeriod)[1];



HH = PH;
LL = PL;
PP = (PH + PL + PC) / 3;
R1 = 2 * PP - PL;

R2 = PP + (PH - PL);
R3 = 2 * PP + (PH - 2 * PL);
S1 = 2 * PP - PH;
S2 = PP - (PH - PL);
S3 = 2 * PP - (2 * PH - PL);



 

PP.SetDefaultColor(Color.GRAY);
    R1.SetDefaultColor(Color.RED);
    R2.SetDefaultColor(Color.RED);
    R3.SetDefaultColor(Color.RED);
    S1.SetDefaultColor(Color.GREEN);
    S2.SetDefaultColor(Color.GREEN);
    S3.SetDefaultColor(Color.GREEN);