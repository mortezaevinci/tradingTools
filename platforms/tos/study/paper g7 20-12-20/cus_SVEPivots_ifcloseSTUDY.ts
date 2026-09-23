input PilotsAgg = AggregationPeriod.DAY;


def h = DailyHighLow(PilotsAgg, 1, 0, no)."DailyHigh";
def l = DailyHighLow(PilotsAgg, 1, 0, no)."DailyLow";

def extra = (h - l) * 10 / 100;

def hh = h + extra;
def ll = l - extra;

def hhm = close * 120 / 100;
def llm = close * 80 / 100;

def pp = SVEPivots(PilotsAgg)."PP";

def s1 = SVEPivots(PilotsAgg)."S1";
def r1 = SVEPivots(PilotsAgg)."R1";

plot ppp = if (pp > llm and pp < hhm) then pp else Double.NaN;
plot ps1 = if (s1 > llm and s1 < hhm) then s1 else Double.NaN;
plot pr1 = if (r1 > llm and r1 < hhm) then r1 else Double.NaN;

def r2v=SVEPivots(PilotsAgg)."R2";

plot r2 = if (r2v>llm and r2v<hhm) then r2v else Double.NaN;
plot r3 = if (hh > r1 and r2v>llm and r2v<hhm) then SVEPivots(PilotsAgg)."R3" else Double.NaN;

def s2v=SVEPivots(PilotsAgg)."s2";

plot s2 = if ( r2v>llm and r2v<hhm) then s2v else Double.NaN;
plot s3 = if (ll < s1 and r2v>llm and r2v<hhm) then SVEPivots(PilotsAgg)."s3" else Double.NaN;

ppp.AssignValueColor(Color.GRAY);

ps1.AssignValueColor(Color.LIGHT_GREEN);
s2.AssignValueColor(Color.LIGHT_GREEN);
s3.AssignValueColor(Color.LIGHT_GREEN);

pr1.AssignValueColor(Color.LIGHT_RED);
r2.AssignValueColor(Color.LIGHT_RED);
r3.AssignValueColor(Color.LIGHT_RED);