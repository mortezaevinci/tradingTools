input PilotsAgg = AggregationPeriod.DAY;
input PilotsAgg2 = AggregationPeriod.WEEK;
input PilotsAgg3 = AggregationPeriod.MONTH;

def h = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyHigh";
def l = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyLow";

def extra = (h - l) * 10 / 100;

def hh_ = h + extra;
def ll_ = l - extra;


def PH = high(period = PilotsAgg)[1];
def PL = low(period = PilotsAgg)[1];
def PC = close(period = PilotsAgg)[1];

def PH2 = high(period = PilotsAgg2)[1];
def PL2 = low(period = PilotsAgg2)[1];
def PC2 = close(period = PilotsAgg2)[1];

def PH3 = high(period = PilotsAgg3)[1];
def PL3 = low(period = PilotsAgg3)[1];
def PC3 = close(period = PilotsAgg3)[1];

def PP=(PH + PL + PC) / 3;

plot pPP = pp;
plot pR1 = 2 * PP - PL;
plot pS1 = 2 * PP - PH;
plot pr2 = if (hh_ > r1) then PP + (PH - PL) else Double.NaN;
plot pr3 = if (hh_ > r2 then 2 * PP + (PH - 2 * PL) else Double.NaN;
plot ps2 = if (ll_ < s1) then PP - (PH - PL) else Double.NaN;
plot ps3 = if (ll_ < s2) then 2 * PP + (PH - 2 * PL) else Double.NaN;

def hs = Max(Max(r1, r2), r3);
def ls = Min(Min(s1, s2), s3);

def step = if (ls < 10) then 0.5 else (if (ls < 100) then 5 else 50);

def hsr = round(hs / step, 0) * step;
def lsr = round(ls / step, 0) * step;

plot PP2 = (PH2 + PL2 + PC2) / 3;
plot R12 = 2 * PP2 - PL2;
plot S12 = 2 * PP2 - PH2;
plot r22 = PP2 + (PH2- PL2) ;
plot r32 = 2 * PP2 + (PH2 - 2 * PL2) ;
plot s22 = PP2 - (PH2 - PL2);
plot s32 =  2 * PP2 + (PH2 - 2 * PL2) ;

plot pr12 = if (r12 < hs and r12 > ls) then r12 else Double.NaN;
plot pr22 = if (r22 < hs and r22 > ls) then r22 else Double.NaN;
plot pr32 = if (r32 < hs and r32 > ls) then r32 else Double.NaN;
plot ps12 = if (s12 < hs and s12 > ls) then s12 else Double.NaN;
plot ps22 = if (s22 < hs and s22 > ls) then s22 else Double.NaN;
plot ps32 = if (s32 < hs and s32 > ls) then s32 else Double.NaN;

plot PP3 = (PH3 + PL3 + PC3) / 3;
plot R13 = 2 * PP3 - PL3;
plot S13 = 2 * PP3 - PH3;
plot r23 = PP3 + (PH3- PL3) ;
plot r33 = 2 * PP3 + (PH3 - 2 * PL3) ;
plot s23 = PP3 - (PH3 - PL3);
plot s33 =  2 * PP3 + (PH3 - 2 * PL3) ;

plot pr13 = if (r13 < hs and r13 > ls) then r13 else Double.NaN;
plot pr23 = if (r23 < hs and r23 > ls) then r23 else Double.NaN;
plot pr33 = if (r33 < hs and r33 > ls) then r33 else Double.NaN;
plot ps13 = if (s13 < hs and s13 > ls) then s13 else Double.NaN;
plot ps23 = if (s23 < hs and s23 > ls) then s23 else Double.NaN;
plot ps33 = if (s33 < hs and s33 > ls) then s33 else Double.NaN;

ppp.AssignValueColor(Color.GRAY);

ps1.AssignValueColor(Color.GREEN);
ps2.AssignValueColor(Color.GREEN);
ps3.AssignValueColor(Color.GREEN);

pr1.AssignValueColor(Color.RED);
pr2.AssignValueColor(Color.RED);
pr3.AssignValueColor(Color.RED);



ps12.AssignValueColor(Color.PINK);
ps22.AssignValueColor(Color.PINK);
ps32.AssignValueColor(Color.PINK);

pr12.AssignValueColor(Color.PINK);
pr22.AssignValueColor(Color.PINK);
pr32.AssignValueColor(Color.PINK);


ps13.AssignValueColor(Color.YELLOW);
ps23.AssignValueColor(Color.YELLOW);
ps33.AssignValueColor(Color.YELLOW);

pr13.AssignValueColor(Color.YELLOW);
pr23.AssignValueColor(Color.YELLOW);
pr33.AssignValueColor(Color.YELLOW);