#unscriptable options:
#more pivot levels combined (round levels, woodies, local optima) need to be orddeed as well.
# if PP happened right after pupd, or FP hsppened right after pdnd


input PilotsAggd = AggregationPeriod.DAY;
input PilotsAggm = AggregationPeriod.MONTH;

input BarsAggd = AggregationPeriod.MIN;

input BarsAggm = AggregationPeriod.FOUR_HOURS;


input crossoverlength = 4;
input displace = 0;

script monthlywithin
{
    input pc = 0;
    input pn = 0;

    def diff = AbsValue(pc - pn);

    plot iswithin;

    if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."r3" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."r3" - pn) < diff) {
        iswithin = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."r2" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."r2" - pn) < diff) {
        iswithin = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."r1" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."r1" - pn) < diff) {
        iswithin = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."pp" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."pp" - pn) < diff) {
        iswithin = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."s1" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."s1" - pn) < diff) {
        iswithin = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."s2" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."s2" - pn) < diff) {
        iswithin = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."s3" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."s3" - pn) < diff) {
        iswithin = 1;
    }
    else
    {
        iswithin = 0;
    }
}

script pocketpivot {
    input Period = 11;  # normal volume lookback period (today + 10 prior days)
    input MaximumDistanceFrom10DaySMAPercent = 1.4;  # Price on pivot day should be near the 10-day SMA.  MAX = 1.6 Per FOSL1, 1.23 per PII, but RAX not extended at 1.61 and 1.64.

# Volume functions
    def DownVolume = If(close < close[1], volume, 0);
    def HighestDownVolume = Highest(DownVolume, Period);
    def FiftyDayAverageVolume = MovingAverage(AverageType.SIMPLE, volume, 100);
    def IsVolumeGreaterHighestDownVolume = if (volume > HighestDownVolume) then 1 else 0;

# Price functions
    def TenDaySMA = MovingAverage(AverageType.SIMPLE, close, 10);
    def FiftyDaySMA = MovingAverage(AverageType.SIMPLE, close, 100);
    def IsLowPriceNear10DaySMA = if ((AbsValue(low - TenDaySMA) / TenDaySMA) <= MaximumDistanceFrom10DaySMAPercent / 100) then 1 else 0;
    def DidPricePass10DaySMA = if (low <= TenDaySMA && close >= TenDaySMA) then 1 else 0;
    def IsPriceNear10DaySMA = if (IsLowPriceNear10DaySMA or DidPricePass10DaySMA) then 1 else 0;
    def IsPriceAtOrAbove50DaySMA = if (close >= FiftyDaySMA) then 1 else 0;
  
    def IsCloseInUpperHalfOfRange = close >= close[1] && close > ((high - low) * .38 + low);
    def IsPriceInTheProperRange = if (IsCloseInUpperHalfOfRange && IsPriceNear10DaySMA && IsPriceAtOrAbove50DaySMA) then 1 else 0;

    plot ispocket = IsVolumeGreaterHighestDownVolume && IsPriceInTheProperRange;

}

script falletpivot {
    input Period = 11;  # normal volume lookback period (today + 10 prior days)
    input MaximumDistanceFrom10DaySMAPercent = 1.4;  # Price on pivot day should be near the 10-day SMA.  MAX = 1.6 Per FOSL1, 1.23 per PII, but RAX not extended at 1.61 and 1.64.

# Volume functions
    def upVolume = If(close > close[1], volume, 0);
    def HighestupVolume = Highest(upVolume, Period);
    def FiftyDayAverageVolume = MovingAverage(AverageType.SIMPLE, volume, 100);
    def IsVolumeGreaterHighestupVolume = if (volume > HighestupVolume) then 1 else 0;

# Price functions
    def TenDaySMA = MovingAverage(AverageType.SIMPLE, close, 10);
    def FiftyDaySMA = MovingAverage(AverageType.SIMPLE, close, 100);
    def IsHighPriceNear10DaySMA = if ((AbsValue(high - TenDaySMA) / TenDaySMA) <= MaximumDistanceFrom10DaySMAPercent / 100) then 1 else 0;
    def DidPricePass10DaySMA = if (high >= TenDaySMA && close <= TenDaySMA) then 1 else 0;
    def IsPriceNear10DaySMA = if (IsHighPriceNear10DaySMA or DidPricePass10DaySMA) then 1 else 0;
    def IsPriceAtOrbelow50DaySMA = if (close <= FiftyDaySMA) then 1 else 0;
   
    def IsCloseInlowerHalfOfRange = close <= close[1] && close < ((high - low) * .62 + low);
    def IsPriceInTheProperRange = if (IsCloseInlowerHalfOfRange && IsPriceNear10DaySMA && IsPriceAtOrbelow50DaySMA) then 1 else 0;

    plot isfallet = IsVolumeGreaterHighestupVolume && IsPriceInTheProperRange;
}



