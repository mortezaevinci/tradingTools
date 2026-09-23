input PilotsAgg1 = AggregationPeriod.DAY;
input PilotsAgg2 = AggregationPeriod.WEEK;
input PilotsAgg3 = AggregationPeriod.MONTH;

def dh = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyHigh";
def dl = DailyHighLow(AggregationPeriod.DAY, 1, 0, no)."DailyLow";

def PHd = high(period = PilotsAgg)[1];
def PLd = low(period = PilotsAgg)[1];
def PCd = close(period = PilotsAgg)[1];

def PHw = high(period = PilotsAgg2)[1];
def PLw = low(period = PilotsAgg2)[1];
def PCw = close(period = PilotsAgg2)[1];

def PHm = high(period = PilotsAgg3)[1];
def PLm = low(period = PilotsAgg3)[1];
def PCm = close(period = PilotsAgg3)[1];

def PPd = (PH + PL + PC) / 3;
def R1d = 2 * PP - PL;
def S1d = 2 * PP - PH;
def r2d = PP + (PH - PL);
def r3d = 2 * PP + (PH - 2 * PL);
def s2d = PP - (PH - PL) ;
def s3d = 2 * PP + (PH - 2 * PL);

def PPw = (PH2 + PL2 + PC2) / 3;
def R1w = 2 * PP2 - PL2;
def S1w = 2 * PP2 - PH2;
def r2w = PP2 + (PH2 - PL2) ;
def r3w = 2 * PP2 + (PH2 - 2 * PL2) ;
def s2w = PP2 - (PH2 - PL2);
def s3w =  2 * PP2 + (PH2 - 2 * PL2) ;

def PPm = (PH3 + PL3 + PC3) / 3;
def R1m = 2 * PP3 - PL3;
def S1m = 2 * PP3 - PH3;
def r2m = PP3 + (PH3 - PL3) ;
def r3m = 2 * PP3 + (PH3 - 2 * PL3) ;
def s2m = PP3 - (PH3 - PL3);
def s3m =  2 * PP3 + (PH3 - 2 * PL3) ;

plot LastPrice = close(priceType = priceType);