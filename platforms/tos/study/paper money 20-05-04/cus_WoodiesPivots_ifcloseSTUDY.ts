#
# TD Ameritrade IP Company, Inc. (c) 2009-2020
#


def h = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyHigh";
def l = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyLow";

def extra = (h - l) * 10 / 100;

def hh = h + extra;
def ll = l - extra;







input timeFrame = {default DAY, "2 DAYS", "3 DAYS", "4 DAYS", WEEK, MONTH, "OPT EXP", QUARTER, YEAR};
input showOnlyToday = no;

def highByPeriod = high(period = timeFrame)[1];
def lowByPeriod = low(period = timeFrame)[1];
def openByPeriod = open(period = timeFrame);
def closeByPeriod = close(period = timeFrame)[-1];

plot R3;
plot R2;
plot R1;
plot PP;
plot S1;
plot S2;
plot S3;

if showOnlyToday and !IsNaN(closeByPeriod)
then {
    R1 = Double.NaN;
    R2 = Double.NaN;
    R3 = Double.NaN;
    PP = Double.NaN;
    S1 = Double.NaN;
    S2 = Double.NaN;
    S3 = Double.NaN;
} else {
    PP = (highByPeriod + lowByPeriod + 2 * openByPeriod) / 4;
    R1 = 2 * PP - lowByPeriod;
    S1 = 2 * PP - highByPeriod;
   

 r2 = if (hh > r1) then (PP + R1 - S1) else Double.NaN;
 r3 = if (hh > R2) then ( R2 + R1 - PP) else Double.NaN;

 s2 = if (ll < s1) then (pp+s1-r1) else Double.NaN;
 s3 = if (ll < s2) then (s2+s1-pp) else Double.NaN;
}

PP.SetDefaultColor(GetColor(0));
R1.SetDefaultColor(GetColor(5));
R2.SetDefaultColor(GetColor(5));
R3.SetDefaultColor(GetColor(5));
S1.SetDefaultColor(GetColor(6));
S2.SetDefaultColor(GetColor(6));
S3.SetDefaultColor(GetColor(6));

PP.SetStyle(Curve.SHORT_DASH);
R1.SetStyle(Curve.SHORT_DASH);
R2.SetStyle(Curve.SHORT_DASH);
R3.SetStyle(Curve.SHORT_DASH);
S1.SetStyle(Curve.SHORT_DASH);
S2.SetStyle(Curve.SHORT_DASH);
S3.SetStyle(Curve.SHORT_DASH);