script selectcross {
    input data = 0;
    input Momentumvalid = 1;

    plot crossauto = if (Momentumvalid) then (data > 0  and data != 4) else data;

}


script crosspivots {
    input length = 4;
    input PilotsAgg = AggregationPeriod.DAY;

    input dir = CrossingDirection.ABOVE;
    input svedisplace = 0;
    input BarsAgg = AggregationPeriod.MIN;

    def s3 = SVEPivots(PilotsAgg)."s3"[svedisplace];
    def s2 = SVEPivots(PilotsAgg)."s2"[svedisplace];
    def s1 = SVEPivots(PilotsAgg)."s1"[svedisplace];
    def pp = SVEPivots(PilotsAgg)."pp"[svedisplace];
    def r1 = SVEPivots(PilotsAgg)."r1"[svedisplace];
    def r2 = SVEPivots(PilotsAgg)."r2"[svedisplace];
    def r3 = SVEPivots(PilotsAgg)."r3"[svedisplace];

    def upcross1d = (fold index  = 1 to length with p  = 1 do (p  and (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index ] < s3 else  open(period = BarsAgg)[index ] > s3))) and  Crosses(close, s3, dir);
    def upcross2d = (fold index2 = 1 to length with p2 = 1 do (p2 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index2] < s2 else  open(period = BarsAgg)[index2] > s2)))  and  Crosses(close, s2, dir);
    def upcross3d = (fold index3 = 1 to length with p3 = 1 do (p3 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index3] < s1 else  open(period = BarsAgg)[index3] > s1))) and  Crosses(close, s1, dir);
    def upcross4d = (fold index4 = 1 to length with p4 = 1 do (p4 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index4] < pp else  open(period = BarsAgg)[index4] > pp)))  and  Crosses(close, pp, dir);
    def upcross5d = (fold index5 = 1 to length with p5 = 1 do (p5 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index5] < r1 else  open(period = BarsAgg)[index5] > r1)))  and  Crosses(close, r1, dir);
    def upcross6d = (fold index6 = 1 to length with p6 = 1 do (p6 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index6] < r2 else  open(period = BarsAgg)[index6] > r2)))  and  Crosses(close, r2, dir);
    def upcross7d = (fold index7 = 1 to length with p7 = 1 do (p7 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index7] < r3 else  open(period = BarsAgg)[index7] > r3)))  and  Crosses(close, r3, dir);

    plot upcrossd;
    plot pivotbreak;
    plot pivotnext;

    if (upcross1d)
    then {
        upcrossd = 1;
        pivotbreak = s3;
        if (dir == CrossingDirection.ABOVE)
        then {
            pivotnext = s2;
        } else {
            pivotnext = s3 + s3 - s2;
        }
    } else if (upcross2d)
    then {
        upcrossd = 2;
        pivotbreak = s2;
        if (dir == CrossingDirection.ABOVE)
        then {
            pivotnext = s1;
        } else {
            pivotnext = s3;
        }
    }  else if (upcross3d)
    then {
        upcrossd = 3;
        pivotbreak = s1;
        if (dir == CrossingDirection.ABOVE)
        then {
            pivotnext = pp;
        } else {
            pivotnext = s2;
        }
    } else if (upcross4d)
    then {
        upcrossd = 4;
        pivotbreak = pp;
        if (dir == CrossingDirection.ABOVE)
        then {
            pivotnext = r1;
        } else {
            pivotnext = s1;
        }
    } else if (upcross5d)
    then {
        upcrossd = 5;
        pivotbreak = r1;
        if (dir == CrossingDirection.ABOVE)
        then {
            pivotnext = r2;
        } else {
            pivotnext = pp;
        }
    } else if (upcross6d)
    then {
        upcrossd = 6;
        pivotbreak = r2;
        if (dir == CrossingDirection.ABOVE)
        then {
            pivotnext = r3;
        } else {
            pivotnext = r1;
        }
    } else if (upcross7d)
    then {
        upcrossd = 7;
        pivotbreak = r3;
        if (dir == CrossingDirection.ABOVE)
        then {
            pivotnext = r3 + r3 - r2;
        } else {
            pivotnext = r2;
        }
    } else {
        upcrossd = 0;
        pivotbreak = 0;
        pivotnext = 0;
    }

