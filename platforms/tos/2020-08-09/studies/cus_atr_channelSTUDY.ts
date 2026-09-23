input numberofATR = 2;
input length = 10;
input averageType = AverageType.WILDERS;

def ATR = MovingAverage(averageType, TrueRange(high, close, low), length);

def MidLine = MovingAverage(AverageType.SIMPLE, data = close, length = length);

plot atrh = MidLine + ATR * numberofATR;
plot atrl = MidLine - ATR * numberofATR;
#ATR.SetDefaultColor(GetColor(8));


plot signaldn = Crosses(close, atrh, 0) and high[1]>atrh;
plot signalup = Crosses(close, atrl,1) and low[1]<atrl;

signaldn.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
signalup.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);