#unscriptable options:
#more pivot levels combined (round levels, woodies, local optima) need to be orddeed as well.
# if PP happened right after pupd, or FP hsppened right after pdnd
#unscriptable options:
#more pivot levels combined (round levels, woodies, local optima) need to be orddeed as well.
# if PP happened right after pupd, or FP hsppened right after pdnd

plot upcondb;
plot dncondb;

input PilotsAggd = AggregationPeriod.DAY;
input PilotsAggm = AggregationPeriod.MONTH;

input BarsAggd = AggregationPeriod.MIN;
input BarsAggm = AggregationPeriod.FOUR_HOURS;

input doOnlyRealtime = 1;
input breakoutonly = 0;

input blength=10;

input thresh_gooddiffvol_open_0 = 0.2;
input thresh_gooddiffvol_total_0 = 0.5;
input thresh_gooddiffvol_close_0 = 0.3;
input thresh_goodvol = 0.4;
input thresh_rsimid_50 = 50;
input thresh_lowRS = -5;#-0.25;
input thresh_highRS = 5;#1;
input thresh_drsi_100 = 40;# 25;
input thresh_drs = 0;
input thresh_ddvi = -1;
input thresh_sma = 0.02;

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

script dcandle {
    def O = open;
def H = high;
def C = close;
def L = low; 
def V = volume;

plot pclose = if (H == L) then 0 else SimpleMovingAvg( (C * 2 - L - H) / (H - L), 1);
plot popen  = if (H == L) then 0 else SimpleMovingAvg( (H + L - 2 * O) / (H - L), 1);
plot ptotal = if (H == L) then 0 else SimpleMovingAvg( (C - O) / (H - L), 1);

}

script largedvol {
    input length = 20;
    input multiplier = 0.1;

    def O = open;
def H = high;
def C = close;
def L = low; 
def V = volume;

    def newDay = GetDay()[1] <> GetDay()[2];
    rec rfirstvolume = if (newDay) then volume[1] / 2 + volume / 2 else rfirstvolume[1];
    def firstvolume = rfirstvolume * multiplier;

    plot pclose = V * (C * 2 - L - H) / (H - L)/firstvolume;
    plot popen  = V * (H + L - 2 * O) / (H - L)/firstvolume;
    plot ptotal = V * (C - O) / (H - L)/firstvolume;
}

