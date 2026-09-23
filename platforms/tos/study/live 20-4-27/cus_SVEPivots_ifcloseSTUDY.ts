input PilotsAgg = AggregationPeriod.DAY;


def h = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyHigh";
def l = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyLow";

def extra = (h - l) * 10 / 100;

def hh = h + extra;
def ll = l - extra;

plot pp = SVEPivots(PilotsAgg)."PP";

plot s1 = SVEPivots(PilotsAgg)."S1";
plot r1 = SVEPivots(PilotsAgg)."R1";



plot r2 = if (hh > r1) then SVEPivots(PilotsAgg)."R2" else Double.NaN;
plot r3 = if (hh > SVEPivots(PilotsAgg)."R2") then SVEPivots(PilotsAgg)."R3" else Double.NaN;

plot s2 = if (ll < s1) then SVEPivots(PilotsAgg)."s2" else Double.NaN;
plot s3 = if (ll < SVEPivots(PilotsAgg)."s2") then SVEPivots(PilotsAgg)."s3" else Double.NaN;

pp.AssignValueColor(Color.GRAY);

s1.AssignValueColor(Color.GREEN);
s2.AssignValueColor(Color.GREEN);
s3.AssignValueColor(Color.GREEN);

r1.AssignValueColor(Color.RED);
r2.AssignValueColor(Color.RED);
r3.AssignValueColor(Color.RED);