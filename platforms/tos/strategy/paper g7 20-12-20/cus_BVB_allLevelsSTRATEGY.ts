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
input goodvolumethresh = 1;

input donotuseFPPP=1;

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


script RSI {
input length = 9;
input price = close;
input averageType = AverageType.WILDERS;

def NetChgAvg = MovingAverage(averageType, price - price[1], length);
def TotChgAvg = MovingAverage(averageType, AbsValue(price - price[1]), length);
def ChgRatio = if TotChgAvg != 0 then NetChgAvg / TotChgAvg else 0;
plot RSI = 50 * (ChgRatio + 1);
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


script crosspivot {
    input length = 4;
    input PilotsAgg = AggregationPeriod.DAY;

    input dir = CrossingDirection.ABOVE;
    input svedisplace = 0;
    input BarsAgg = AggregationPeriod.MIN;

    input pivoterromargin = 0.005;
    input doOnlyRealtime = 1;

    input pivot=0;

    def errorpercent = if (dir == CrossingDirection.ABOVE) then 1 + pivoterromargin else 1 - pivoterromargin ;

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
   
    def compfull1 = if (dir == CrossingDirection.ABOVE) then open[1] else comparevalue;
    def compfull2 = if (dir == CrossingDirection.ABOVE) then comparevalue else open[1];


    plot crosshappened = (Crosses(comparevalue, pivot * errorpercent, dir) or (pivot < compfull2 and pivot > compfull1));
 # plot crosshappened = (fold index  = 1 to length with p  = 1 do ( p  and (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index ] < pivot else  open(period = BarsAgg)[index ] > pivot))) and (Crosses(comparevalue, pivot * errorpercent, dir) or (pivot < compfull2 and pivot > compfull1));  
}


#levels
#SVE
   def s3 = SVEPivots(PilotsAggd)."s3";
   def s2 = SVEPivots(PilotsAggd)."s2";
   def s1 = SVEPivots(PilotsAggd)."s1";
   def pp = SVEPivots(PilotsAggd)."pp";
   def r1 = SVEPivots(PilotsAggd)."r1";
   def r2 = SVEPivots(PilotsAggd)."r2";
   def r3 = SVEPivots(PilotsAggd)."r3";
#Round
def rval;
def rval2;

if (close < 20) {
    rval = 1;
rval2=0.5;
} else if (close < 100) {
    rval = 5;
rval2=1;
} else if (close < 500) {
    rval = 10;
    rval2=5;
}else if (close<1000) {
rval=20;
rval2=10;
} else {
rval=50;
rval2=10;
}

    def rd1 = roundDown(close*1.02/rval,0)*rval;
    def ru1 = RoundUp(close * .98 / rval, 0) * rval;
    def rd2 = roundDown(close*1.02/rval2,0)*rval2;
    def ru2 = RoundUp(close * .98 / rval2, 0) * rval2;

#dailyhighlow
    def dh = Highest(high(period = PilotsAggd)[-displace], 1);
    def dl = Lowest(low(period = PilotsAggd)[-displace], 1);


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

def rsiup;
def rsidn;


if (dfindend3 > 0 or doOnlyRealtime == 0)
{

    Momentum_w = wclose - wopen;
    momentum_d = close - open(period = AggregationPeriod.DAY);
    thresh = .03 * close;
    Momentum =1;# if (Momentum_w > -thresh) then 1 else (if (Momentum_w < thresh ) then -1 else 0);

    goodvolume = largevolume();

    if (goodvolume > goodvolumethresh and Momentum!=0)
    {

        haspp =if (donotuseFPPP ) then 1 else (pocketpivot() within 5 bars);
        rsiup=1;#RSI()>50 and RSI()<90 and RSI()[1]<70 and RSI()[2]<70 and RSI()[3]<70 and relativestrength()>relativestrength()[5];
        if (haspp and rsiup)
        {

            upd_ = crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,s3)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,s2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,s1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,pp)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,r1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,r2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,r3)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,rd1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,ru1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,rd2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,ru2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,dh)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.ABOVE, displace, BarsAggd, pivoterromargin, doOnlyRealtime,dl)."crosshappened";

            upd = upd_;#selectcross(upd_, 1);- monthlywithin(udpc, udpn);
            umonthlywithinnot=1;
            udpn=0;
            udpc=0;

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

        hasfp = if (donotuseFPPP) then 1 else falletpivot() within 5 bars ;
         rsidn=1;#RSI()<50 and RSI()>10 and RSI()[1]>30 and RSI()[2]>30 and RSI()[3]>30  and relativestrength()<relativestrength()[5];
        if (hasfp and rsidn)
        {
            dnd_ =  crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,s3)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,s2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,s1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,pp)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,r1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,r2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,r3)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,rd1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,ru1)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,rd2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,ru2)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,dh)."crosshappened" or
                    crosspivot(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin, doOnlyRealtime,dl)."crosshappened";
            dnd = dnd_;#selectcross(dnd_, 1);
            ddpn = 0;#crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin)."pivotnext";
            ddpc = 0;#crosspivots(crossoverlength, PilotsAggd, CrossingDirection.BELOW, displace, BarsAggd, pivoterromargin)."pivotbreak";
            dmonthlywithinnot = 1;# - monthlywithin(ddpc, ddpn);
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
        rsiup=0;
        rsidn=0;
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
    rsiup=0;
    rsidn=0;
    ddpn = 0;
    ddpc = 0;
    udpn = 0;
    udpc = 0;
    dmonthlywithinnot = 0;
    umonthlywithinnot = 0;
    ddirectionwithprev = 0;
udirectionwithprev = 0;
}


AddChartBubble(pselld or pbuyd, high * 1, goodvolume + "," + rsi());


Alert(pselld, "short " + GetSymbol(), Alert.ONCE, Sound.Ding);
Alert(pbuyd, "long " + GetSymbol(), Alert.ONCE, Sound.Ding);

def marktestarted = GetTime() -3*60*1000 > RegularTradingStart(GetYYYYMMDD());
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;

def closetoendofmarket = GetTime() + 10 * 60 * 1000 > RegularTradingEnd(GetYYYYMMDD());
input tradesize = 1;

AddOrder(OrderType.BUY_TO_OPEN, pbuyd  and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN,"bto@"+open[-1]);
AddOrder(OrderType.SELL_TO_OPEN, pselld and marketTime, open[-1], tradesize, Color.RED, Color.RED,"sto@"+open[-1]);

#AddOrder(OrderType.SELL_TO_CLOSE, rs < 0  and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN,"rs<0 stc@"+open[-1]);
#AddOrder(OrderType.BUY_TO_CLOSE, rs > 0 and marketTime, open[-1], tradesize, Color.RED, Color.RED,"rs>0 btc@"+open[-1]);

#AddOrder(OrderType.SELL_TO_CLOSE, closetoendofmarket and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN,");
#AddOrder(OrderType.BUY_TO_CLOSE, closetoendofmarket and marketTime, open[-1], tradesize, Color.RED, Color.RED);


#AddOrder(OrderType.SELL_TO_CLOSE, goodvolume and close < open and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN,"goodvol reverse stc@"+open[-1]);
#AddOrder(OrderType.BUY_TO_CLOSE, goodvolume and close > open and marketTime, open[-1], tradesize, Color.RED, Color.RED,"goodvol reverse btc@"+open[-1]);