script diffvolindicator {
#HINT: This study color codes volume by amount of volume on up-tick versus amount of volume on down-tick

    def O = open;
    def H = high;
    def C = close;
    def L = low;
    def V = volume;
    def diffvol = if (H == L) then 0 else SimpleMovingAvg( V * (C * 2 - L - H) / (H - L), 1);

# Selling Volume
    def SV = diffvol;

    def newDay = GetDay() <> GetDay()[1];
    rec rTSV = CompoundValue(1, if newDay then SV else rTSV[1] + SV, 0);# TotalSum(SV);

    rec rfirstvolume = if (newDay) then volume else rfirstvolume[1];
    def firstvolume = rfirstvolume;

    def volhigh = firstvolume;#Highest(volume, 480);

    plot diffvolindicator = rTSV / volhigh;
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

#script largevolume {
#    input length = 20;
#    input multiplier = 0.5;#

#    def newDay = GetDay()[1] <> GetDay()[2];
#    rec rfirstvolume = if (newDay) then volume[1] / 2 + volume / 2 else rfirstvolume[1]*0.999;
#    def firstvolume = rfirstvolume * multiplier;


#    def prevVol = volume ; #/2 for ordinary volume

#    def largevolume = prevVol / firstvolume ;# if ( prevVol > volhigh * multiplier) then prevVol / volhigh * multiplier else 0;
#    plot vol = largevolume;
#}

script largevolume {
    input length = 20;
    input multiplier = 0.5;

    def prevVol = volume ; #/2 for ordinary volume

    def nonlarge = volume[1] + volume[2] + volume[3] + volume[4];

    def largevolume = prevVol / nonlarge ;# if ( prevVol > volhigh * multiplier) then prevVol / volhigh * multiplier else 0;
    plot vol = largevolume;
}

script largediffvolume {
    input length = 20;
    input multiplier = 0.1;

    def newDay = GetDay()[1] <> GetDay()[2];
    rec rfirstvolume = if (newDay) then volume[1] / 2 + volume / 2 else rfirstvolume[1];
    def firstvolume = rfirstvolume * multiplier;




    def diffVolume = (volume * (close * 2 - low - high) / (high - low));

    def prevVol = (diffVolume * 3 + diffVolume[1] + diffVolume[2] + diffVolume[3] + diffVolume[4] + diffVolume[5]) / 8; #/2 for ordinary volume

    def largevolume = prevVol / firstvolume ;# if ( prevVol > volhigh * multiplier) then prevVol / volhigh * multiplier else 0;
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
    def length = 4;
    input PilotsAgg = AggregationPeriod.DAY;

    input dir = CrossingDirection.ABOVE;

    input BarsAgg = AggregationPeriod.MIN;


    input doOnlyRealtime = 1;

    input pivot = 0;

    def multiplier= if (close<500) then 4 else 2;

    def pivotmoved = pivot;#if (CrossingDirection.ABOVE) then RoundUp(pivot * multiplier) / multiplier else RoundDown(pivot * multiplier) / multiplier;

    def comp2 = if (dir == CrossingDirection.ABOVE) then (open[1] < close or open < close) else (open[1] > close or open > close);

    plot crosshappened =  (pivotmoved < high and pivotmoved > low) and comp2;


   # plot crosshappened = (Crosses(comparevalue, pivot * errorpercent, dir) or (pivot < compfull2 and pivot > compfull1));
 # plot crosshappened = (fold index  = 1 to length with p  = 1 do ( p  and (if (dir == CrossingDirection.ABOVE) then open(period = BarsAgg)[index ] < pivot else  open(period = BarsAgg)[index ] > pivot))) and (Crosses(comparevalue, pivot * errorpercent, dir) or (pivot < compfull2 and pivot > compfull1));  
}



#LEVELS
#SVE
def s3 = SVEPivots(PilotsAggd)."s3";
def s2 = SVEPivots(PilotsAggd)."s2";
def s1 = SVEPivots(PilotsAggd)."s1";
def pp = SVEPivots(PilotsAggd)."pp";
def r1 =  SVEPivots(PilotsAggd)."r1";
def r2 =  SVEPivots(PilotsAggd)."r2";
def r3 =  SVEPivots(PilotsAggd)."r3";
#woodies
def ws3 = 0;#WoodiesPivots("DAY")."s3";
def ws2 =  0;#WoodiesPivots("DAY")."s2";
def ws1 =  0;#WoodiesPivots("DAY")."s1";
def wpp =  0;# WoodiesPivots("DAY")."pp";
def wr1 =  0;# WoodiesPivots("DAY")."r1";
def wr2 =  0;# WoodiesPivots("DAY")."r2";
def wr3 =  0;# WoodiesPivots("DAY")."r3";

#day 1030 limits
def ORBegin2 = 0930;
def OREnd2 = 1030;
def ORActive2 = if SecondsTillTime(OREnd2) > 0 and SecondsFromTime(ORBegin2) >= 0 then 1 else 0;
rec ORH2 = if ORH2[1] == 0 or ORActive2[1] == 0 and ORActive2 == 1 then high else if ORActive2 and high > ORH2[1] then high else ORH2[1];
rec ORL2 = if ORL2[1] == 0 or ORActive2[1] == 0 and ORActive2 == 1 then low else if ORActive2 and low < ORL2[1] then low else ORL2[1];
def orh = ORH2;
def orl = ORL2;
#Round
def rval;
def rval2;

if (close < 20) {
    rval = 1;
    rval2 = 0.5;
} else if (close < 100) {
    rval = 5;
    rval2 = 1;
} else if (close < 500) {
    rval = 10;
    rval2 = 5;
} else if (close < 1000) {
    rval = 20;
    rval2 = 10;
} else {
    rval = 50;
    rval2 = 10;
}

def rd1 = RoundDown(close  / rval, 0) * rval;
def ru1 = RoundUp(close  / rval, 0) * rval;
def rd2 = RoundDown(close  / rval2, 0) * rval2;
def ru2 = RoundUp(close  / rval2, 0) * rval2;
#dailyhighlow
def newdaygap = GetDay() <> getday()[5];
#def dh = Highest(high(period = PilotsAggd), 1);
#def dl = Lowest(low(period = PilotsAggd), 1);
rec rdh = if newdaygap then 0 else Max(rdh[1], close[5]);
rec rdl = if newdaygap then 0 else Min(rdl[1], close[5]);
def dh = rdh;
def dl = rdl;

def dh1 = Highest(high(period = PilotsAggd)[-1], 1);
def dl1 = Lowest(low(period = PilotsAggd)[-1], 1);
#drawing of levels



#volumeprofile VA

#def period;
#def month = getYear() * 12 + getMonth();
#period = floor(month - first(month));
#def count = CompoundValue(1, if period != period[1] then (count[1] + period - period[1])  else count[1], 0);
#def cond = count < count[1] + period - period[1];
#def  height = PricePerRow.AUTOMATIC;
#profile vol = volumeProfile("startNewProfile" = cond, "onExpansion" = no, "numberOfProfiles" = 10, "pricePerRow" = height, "value area percent" = 70);
#def con = compoundValue(1, no, no);
#def hVA = if IsNaN(vol.getHighestValueArea()) and con then hVA[1] else vol.getHighestValueArea();
#def lVA = if IsNaN(vol.getLowestValueArea()) and con then lVA[1] else vol.getLowestValueArea();

###end of levels

def diffvolstrength_close;
def diffvolstrength_open;
def diffvolstrength_total;
def volstrength;

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

#def wclose = Fundamental(fundamentaltype = FundamentalType.CLOSE, period = AggregationPeriod.DAY)[0];
#def wopen = Fundamental(fundamentaltype = FundamentalType.OPEN, period = AggregationPeriod.DAY)[7];

pbuyd.AssignValueColor(Color.GREEN);
pbuyd.SetLineWeight(4);
pbuyd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);

