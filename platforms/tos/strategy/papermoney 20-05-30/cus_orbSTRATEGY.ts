# 30 min opening range Market Volatility V1.1
# Robert Payne
# Adapted to strategy by WalkingBallista and BenTen
# https://usethinkscript.com/threads/opening-range-breakout-strategy-with-market-volatility-for-thinkorswim.164/

script MV {

input atrlength = 14;

input avglength = 500;

input plotlower = {default "yes", "no"};

def vol = reference ATR(atrlength, averageType = AverageType.SIMPLE);

def avgvol = Average(vol, avglength);

def calm = vol < avgvol - (avgvol * .1);

def neutral = avgvol + (avgvol * .1) > vol > avgvol - (avgvol * .1);

def Volatile = vol > avgvol + (avgvol * .1);

AddLabel(yes, Concat("Market is Currently ", (if calm then "Calm" else if neutral then "Neutral" else if Volatile then "Volatile" else "Neutral")),  if calm then Color.GREEN else if neutral then Color.BLUE else if Volatile then Color.RED  else Color.GRAY);

declare lower;

plot window =  vol - avgvol;

window.SetPaintingStrategy(PaintingStrategy.HISTOGRAM);

window.AssignValueColor(if Volatile then Color.RED else if calm then Color.GREEN else if neutral then Color.BLUE else Color.GRAY);

plot zeroline = 0;

};

def volatile = MV().volatile;

def OpenRangeMinutes = 30;
def MarketOpenTime = 0930;
def LastBar = SecondsFromTime(1530) == 0;
input TimeToStopSignal = 1525;
def TradeTimeFilter = SecondsFromTime(TimeToStopSignal);
input ShowTodayOnly = no;
input UseEMACross = yes;
input ema1_len = 8;
input ema2_len = 13;
AddVerticalLine(SecondsFromTime(0930)==0,"Open",Color.Gray,Curve.SHORT_DASH);
AddVerticalLine(!TradeTimeFilter,"Last Signal",Color.Dark_Gray,Curve.SHORT_DASH);
def Today = if GetDay() == GetLastDay() then 1 else 0;
def FirstMinute = if SecondsFromTime(MarketOpenTime) < 60 then 1 else 0;
def OpenRangeTime = if SecondsFromTime(MarketOpenTime) < 60 * OpenRangeMinutes then 1 else 0;

def ORHigh =  if FirstMinute then high else if OpenRangeTime and high > ORHigh[1] then high else ORHigh[1];
def ORLow = if FirstMinute then low else if OpenRangeTime and low < ORLow[1] then low else ORLow[1];

plot OpenRangeHigh = if ShowTodayOnly and !Today then Double.NaN else if !OpenRangeTime then ORHigh else Double.NaN;
plot OpenRangeLow = if ShowTodayOnly and !Today then Double.NaN else if !OpenRangeTime then ORLow else Double.NaN;

OpenRangeHigh.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
OpenRangeHigh.SetDefaultColor(Color.YELLOW);
OpenRangeHigh.SetLineWeight(2);
OpenRangeLow.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
OpenRangeLow.SetDefaultColor(Color.YELLOW);
OpenRangeLow.SetLineWeight(2);

def dailyRange = high(period = "day" )[1] - low(period = "day" )[1];
def range = Average(dailyRange, 10);

plot ema1 = MovAvgExponential(length=ema1_len);
plot ema2 = MovAvgExponential(length=ema2_len);

# Bullish
AddOrder(OrderType.BUY_TO_OPEN, ((!UseEmaCross AND close crosses above OpenRangeHigh) OR (UseEMACross AND ema1 crosses above OpenRangeHigh)) and TradeTimeFilter < 1 and volatile, tradeSize = 100, tickcolor = GetColor(1), arrowcolor = GetColor(1), name = "TC_O");

AddOrder(OrderType.SELL_TO_CLOSE, ema1 crosses below ema2 or (close < OpenRangeHigh) or LastBar, tickcolor = GetColor(1), arrowcolor = GetColor(1), name = "TC_C");

# Bearish
AddOrder(OrderType.SELL_TO_OPEN, ((!UseEmaCross AND close crosses below OpenRangeLow) OR (UseEMACross AND ema1 crosses below OpenRangeLow)) and TradeTimeFilter < 1 and volatile, tradeSize = 100, tickcolor = GetColor(2), arrowcolor = GetColor(2), name = "TC_O");

AddOrder(OrderType.BUY_TO_CLOSE, ema1 crosses above ema2 or (close > OpenRangeLow) or LastBar, tickcolor = GetColor(2), arrowcolor = GetColor(2), name = "TC_C");