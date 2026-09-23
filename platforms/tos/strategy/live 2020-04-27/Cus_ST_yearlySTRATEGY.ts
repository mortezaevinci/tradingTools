#SuperTrendOfAvgRSI
#MichaelSF 2/2020
#Original SuperTrend Code By Mobius

## RSI ##
input AvgLength = 10;
input AvgType = AverageType.SIMPLE;
input price = close;

def NetChgAvg = MovingAverage(AverageType.WILDERS, price - price[1], 14);
def TotChgAvg = MovingAverage(AverageType.WILDERS, AbsValue(price - price[1]), 14);
def ChgRatio = if TotChgAvg != 0 then NetChgAvg / TotChgAvg else 0;

def RSI = 50 * (ChgRatio + 1);

def RSIAvg = MovingAverage(AvgType, RSI, AvgLength);
#RSIAvg.SetPaintingStrategy(PaintingStrategy.Line);

## SUPERTREND ##
input AtrMult = 1.0;
input nATR = 20;
input tradeSize = 1;

def ATR = MovingAverage(AverageType.HULL, TrueRange(RSIAvg, RSIAvg, RSIAvg), nATR);
def UP = RSIAvg + (AtrMult * ATR);
def DN = RSIAvg + (-AtrMult * ATR);

def ST = if RSIAvg < ST[1] then UP else DN;

#plot SuperTrend = ST;
#SuperTrend.setDefaultColor(Color.Dark_Gray);

## COLORS ##
#RSIAvg.AssignValueColor(if SuperTrend < RSIAvg then color.green else if SuperTrend > RSIAvg then color.red else color.Gray);

input OverSold = 30;
#OverSold.setDefaultColor(Color.dark_GRAY);
input OverBought = 70;
#OverBought.setDefaultColor(Color.dark_GRAY);

def UpSignal = if ST crosses below RSIAvg then RSIAvg else Double.NaN;
def DownSignal = if ST crosses above  RSIAvg then RSIAvg else Double.NaN;

input smaprice = close;
input smalength = 30;
input smadisplace = 0;
input smashowBreakoutSignals = no;

def SMA = Average(price[-smadisplace], smalength);



def UpAlert =!IsNaN(UpSignal) and close>dailysma()."DailySMA";
def DownAlert = !IsNaN(DownSignal);

AddOrder(OrderType.BUY_TO_OPEN, UpAlert, open[-1], tradeSize, Color.GREEN, Color.GREEN,"@"+ open[-1]);

AddOrder(OrderType.SELL_TO_CLOSE, DownAlert, open[-1], tradeSize, Color.RED, Color.RED, "@ " +open[-1]);
