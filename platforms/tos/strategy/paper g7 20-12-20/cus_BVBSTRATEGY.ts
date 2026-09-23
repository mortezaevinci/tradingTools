#unscriptable options:
#more pivot levels combined (round levels, woodies, local optima) need to be orddeed as well.
# if PP happened right after pupd, or FP hsppened right after pdnd


input PilotsAggd = AggregationPeriod.DAY;
input PilotsAggm = AggregationPeriod.MONTH;

input BarsAggd = AggregationPeriod.MIN;
input BarsAggm = AggregationPeriod.FOUR_HOURS;

input pivoterromargin = 0;

input crossoverlength = 4;
input displace = 0;

input doOnlyRealtime = 0;

input goodvolumethresh = 1.4;

def dfindend = if (close[-10]) then 1 else 2;
def dfindend2 = 3;
def dfindend3 ;
if (dfindend2 > dfindend)
then
{
    dfindend3 = -1;
}
else {
    dfindend3 = 1;
}


script relativestrength {

    input period0 = AggregationPeriod.DAY;

    input CorrelationWithSecurity = "SPX";
    def close2 = close(CorrelationWithSecurity);

    def RS = if close2 == 0 then 0 else close / close2;
#RS.setDefaultColor(GetColor(6));

    def sr = open(period = period0) / open(period = period0, symbol = CorrelationWithSecurity); #CompoundValue("historical data" = RS, "visible data" = if isNaN(sr[1]) then RS else sr[1]);
#def SRatio =  sr;
#SRatio.setDefaultColor(GetColor(5));
    plot percentile = (RS - sr) * 100 / sr;

}

script largevolume {
    input length = 20;
    input multiplier = 1;

    def VolAvg = Average(volume(period = AggregationPeriod.DAY), length) / 480 ;
    def volhigh = Highest(volume(period = AggregationPeriod.DAY), length) / 480;

    def prevVol = (volume + volume[1]) / 2;

    def largevolume = if ( prevVol > volhigh * multiplier) then prevVol / volhigh * multiplier else 0;
    plot vol = largevolume;
}

script monthlywithin
{
    input pc = 0;
    input pn = 0;

    def diff = AbsValue(pc - pn);

    def iswithin_;

    if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."r3" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."r3" - pn) < diff) {
        iswithin_ = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."r2" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."r2" - pn) < diff) {
        iswithin_ = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."r1" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."r1" - pn) < diff) {
        iswithin_ = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."pp" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."pp" - pn) < diff) {
        iswithin_ = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."s1" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."s1" - pn) < diff) {
        iswithin_ = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."s2" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."s2" - pn) < diff) {
        iswithin_ = 1;
    }
    else if (AbsValue(SVEPivots(AggregationPeriod.MONTH)."s3" - pc) < diff and AbsValue(SVEPivots(AggregationPeriod.MONTH)."s3" - pn) < diff) {
        iswithin_ = 1;
    }
    else
    {
        iswithin_ = 0;
    }
    plot iswithin = 0;
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
    def AveragePriceChangePercent = MovingAverage(AverageType.SIMPLE, AbsValue(close[1] - close[2]) / close[2], Period);
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
    def AveragePriceChangePercent = MovingAverage(AverageType.SIMPLE, AbsValue(close[1] - close[2]) / close[2], Period);
    def IsCloseInlowerHalfOfRange = close <= close[1] && close < ((high - low) * .62 + low);
    def IsPriceInTheProperRange = if (IsCloseInlowerHalfOfRange && IsPriceNear10DaySMA && IsPriceAtOrbelow50DaySMA) then 1 else 0;

    plot isfallet = IsVolumeGreaterHighestupVolume && IsPriceInTheProperRange;
}



script selectcross {
    input data = 0;
    input Momentumvalid = 1;

    plot crossauto = if (Momentumvalid) then (data > 0 and data != 4) else data;

}


