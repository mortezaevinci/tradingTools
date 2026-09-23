#
# TD Ameritrade IP Company, Inc. (c) 2012-2020
#

input adxLength1 = 3;
input adxLength2 = 4;
input adxLength3 = 5;
input diLength1 = 5;
input diLength2 = 8;
input diLength3 = 14;
input tolerance = 2.0;
input averageType = AverageType.WILDERS;

def adx1 = DMI(adxLength1, averageType).ADX;
def adx2 = DMI(adxLength2, averageType).ADX;
def adx3 = DMI(adxLength3, averageType).ADX;
def diPlus1 = DMI(diLength1, averageType);
def diPlus2 = DMI(diLength2, averageType);
def diPlus3 = DMI(diLength3, averageType);
def diMinus1 = DMI(diLength1, averageType)."DI-";
def diMinus2 = DMI(diLength2, averageType)."DI-";
def diMinus3 = DMI(diLength3, averageType)."DI-";

def maxAdx = Max(adx1, Max(adx2, adx3));
def minAdx = Min(adx1, Min(adx2, adx3));
def avgAdx = (adx1 + adx2 + adx3) / 3;
def minDiPlus = Min(diPlus1, Min(diPlus2, diPlus3));
def avgDiPlus = (diPlus1 + diPlus2 + diPlus3) / 3;
def minDiMinus  = Min(diMinus1, Min(diMinus2, diMinus3));
def avgDiMinus = (diMinus1 + diMinus2 + diMinus3) / 3;

assert(tolerance > 0, "'tolerance' must not be negative: " + tolerance);

def adxPeaksFrom70 = avgAdx[1] > 70 and
    adx1 - adx1[1] crosses below 0 and
    adx2 - adx2[1] crosses below 0 and
    adx3 - adx3[1] crosses below 0;

def diPlusBottom5 = avgDiPlus[1] < 10 and
    minDiPlus crosses above 5;
def diMinusBottom5 = avgDiMinus[1] < 10 and
    minDiMinus crosses above 5;

plot Signal1 = maxAdx[1] < 30 and
    maxAdx[1] - minAdx[1] < tolerance and
    adx1 - adx1[1] crosses above 0 and
    adx2 - adx2[1] crosses above 0 and
    adx3 - adx3[1] crosses above 0;

plot Signal2 = adxPeaksFrom70;

def signal3 = diPlusBottom5 and adxPeaksFrom70;
def signal4 = diMinusBottom5 and adxPeaksFrom70;

Signal1.SetPaintingStrategy(PaintingStrategy.BOOLEAN_POINTS);
Signal1.SetLineWeight(3);
Signal1.DefineColor("Normal", GetColor(1));
Signal1.DefineColor("Stronger", GetColor(2));
Signal1.AssignValueColor(if maxAdx[1] < 20 then Signal1.Color("Stronger") else Signal1.Color("Normal"));

Signal2.SetPaintingStrategy(PaintingStrategy.BOOLEAN_POINTS);
Signal2.SetLineWeight(3);
Signal2.DefineColor("Normal", GetColor(3));
Signal2.DefineColor("Stronger", GetColor(4));
Signal2.AssignValueColor(if maxAdx[1] > 90 then Signal2.Color("Stronger") else Signal2.Color("Normal"));

AddOrder(OrderType.BUY_TO_CLOSE, signal3, tickColor = GetColor(6), arrowColor = GetColor(6), name = "DMI_SX");
AddOrder(OrderType.SELL_TO_CLOSE, signal4, tickColor = GetColor(5), arrowColor = GetColor(5), name = "DMI_LX");