pselld.AssignValueColor(Color.RED);
pselld.SetLineWeight(4);
pselld.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);

#def Buying =Volume * (close - low) / (high - low);
#def Selling = Volume * (high - close) / (high - low);

def upcond;
def dncond;

def rs = RelativeStrength();
def rsi = RSI(9)."RSI";
def dvi = diffvolindicator();
def smax = SimpleMovingAvg(close, 5)."SMA";

def drsi=rsi-rsi[5];
def drs=rs-rs[5];
def ddvi=dvi-dvi[5];
def dsmax=smax-smax[5];


if (dfindend3 > 0 or doOnlyRealtime == 0)
{
    volstrength = largevolume();
    diffvolstrength_close = largedvol()."pclose";
    diffvolstrength_total = largedvol()."ptotal";
    diffvolstrength_open = largedvol()."popen";

    hasfp = falletpivot() within 2 bars ;
    haspp = (pocketpivot() within 2 bars);

 upcondb=  (volstrength > thresh_goodvol )
    +2*( diffvolstrength_close > thresh_gooddiffvol_close_0 )
    +4*( diffvolstrength_total > thresh_gooddiffvol_total_0)
    +8*( diffvolstrength_open > thresh_gooddiffvol_open_0)
    +16*( rsi < 50 + thresh_rsimid_50 )
    +32*( rs > thresh_lowRS and rs < thresh_highRS )
    #+64*( drsi < thresh_drsi_100 )
    #+128*( drs > thresh_drs )
    #+256*( ddvi > thresh_ddvi) 
    +512*( dsmax / close * 100 > thresh_sma)
    +1024*(close<BollingerBands(length=blength)."UpperBand");


 dncondb=  (volstrength > thresh_goodvol )
    +2*( diffvolstrength_close < -thresh_gooddiffvol_close_0 )
    +4*( diffvolstrength_total < -thresh_gooddiffvol_total_0)
    +8*(diffvolstrength_open < -thresh_gooddiffvol_open_0 )
    +16*( rsi > 50 - thresh_rsimid_50 )
    +32*( rs < -thresh_lowRS and rs > -thresh_highRS )
    #+64*( drsi > -thresh_drsi_100 )
    #+128*( drs < -thresh_drs )
    #+256*( ddvi  < -thresh_ddvi) 
    +512*( dsmax  / close * 100 < -thresh_sma)
    +1024*(close>BollingerBands(length=blength)."LowerBand");



    upcond = breakoutonly or (upcondb==1599);


 # volstrength > thresh_goodvol 
 #   and diffvolstrength_close > thresh_gooddiffvol_close_0 
  #  and diffvolstrength_total > thresh_gooddiffvol_total_0
  #  and diffvolstrength_open > thresh_gooddiffvol_open_0
  #  and rsi < 50 + thresh_rsimid_50 
 #   and rs > thresh_lowRS and rs < thresh_highRS 
    #and drsi < thresh_drsi_100 
    #and drs > thresh_drs 
    #and ddvi > thresh_ddvi 
  #  and dsmax / close * 100 > thresh_sma);

    dncond = breakoutonly or dncondb==1599;


    #or (volstrength > thresh_goodvol 
    #and diffvolstrength_close < -thresh_gooddiffvol_close_0 
    #and diffvolstrength_total < -thresh_gooddiffvol_total_0
    #and diffvolstrength_open < -thresh_gooddiffvol_open_0 
    #and rsi > 50 - thresh_rsimid_50 
    #and rs < -thresh_lowRS and rs > -thresh_highRS 
    #and drsi > -thresh_drsi_100 
    #and drs < -thresh_drs 
    #and ddvi  < -thresh_ddvi 
    #and dsmax  / close * 100 < -thresh_sma);



    if (1)#goodvolume > thresh_goodvol )
    {


        if (upcond)
        {

            if (0)
            then {
                upd_ =  Double.NaN;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, s3)."crosshappened") {
                upd_ = s3;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, s2)."crosshappened") {
                upd_ = s2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, s1)."crosshappened") {
                upd_ = s1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, pp)."crosshappened") {
                upd_ = pp;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, r1)."crosshappened") {
                upd_ = r1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, r2)."crosshappened") {
                upd_ = r2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, r3)."crosshappened") {
                upd_ = r3;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, rd1)."crosshappened") {
                upd_ = rd1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, ru1)."crosshappened") {
                upd_ = ru1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, rd2)."crosshappened") {
                upd_ = rd2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, ru2)."crosshappened") {
                upd_ = ru2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, orh)."crosshappened") {
                upd_ = orh;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, dh)."crosshappened") {
                upd_ = dh;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.ABOVE,  BarsAggd,  doOnlyRealtime, dh1)."crosshappened") {
                upd_ = dh1;
            }

            else {
                upd_ =  Double.NaN;
            }


           # def upd2 = RoundUp(upd_ * 4) / 4;




            upd = upd_;#selectcross(upd_, 1);- monthlywithin(udpc, udpn);
            umonthlywithinnot = 1;
            udpn = 0;
            udpc = 0;


            pbuyd = if (upd and umonthlywithinnot) then upd_ else Double.NaN;
        }
        else
        {
            upd_ = Double.NaN;
            upd = Double.NaN;
            pbuyd = Double.NaN;
            udpn = 0;
            udpc = 0;
            umonthlywithinnot = 0;

        }


        if (dncond)
        {


            if (0)
            then {
                dnd_ =  Double.NaN;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, s3)."crosshappened") {
                dnd_ = s3;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, s2)."crosshappened") {
                dnd_ = s2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, s1)."crosshappened") {
                dnd_ = s1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, pp)."crosshappened") {
                dnd_ = pp;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, r1)."crosshappened") {
                dnd_ = r1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, r2)."crosshappened") {
                dnd_ = r2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, r3)."crosshappened") {
                dnd_ = r3;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, rd1)."crosshappened") {
                dnd_ = rd1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, ru1)."crosshappened") {
                dnd_ = ru1;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, rd2)."crosshappened") {
                dnd_ = rd2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, ru2)."crosshappened") {
                dnd_ = ru2;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, orl)."crosshappened") {
                dnd_ = orl;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, dl)."crosshappened") {
                dnd_ = dl;
            }
            else if (crosspivot(PilotsAggd, CrossingDirection.BELOW,  BarsAggd,  doOnlyRealtime, dl1)."crosshappened") {
                dnd_ = dl1;
            }
            else {
                dnd_ = 0;
            }
            ;

            dnd = dnd_;#selectcross(dnd_, 1);
            ddpn = 0;#crosspivots(PilotsAggd, CrossingDirection.BELOW,  BarsAggd, pivoterromargin)."pivotnext";
            ddpc = 0;#crosspivots(PilotsAggd, CrossingDirection.BELOW,  BarsAggd, pivoterromargin)."pivotbreak";
            dmonthlywithinnot = 1;# - monthlywithin(ddpc, ddpn);

            pselld = if (dnd and dmonthlywithinnot) then dnd_ else Double.NaN;
        }
        else
        {
            dnd_ = Double.NaN;
            dnd = Double.NaN;
            pselld = Double.NaN;
            ddpn = 0;
            ddpc = 0;
            dmonthlywithinnot = 0;
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
        ddpn = 0;
        ddpc = 0;
        udpn = 0;
        udpc = 0;
        dmonthlywithinnot = 0;
        umonthlywithinnot = 0;

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
   # goodvolume = Double.NaN;
    diffvolstrength_close = 0;
    diffvolstrength_open = 0;
    diffvolstrength_total = 0;
    volstrength = 0;
    upcond = 0;
    dncond = 0;
    haspp = 0;
    hasfp = 0;
    ddpn = 0;
    ddpc = 0;
    udpn = 0;
    udpc = 0;
    dmonthlywithinnot = 0;
    umonthlywithinnot = 0;
upcondb=double.nan;
dncondb=double.nan;

}

