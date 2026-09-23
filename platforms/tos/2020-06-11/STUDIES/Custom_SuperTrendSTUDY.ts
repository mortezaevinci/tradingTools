#SuperTrendOfAvgRSI
#MichaelSF 2/2020
#Original SuperTrend Code By Mobius

declare lower;

## RSI ##
input AvgLength = 10;
input AvgType = AverageType.SIMPLE;
input price = close;

def NetChgAvg = MovingAverage(AverageType.WILDERS, price - price[1], 14);
def TotChgAvg = MovingAverage(AverageType.WILDERS, AbsValue(price - price[1]), 14);
def ChgRatio = if TotChgAvg != 0 then NetChgAvg / TotChgAvg else 0;

def RSI = 50 * (ChgRatio + 1);

plot RSIAvg = MovingAverage(AvgType, RSI, AvgLength);
RSIAvg.SetPaintingStrategy(PaintingStrategy.LINE);

## SUPERTREND ##
input AtrMult = 1.0;
input nATR = 20;

def ATR = MovingAverage(AverageType.HULL, TrueRange(RSIAvg, RSIAvg, RSIAvg), nATR);
def UP = RSIAvg + (AtrMult * ATR);
def DN = RSIAvg + (-AtrMult * ATR);

def ST = if RSIAvg < ST[1] then UP else DN;

plot SuperTrend = ST;
SuperTrend.SetDefaultColor(Color.DARK_GRAY);

## COLORS ##
RSIAvg.AssignValueColor(if SuperTrend < RSIAvg then Color.GREEN else if SuperTrend > RSIAvg then Color.RED else Color.GRAY);

input OverSold = 30;
#OverSold.setDefaultColor(Color.dark_GRAY);
input OverBought = 70;
#OverBought.setDefaultColor(Color.dark_GRAY);

plot UpSignal = if ST crosses below RSIAvg then RSIAvg else Double.NaN;
plot DownSignal = if ST crosses above  RSIAvg then RSIAvg else Double.NaN;


UpSignal.SetDefaultColor(Color.UPTICK);
UpSignal.SetPaintingStrategy(PaintingStrategy.ARROW_UP);
DownSignal.SetDefaultColor(Color.DOWNTICK);
DownSignal.SetPaintingStrategy(PaintingStrategy.ARROW_DOWN);
