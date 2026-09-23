input PilotsAgg = AggregationPeriod.DAY;
input PilotsAgg2 = AggregationPeriod.WEEK;
input PilotsAgg3 = AggregationPeriod.MONTH;

script findclose{
input searchlength=7;
input period1=AggregationPeriod.WEEK;

def cc=fold index=searchlength to 1 with p=double.nan do (if (p==double.nan) then close(period=period1)[index] else p);
plot pcc=cc;
}

script findhigh{
input searchlength=7;
input period1=AggregationPeriod.WEEK;

def cc=fold index=searchlength to 1 with p=double.nan do (if (p==double.nan) then close(period=period1)[index] else p);
plot pcc=cc;
}

script findlow{
input searchlength=7;
input period1=AggregationPeriod.WEEK;

def cc=fold index=searchlength to 1 with p=double.nan do (if (p==double.nan) then close(period=period1)[index] else p);
plot pcc=cc;
}

def h = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyHigh";
def l = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyLow";

def extra = (h - l) * 10 / 100;

def hh_ = h + extra;
def ll_ = l - extra;


def PH = high(period = PilotsAgg)[1];
def PL = low(period = PilotsAgg)[1];
def PC = close(period = PilotsAgg)[1];

def PH2 = findhigh();# high(period = PilotsAgg2)[1];
def PL2 = findlow();#low(period = PilotsAgg2)[1];
def PC2 = findclose();#close(period = PilotsAgg2)[1];

def PH3 = high(period = PilotsAgg3)[1];
def PL3 = low(period = PilotsAgg3)[1];
def PC3 = close(period = PilotsAgg3)[1];

def PP = (PH + PL + PC) / 3;

plot pPP = PP;
plot pR1 = 2 * PP - PL;
plot pS1 = 2 * PP - PH;
plot pr2 = PP + (PH - PL) ;
plot pr3 = 2 * PP + (PH - 2 * PL) ;
plot ps2 = PP - (PH - PL) ;
plot ps3 =  2 * PP + (PH - 2 * PL);

def PP2 = (PH2 + PL2 + PC2) / 3;
def R12 = 2 * PP2 - PL2;
def S12 = 2 * PP2 - PH2;
def r22 = PP2 + (PH2 - PL2) ;
def r32 = 2 * PP2 + (PH2 - 2 * PL2) ;
def s22 = PP2 - (PH2 - PL2);
def s32 =  2 * PP2 + (PH2 - 2 * PL2) ;

plot pr12 = R12;
plot pr22 = r22;
plot pr32 = r32  ;
plot ps12 = S12 ;
plot ps22 = s22  ;
plot ps32 = s32 ;

def PP3 = (PH3 + PL3 + PC3) / 3;
def R13 = 2 * PP3 - PL3;
def S13 = 2 * PP3 - PH3;
def r23 = PP3 + (PH3 - PL3) ;
def r33 = 2 * PP3 + (PH3 - 2 * PL3) ;
def s23 = PP3 - (PH3 - PL3);
def s33 =  2 * PP3 + (PH3 - 2 * PL3) ;

plot pr13 = R13;#if (R13 < hs and R13 > ls) then R13 else Double.NaN;
plot pr23 = r23;# if (r23 < hs and r23 > ls) then r23 else Double.NaN;
plot pr33 = r33;#if (r33 < hs and r33 > ls) then r33 else Double.NaN;
plot ps13 = R13;#if (S13 < hs and S13 > ls) then S13 else Double.NaN;
plot ps23 = s23;#if (s23 < hs and s23 > ls) then s23 else Double.NaN;
plot ps33 = s33;#if (s33 < hs and s33 > ls) then s33 else Double.NaN;

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