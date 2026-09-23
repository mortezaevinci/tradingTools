input numberofATR = 2;
input length = 10;
input averageType = AverageType.WILDERS;

def ATR = MovingAverage(averageType, TrueRange(high, close, low), length);

def MidLine = MovingAverage(AverageType.SIMPLE, data = close, length = length);

plot atrh = MidLine + ATR * numberofATR;
plot atrl = MidLine - ATR * numberofATR;
#ATR.SetDefaultColor(GetColor(8));


plot signaldn = Crosses(close, atrh, 0);
plot signalup = Crosses(close, atrl,1);

signaldn.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
signalup.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);

AddOrder(OrderType.BUY_TO_CLOSE, signalup, open[0], 1, Color.RED, Color.RED,"ATR_SX");
AddOrder(OrderType.SELL_TO_CLOSE, signaldn, open[0], 1, Color.RED, Color.RED,"ATR_LX");
AddOrder(OrderType.BUY_TO_OPEN, signalup, open[-1], 1, Color.GREEN, Color.GREEN,"ATR_LE");
AddOrder(OrderType.SELL_TO_OPEN, signaldn, open[-1], 1, Color.GREEN, Color.GREEN,"ATR_SE");