script crosspivots {
    input length = 4;
    input PilotsAgg = AggregationPeriod.DAY;

    input dir = CrossingDirection.ABOVE;
    input svedisplace = 0;
    input BarsAgg = AggregationPeriod.MIN;

    input pivoterromargin = 0.005;
    input doOnlyRealtime = 1;
    def errorpercent = if (dir == CrossingDirection.ABOVE) then 1 + pivoterromargin else 1 - pivoterromargin ;

    def s3 = SVEPivots(PilotsAgg)."s3"[svedisplace];
    def s2 = SVEPivots(PilotsAgg)."s2"[svedisplace];
    def s1 = SVEPivots(PilotsAgg)."s1"[svedisplace];
    def pp = SVEPivots(PilotsAgg)."pp"[svedisplace];
    def r1 = SVEPivots(PilotsAgg)."r1"[svedisplace];
    def r2 = SVEPivots(PilotsAgg)."r2"[svedisplace];
    def r3 = SVEPivots(PilotsAgg)."r3"[svedisplace];

    def comparevalue;

    if (doOnlyRealtime > 0)
    then
    {
        comparevalue = close;
    }
    else
    {
        if (dir == CrossingDirection.ABOVE)
        {
            comparevalue = high;
        }
        else
        {
            comparevalue = low;
        }
    }
    def rval;
    if (close < 20) {
        rval = 1;
    } else if (close < 100) {
        rval = 5;
    } else if (close < 500) {
        rval = 10;
    } else if (close < 1000) {
        rval = 20;
    } else {
        rval = 50;
    }

    def rd = RoundDown(close * 1.02 / rval, 0) * rval;
    def ru = RoundUp(close * .98 / rval, 0) * rval;
    def rr = if (dir == CrossingDirection.ABOVE) then ru else rd;

    def compfull1 = if (dir == CrossingDirection.ABOVE) then open[1] else comparevalue;
    def compfull2 = if (dir == CrossingDirection.ABOVE) then comparevalue else open[1];




    def upcross1d = (fold index  = 1 to length with p  = 1 do ( p  and (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index ] < s3 else  open(period = BarsAgg)[index ] > s3))) and (Crosses(comparevalue, s3 * errorpercent, dir) or (s3 < compfull2 and s3 > compfull1));
    def upcross2d = (fold index2 = 1 to length with p2 = 1 do (p2 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index2] < s2 else  open(period = BarsAgg)[index2] > s2))) and (Crosses(comparevalue, s2 * errorpercent, dir) or (s2 < compfull2 and s2 > compfull1));
    def upcross3d = (fold index3 = 1 to length with p3 = 1 do (p3 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index3] < s1 else  open(period = BarsAgg)[index3] > s1))) and (Crosses(comparevalue, s1 * errorpercent, dir) or (s1 < compfull2 and s1 > compfull1));
    def upcross4d = (fold index4 = 1 to length with p4 = 1 do (p4 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index4] < pp else  open(period = BarsAgg)[index4] > pp))) and (Crosses(comparevalue, pp * errorpercent, dir) or (pp < compfull2 and pp > compfull1));
    def upcross5d = (fold index5 = 1 to length with p5 = 1 do (p5 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index5] < r1 else  open(period = BarsAgg)[index5] > r1))) and (Crosses(comparevalue, r1 * errorpercent, dir) or (r1 < compfull2 and r1 > compfull1));
    def upcross6d = (fold index6 = 1 to length with p6 = 1 do (p6 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index6] < r2 else  open(period = BarsAgg)[index6] > r2))) and (Crosses(comparevalue, r2 * errorpercent, dir) or (r2 < compfull2 and r2 > compfull1));
    def upcross7d = (fold index7 = 1 to length with p7 = 1 do (p7 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index7] < r3 else  open(period = BarsAgg)[index7] > r3))) and (Crosses(comparevalue, r3 * errorpercent, dir) or (r3 < compfull2 and r3 > compfull1));

    def crossrr = (fold index8 = 1 to length with p8 = 1 do (p8 and  (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index8] < rr else  open(period = BarsAgg)[index8] > rr)))  and (Crosses(comparevalue, rr * errorpercent, dir) or (rr < compfull2 and rr > compfull1));

    plot upcrossd;
    plot pivotbreak;
    plot pivotnext;

    if (crossrr)
    then {
        upcrossd = 10;
        pivotbreak = rr;

        if (dir == CrossingDirection.ABOVE)
        {
            if (s3 > rr) {
                pivotnext = s3;
            }
            else if (s2 > rr) {
                pivotnext = s2;
            }
            else if (s1 > rr) {
                pivotnext = s1;
            }
            else if (pp > rr) {
                pivotnext = pp;
            }
            else if (r1 > rr) {
                pivotnext = r1;
            }
            else if (r2 > rr) {
                pivotnext = r2;
            }
            else if (r3 > rr) {
                pivotnext = r3;
            }
            else {
                pivotnext =  r3 + r3 - r2;
            }
        }
        else
        {
            if (r3 < rr) {
                pivotnext = r3;
            }
            else if (r2 < rr) {
                pivotnext = r2;
            }
            else if (r1 < rr) {
                pivotnext = r1;
            }
            else if (pp < rr) {
                pivotnext = pp;
            }
            else if (s1 < rr) {
                pivotnext = s1;
            }
            else if (s2 < rr) {
                pivotnext = s2;
            }
            else if (s3 < rr) {
                pivotnext = s3;
            }
            else {
                pivotnext = s3 + s3 - s2;
            }
        }
    }
    else  if (upcross1d)
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

}



def goodvolume;

def Momentum_w;
def momentum_d ;
def thresh ;
def Momentum ;

def upd_;
def upd;
plot pbuyd;
def dnd_;
def dnd;
plot pselld;

def udpn;
def udpc;
def umonthlywithinnot;
def ddpn;
def ddpc;
def dmonthlywithinnot;
def haspp ;
def hasfp;
def udirectionwithprev;
def ddirectionwithprev;
def wclose = Fundamental(fundamentaltype = FundamentalType.CLOSE, period = AggregationPeriod.DAY)[0];
def wopen = Fundamental(fundamentaltype = FundamentalType.OPEN, period = AggregationPeriod.DAY)[7];
plot rs = RelativeStrength();

pbuyd.AssignValueColor(Color.GREEN);
pbuyd.SetLineWeight(2);
pbuyd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);