def marktestarted = GetTime() > RegularTradingStart(GetYYYYMMDD());
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;
def closetoendofmarket = GetTime() + 10 * 60 * 1000 > RegularTradingEnd(GetYYYYMMDD());

def sfrom = SecondsFromTime(930);
def hour = RoundDown(sfrom / 3600, 0);
def min = RoundDown((sfrom - hour * 3600) / 60, 0);
def sec = sfrom - hour * 3600 - min * 60;


input tradesize = 1;


AddOrder(OrderType.SELL_TO_CLOSE, EntryPrice() <> open and pbuyd  and marketTime, open[0], tradesize, Color.GREEN, Color.GREEN);
AddOrder(OrderType.BUY_TO_CLOSE, EntryPrice() <> open and pselld and marketTime, open[0], tradesize, Color.RED, Color.RED);


AddOrder(OrderType.BUY_TO_OPEN, pbuyd  and marketTime, open[-1], tradesize, Color.GREEN,Color.GREEN,"@;bto;"+";"+open[-1]
+";"+close[-1]
+";"+close[-2]
+";"+close[-3]
+";"+close[-4]
+";"+close[-5]
+";"+close[-6]
+";"+close[-7]
+";"+close[-8]
+";"+close[-9]
+";"+close[-10]
+";"+close[-15]
+";"+close[-20]
+";"+close[-50]
+";"+close[-100]
+";"+close[-200]
+";"+close[-300]
+";"+volstrength
+";"+rsi(length=9)."rsi"
+";"+rsi(length=9)."rsi"[1]
+";"+rsi(length=9)."rsi"[2]
+";"+rsi(length=9)."rsi"[3]
+";"+rsi(length=9)."rsi"[4]
+";"+dvi
+";"+dvi[1]
+";"+dvi[2]
+";"+dvi[3]
+";"+dvi[4]
+";"+(haspp within 3 bars)
+";"+(hasfp within 3 bars)
+";"+relativestrength()
+";"+relativestrength()[1]
+";"+relativestrength()[2]
+";"+relativestrength()[3]
+";"+relativestrength()[4]
+";"+diffvolstrength_close
+";"+dcandle().pclose
+";"+dcandle().popen
+";"+dcandle().ptotal
+";"+largedvol().pclose
+";"+largedvol().popen
+";"+largedvol().ptotal
+";"+AccDist()."AccDist"
+";"+AccDist()."AccDist"[1]
+";"+AccDist()."AccDist"[5]
+";"+AccDist()."AccDist"[10]
+";"+ATR()
+";"+ATR()[1]
+";"+ATR()[5]
+";"+ATR()[10]
+";"+ADX()
+";"+ADX()[1]
+";"+ADX()[5]
+";"+ADX()[10]
+";"+MACD()
+";"+MACD()[1]
+";"+MACD()[5]
+";"+MACD()[10]
+";"+close("SPY")
+";"+close("SPY")[5]
+";"+close("$ADD")
+";"+close("$ADD")[5]
+";"+((close("$TICK"))/1000)
+";"+((close("$TICK")[5])/1000)
+";"+((close("$VOLD"))/1000000)
+";"+((close("$VOLD")[5])/1000000)
+";"+((close("$VOLD")[10])/1000000)
+";"+((close("$VOLD")[50])/1000000)
+";"+(volstrength > thresh_goodvol )
+""+(diffvolstrength_close > thresh_gooddiffvol_close_0 )
+""+(diffvolstrength_total > thresh_gooddiffvol_total_0)
+""+(diffvolstrength_open > thresh_gooddiffvol_open_0)
+""+(rsi < 50 + thresh_rsimid_50 )
+""+(rs > thresh_lowRS and rs < thresh_highRS )

+";");
AddOrder(OrderType.SELL_TO_OPEN, pselld and marketTime, open[-1], tradesize, Color.RED, Color.RED,"@;sto;"+";"+open[-1]
+";"+close[-1]
+";"+close[-2]
+";"+close[-3]
+";"+close[-4]
+";"+close[-5]
+";"+close[-6]
+";"+close[-7]
+";"+close[-8]
+";"+close[-9]
+";"+close[-10]
+";"+close[-15]
+";"+close[-20]
+";"+close[-50]
+";"+close[-100]
+";"+close[-200]
+";"+close[-300]
+";"+volstrength
+";"+rsi(length=9)."rsi"
+";"+rsi(length=9)."rsi"[1]
+";"+rsi(length=9)."rsi"[5]
+";"+rsi(length=9)."rsi"[10]
+";"+rsi(length=9)."rsi"[15]
+";"+dvi
+";"+dvi[1]
+";"+dvi[5]
+";"+dvi[10]
+";"+dvi[15]
+";"+(haspp within 3 bars)
+";"+(hasfp within 3 bars)
+";"+relativestrength()
+";"+relativestrength()[1]
+";"+relativestrength()[5]
+";"+relativestrength()[10]
+";"+relativestrength()[15]
+";"+diffvolstrength_close
+";"+dcandle().pclose
+";"+dcandle().popen
+";"+dcandle().ptotal
+";"+largedvol().pclose
+";"+largedvol().popen
+";"+largedvol().ptotal
+";"+AccDist()."AccDist"
+";"+AccDist()."AccDist"[1]
+";"+AccDist()."AccDist"[5]
+";"+AccDist()."AccDist"[10]
+";"+ATR()
+";"+ATR()[1]
+";"+ATR()[5]
+";"+ATR()[10]
+";"+ADX()
+";"+ADX()[1]
+";"+ADX()[5]
+";"+ADX()[10]
+";"+MACD()
+";"+MACD()[1]
+";"+MACD()[5]
+";"+MACD()[10]
+";"+close("SPY")
+";"+close("SPY")[5]
+";"+close("$ADD")
+";"+close("$ADD")[5]
+";"+close("$TICK")/1000
+";"+close("$TICK")[5]/1000
+";"+close("$VOLD")/1000000
+";"+close("$VOLD")[5]/1000000
+";"+close("$VOLD")[10]/1000000
+";"+close("$VOLD")[50]/1000000
+";"+ (volstrength > thresh_goodvol)
+""+ (diffvolstrength_close < -thresh_gooddiffvol_close_0)
+""+ (diffvolstrength_total < -thresh_gooddiffvol_total_0)
+""+ (diffvolstrength_open < -thresh_gooddiffvol_open_0 )
+""+ (rsi > 50 - thresh_rsimid_50 )
+""+ (rs < -thresh_lowRS and rs > -thresh_highRS )

+";");
