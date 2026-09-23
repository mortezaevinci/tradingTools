input PilotsAggd = AggregationPeriod.DAY;
input PilotsAggw = AggregationPeriod.WEEK;
input PilotsAggm = AggregationPeriod.MONTH;

input BarsAggd = AggregationPeriod.mIN;
input BarsAggw = AggregationPeriod.FIFTEEN_MIN;
input BarsAggm = AggregationPeriod.FOUR_hOURS;



input crossoverlength = 4;
input displace = 0;

script selectcross {
input data=0;
    input Momentumvalid=1;

plot crossauto=if (momentumvalid) then (data>1 and data<7) else data;

}

script crosspivots {
    input length = 4;
    input PilotsAgg = AggregationPeriod.DAY;

    input dir = CrossingDirection.ABOVE;
    input svedisplace = 0;
    input BarsAgg=AggregationPeriod.mIN;

    def s3 = SVEPivots(PilotsAgg)."s3"[svedisplace];
    def s2 = SVEPivots(PilotsAgg)."s2"[svedisplace];
    def s1 = SVEPivots(PilotsAgg)."s1"[svedisplace];
    def pp = SVEPivots(PilotsAgg)."pp"[svedisplace];
    def r1 = SVEPivots(PilotsAgg)."r1"[svedisplace];
    def r2 = SVEPivots(PilotsAgg)."r2"[svedisplace];
    def r3 = SVEPivots(PilotsAgg)."r3"[svedisplace];

    def upcross1d = (fold index  = 1 to length with p  = 1 do (p  and (if (dir == CrossingDirection.ABOVE) then open(period=BarsAgg)[index ] < s3 else  open(period=BarsAgg)[index ] > s3))) and  Crosses(close, s3, dir);
    def upcross2d = (fold index2 = 1 to length with p2 = 1 do (p2 and  (if (dir == CrossingDirection.ABOVE) then open(period=BarsAgg)[index2] < s2 else  open(period=BarsAgg)[index2] > s2)))  and  Crosses(close, s2, dir);
    def upcross3d = (fold index3 = 1 to length with p3 = 1 do (p3 and  (if (dir == CrossingDirection.ABOVE) then open(period=BarsAgg)[index3] < s1 else  open(period=BarsAgg)[index3] > s1))) and  Crosses(close, s1, dir);
    def upcross4d = (fold index4 = 1 to length with p4 = 1 do (p4 and  (if (dir == CrossingDirection.ABOVE) then open(period=BarsAgg)[index4] < pp else  open(period=BarsAgg)[index4] > pp)))  and  Crosses(close, pp, dir);
    def upcross5d = (fold index5 = 1 to length with p5 = 1 do (p5 and  (if (dir == CrossingDirection.ABOVE) then open(period=BarsAgg)[index5] < r1 else  open(period=BarsAgg)[index5] > r1)))  and  Crosses(close, r1, dir);
    def upcross6d = (fold index6 = 1 to length with p6 = 1 do (p6 and  (if (dir == CrossingDirection.ABOVE) then open(period=BarsAgg)[index6] < r2 else  open(period=BarsAgg)[index6] > r2)))  and  Crosses(close, r2, dir);
    def upcross7d = (fold index7 = 1 to length with p7 = 1 do (p7 and  (if (dir == CrossingDirection.ABOVE) then open(period=BarsAgg)[index7] < r3 else  open(period=BarsAgg)[index7] > r3)))  and  Crosses(close, r3, dir);

    plot upcrossd = if (upcross1d) then 1 else (if (upcross2d) then 2 else (if (upcross3d ) then 3 else (if (upcross4d) then 4 else (if (upcross5d) then 5 else (if (upcross6d ) then 6 else (if (upcross7d ) then 7 else 0))))));
#plot crossdauto=upcrossd>1 and upcrossd<7;
}

def marktestarted = GetTime()-4*60000 > RegularTradingStart(GetYYYYMMDD()); #ignore first 4 minutes
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;

def Momentum_m= close(period=BarsAggm) - close(period=BarsAggm)[5];
def momentum_d=close-open(period=aggregationperiod.day);
def thresh=.02*close;
def Momentum=if (Momentum_m>-thresh and Momentum_d>-thresh) then 1 else (if (Momentum_m<thresh and Momentum_d<thresh) then -1 else 0);

def upd = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace,BarsAggd);
def upw = crosspivots(crossoverlength, PilotsAggw, CrossingDirection.ABOVE, displace,BarsAggw);
def upm = crosspivots(crossoverlength, PilotsAggm, CrossingDirection.ABOVE, displace,BarsAggm);

plot pupd=marketTime and selectcross(upd,momentum>0);
plot pupw=marketTime and selectcross(upw,momentum>0);
plot pupm=marketTime and selectcross(upm,momentum>0);

pupd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);
pupw.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);
pupm.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);
pupd.setLineWeight(1);
pupw.setLineWeight(2);
pupm.setLineWeight(4);

def upcolor=if (Momentum>0) then 0 else 255;

pupd.assignvaluecolor(createcolor(upcolor,255,upcolor));
pupw.assignvaluecolor(createcolor(upcolor/2,255,upcolor/2));
pupm.assignvaluecolor(createcolor(upcolor/2,255/2,upcolor/2));

def dnd =crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace,BarsAggd);
def dnw =crosspivots(crossoverlength, PilotsAggw, CrossingDirection.BELOW, displace,BarsAggw);
def dnm = crosspivots(crossoverlength, PilotsAggm, CrossingDirection.BELOW, displace,BarsAggm);

plot pdnd=marketTime and selectcross(dnd,momentum<0);
plot pdnw=marketTime and selectcross(dnw,momentum<0);
plot pdnm=marketTime and selectcross(dnm,momentum<0);

pdnd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
pdnw.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
pdnm.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
pdnd.setLineWeight(1);
pdnw.setLineWeight(2);
pdnm.setLineWeight(4);

def dncolor=if (Momentum<0) then 0 else 255;

pdnd.assignvaluecolor(createcolor(255,dncolor,dncolor));
pdnw.assignvaluecolor(createcolor(255,dncolor/2,dncolor/2));
pdnm.assignvaluecolor(createcolor(255/2,dncolor/2,dncolor/2));

def enter=upd ;
def exit=dnd;

input tradeSize = 1;

AddOrder(OrderType.BUY_TO_OPEN, enter, open[-1], tradeSize, Color.GREEN, Color.GREEN,"@"+ open[-1]);
AddOrder(OrderType.SELL_TO_CLOSE, exit, open[-1], tradeSize, Color.RED, Color.RED,"@"+ open[-1]);