pselld.AssignValueColor(Color.RED);
pselld.SetLineWeight(2);
pselld.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);




if (dfindend3 > 0 or doOnlyRealtime == 0)
{

    Momentum_w = wclose - wopen;
    momentum_d = close - open(period = AggregationPeriod.DAY);
    thresh = .03 * close;
    Momentum = if (Momentum_w > -thresh) then 1 else (if (Momentum_w < thresh ) then -1 else 0);

    goodvolume = largevolume();
    if (goodvolume > goodvolumethresh and Momentum)
    {

        haspp = (pocketpivot() within 3 bars);
        if (haspp)
        {

            upd_ = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime)."upcrossd";
            upd = selectcross(upd_, 1);

            udpn = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime)."pivotnext";
            udpc = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime)."pivotbreak";
            umonthlywithinnot = 1 - monthlywithin(udpc, udpn);

            udirectionwithprev = (close > open) and (close[1] > open[1]);

            pbuyd = if (udirectionwithprev and upd and umonthlywithinnot) then upd_ else Double.NaN;
        }
        else
        {
            upd_ = Double.NaN;
            upd = Double.NaN;
            pbuyd = Double.NaN;
            udpn = 0;
            udpc = 0;
            umonthlywithinnot = 0;
            udirectionwithprev = 0;
        }

        hasfp = falletpivot() within 3 bars ;
        if (hasfp)
        {
            dnd_ = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin);
            dnd = selectcross(dnd_, 1);
            ddpn = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin)."pivotnext";
            ddpc = crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin)."pivotbreak";
            dmonthlywithinnot = 1 - monthlywithin(ddpc, ddpn);
            ddirectionwithprev = (close < open) and (close[1] < open[1]);
            pselld = if (ddirectionwithprev and dnd and dmonthlywithinnot) then dnd_ else Double.NaN;
        }
        else
        {
            dnd_ = Double.NaN;
            dnd = Double.NaN;
            pselld = Double.NaN;
            ddpn = 0;
            ddpc = 0;
            dmonthlywithinnot = 0;
            ddirectionwithprev=0;
        }
    }
    else
    {
        upd_ = Double.NaN;
        upd = Double.NaN;
        dnd_ = Double.NaN;
        dnd = Double.NaN;
        pselld = Double.NaN;
        pbuyd = Double.NaN;
        haspp = 0;
        hasfp = 0;
        ddpn = 0;
        ddpc = 0;
        udpn = 0;
        udpc = 0;
        dmonthlywithinnot = 0;
        umonthlywithinnot = 0;
        udirectionwithprev = 0;
 ddirectionwithprev = 0;
    }
}
else
{
    upd_ = Double.NaN;
    upd = Double.NaN;
    dnd_ = Double.NaN;
    dnd = Double.NaN;
    pselld = Double.NaN;
    pbuyd = Double.NaN;
    goodvolume = Double.NaN;
    Momentum_w = 0;
    momentum_d = 0;
    thresh = 0 ;
    Momentum = 0;
    haspp = 0;
    hasfp = 0;
    ddpn = 0;
    ddpc = 0;
    udpn = 0;
    udpc = 0;
    dmonthlywithinnot = 0;
    umonthlywithinnot = 0;
    ddirectionwithprev = 0;
udirectionwithprev = 0;
}


AddChartBubble(pselld, high * 1.05, goodvolume + "," + rs);
AddChartBubble(pbuyd, low * .95, goodvolume + "," + rs );

Alert(pselld, "short " + GetSymbol(), Alert.ONCE, Sound.Ding);
Alert(pbuyd, "long " + GetSymbol(), Alert.ONCE, Sound.Ding);

def marktestarted = GetTime() -3*60*1000 > RegularTradingStart(GetYYYYMMDD());
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;

def closetoendofmarket = GetTime() + 10 * 60 * 1000 > RegularTradingEnd(GetYYYYMMDD());
input tradesize = 1;

AddOrder(OrderType.BUY_TO_OPEN, pbuyd  and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN);
AddOrder(OrderType.SELL_TO_OPEN, pselld and marketTime, open[-1], tradesize, Color.RED, Color.RED);

#AddOrder(OrderType.SELL_TO_CLOSE, rs < 0  and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN,"rs<0 stc@"+open[-1]);
#AddOrder(OrderType.BUY_TO_CLOSE, rs > 0 and marketTime, open[-1], tradesize, Color.RED, Color.RED,"rs>0 btc@"+open[-1]);

AddOrder(OrderType.SELL_TO_CLOSE, closetoendofmarket and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN);
AddOrder(OrderType.BUY_TO_CLOSE, closetoendofmarket and marketTime, open[-1], tradesize, Color.RED, Color.RED);


#AddOrder(OrderType.SELL_TO_CLOSE, goodvolume and close < open and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN,"goodvol reverse stc@"+open[-1]);
#AddOrder(OrderType.BUY_TO_CLOSE, goodvolume and close > open and marketTime, open[-1], tradesize, Color.RED, Color.RED,"goodvol reverse btc@"+open[-1]);