#plot crossdauto=upcrossd>1 and upcrossd<7;
}

def marktestarted = GetTime() - 12 * 60000 > RegularTradingStart(GetYYYYMMDD()); #ignore first 4 minutes
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;

def Momentum_m = close(period = BarsAggm) - open(period = BarsAggm);
def momentum_d = close - open(period = AggregationPeriod.DAY);
def thresh = .03 * close;
def Momentum = if (Momentum_m > -thresh) then 1 else (if (Momentum_m < thresh ) then -1 else 0);
def rangepre = AbsValue(close - open[2]);


def upd = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd)."upcrossd";
def upm = crosspivots(crossoverlength, PilotsAggm, CrossingDirection.ABOVE, displace, BarsAggm)."upcrossd";

def udpn = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd)."pivotnext";
def udpc = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd)."pivotbreak";
def rangeupd = udpn - udpc;
def fastmoveup = rangepre > 0.1 * AbsValue(rangeupd);

plot pupd =  upd;#selectcross(upd, Momentum > 0);
plot pupm =  upm;#selectcross(upm, Momentum > 0);

def updg=Momentum > 0 and fastmoveup and selectcross(upd, Momentum > 0);
def upmg=Momentum > 0 and fastmoveup and selectcross(upm, Momentum > 0);

pupd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);
pupm.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);
pupd.SetLineWeight(1);
pupm.SetLineWeight(4);

def upcolord = if (updg) then 0 else 255;

def upcolorm = if (upmg) then 0 else 255;

pupd.AssignValueColor(CreateColor(upcolord, 255, upcolord));
pupm.AssignValueColor(CreateColor(upcolorm / 2, 255 / 2, upcolorm / 2));

def umonthlywithinnot = 1 - monthlywithin(udpc, udpn);

def haspp=if (updg and marketTime and umonthlywithinnot) then (pocketpivot() within 3 bars) else 2;
plot pbuyd = if (updg and haspp and marketTime and umonthlywithinnot) then pupd else Double.NaN;
pbuyd.AssignValueColor(Color.GREEN);
pbuyd.SetLineWeight(4);
pbuyd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_WEDGE_UP);

#addchartbubble(haspp==0,low-5, "~PP");

def dnd = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd);
def dnm = crosspivots(crossoverlength, PilotsAggm, CrossingDirection.BELOW, displace, BarsAggm);

def ddpn = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd)."pivotnext";
def ddpc = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd)."pivotbreak";
def rangednd =  ddpn - ddpc;
def fastmovedn = rangepre > 0.1 * AbsValue(rangednd);

plot pdnd = dnd;#selectcross(dnd, Momentum < 0);

plot pdnm = dnm;#selectcross(dnm, Momentum < 0);

def dndg=Momentum < 0 and fastmovedn and selectcross(dnd, Momentum < 0);

def dnmg=Momentum < 0 and fastmovedn and selectcross(dnm, Momentum < 0);

pdnd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);

pdnm.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
pdnd.SetLineWeight(1);

pdnm.SetLineWeight(4);

#def dncolor = if (Momentum < 0 and fastmovedn) then 0 else 255;
def dncolord = if (dndg) then 0 else 255;

def dncolorm = if (dnmg) then 0 else 255;

pdnd.AssignValueColor(CreateColor(255, dncolord, dncolord));
pdnm.AssignValueColor(CreateColor(255 / 2, dncolorm / 2, dncolorm/ 2));

def dmonthlywithinnot = 1 - monthlywithin(ddpc, ddpn);

def hasfp=if (dndg and marketTime and dmonthlywithinnot) then (pocketpivot() within 3 bars) else 2;
plot pselld = if (dndg and hasfp and marketTime and dmonthlywithinnot) then pdnd else Double.NaN;
pselld.AssignValueColor(Color.RED);
pselld.SetLineWeight(4);
pselld.SetPaintingStrategy(PaintingStrategy.BOOLEAN_WEDGE_DOWN);

#addchartbubble(hasfp==0,high+5, "~fP");