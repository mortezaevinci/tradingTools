#this is just wrong. do not use.

input monthlyindex=9;
input weeklyindex=5;

def PilotsAgg = AggregationPeriod.DAY;
def PilotsAgg2 = AggregationPeriod.WEEK;
def PilotsAgg3 = AggregationPeriod.MONTH;

def h = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyHigh";
def l = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyLow";

def extra = (h - l) * 100 / 100;

def hh_ = h + extra;
def ll_ = l - extra;


def PH = high(period = PilotsAgg)[1];
def PL = low(period = PilotsAgg)[1];
def PC = close(period = PilotsAgg)[1];

def PH2 = fundamental(fundamentaltype=fundamentaltype.high,period=AggregationPeriod.DAY)[weeklyindex];# high(period = PilotsAgg2)[1];
def PL2 = fundamental(fundamentaltype=fundamentaltype.low,period=AggregationPeriod.DAY)[weeklyindex];#low(period = PilotsAgg2)[1];
def PC2 = fundamental(fundamentaltype=fundamentaltype.close,period=AggregationPeriod.DAY)[weeklyindex];#close(period = PilotsAgg2)[1];

def PH3 =fundamental(fundamentaltype=fundamentaltype.high,period=AggregationPeriod.DAY)[monthlyindex];# high(period = PilotsAgg3)[1];
def PL3 =fundamental(fundamentaltype=fundamentaltype.low,period=AggregationPeriod.DAY)[monthlyindex];# low(period = PilotsAgg3)[1];
def PC3 =fundamental(fundamentaltype=fundamentaltype.close,period=AggregationPeriod.DAY)[monthlyindex];# close(period = PilotsAgg3)[1];

def PP = (PH + PL + PC) / 3;

plot pPP = PP;
plot pR1 = 2 * PP - PL;
plot pS1 = 2 * PP - PH;
plot pr2 = if (hh_ > pr1) then PP + (PH - PL) else Double.NaN;
plot pr3 = if (hh_ > pr2) then 2 * PP + (PH - 2 * PL) else Double.NaN;
plot ps2 = if (ll_ < ps1) then PP - (PH - PL) else Double.NaN;
plot ps3 = if (ll_ < ps2) then 2 * PP + (PH - 2 * PL) else Double.NaN;

def hs = hh_;# pr3;
def ls = 0;#ps3;

def step = if (ls < 10) then 0.5 else (if (ls < 100) then 5 else 50);

def hsr = Round(hs / step, 0) * step;
def lsr = Round(ls / step, 0) * step;

def PP2 = (PH2 + PL2 + PC2) / 3;
def R12 = 2 * PP2 - PL2;
def S12 = 2 * PP2 - PH2;
def r22 = PP2 + (PH2 - PL2) ;
def r32 = 2 * PP2 + (PH2 - 2 * PL2) ;
def s22 = PP2 - (PH2 - PL2);
def s32 =  2 * PP2 + (PH2 - 2 * PL2) ;

plot pr12 = if (R12 < hs and R12 > ls) then R12 else Double.NaN;
plot pr22 = if (r22 < hs and r22 > ls) then r22 else Double.NaN;
plot pr32 = if (r32 < hs and r32 > ls) then r32 else Double.NaN;
plot ps12 = if (S12 < hs and S12 > ls) then S12 else Double.NaN;
plot ps22 = if (s22 < hs and s22 > ls) then s22 else Double.NaN;
plot ps32 = if (s32 < hs and s32 > ls) then s32 else Double.NaN;

def PP3 = (PH3 + PL3 + PC3) / 3;
def R13 = 2 * PP3 - PL3;
def S13 = 2 * PP3 - PH3;
def r23 = PP3 + (PH3 - PL3) ;
def r33 = 2 * PP3 + (PH3 - 2 * PL3) ;
def s23 = PP3 - (PH3 - PL3);
def s33 =  2 * PP3 + (PH3 - 2 * PL3) ;

plot pr13 = if (R13 < hs and R13 > ls) then R13 else Double.NaN;
plot pr23 = if (r23 < hs and r23 > ls) then r23 else Double.NaN;
plot pr33 = if (r33 < hs and r33 > ls) then r33 else Double.NaN;
plot ps13 = if (S13 < hs and S13 > ls) then S13 else Double.NaN;
plot ps23 = if (s23 < hs and s23 > ls) then s23 else Double.NaN;
plot ps33 = if (s33 < hs and s33 > ls) then s33 else Double.NaN;

pPP.AssignValueColor(Color.GRAY);

pS1.AssignValueColor(Color.GREEN);
ps2.AssignValueColor(Color.GREEN);
ps3.AssignValueColor(Color.GREEN);

pR1.AssignValueColor(Color.RED);
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