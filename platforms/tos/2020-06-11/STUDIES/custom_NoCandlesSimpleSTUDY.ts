declare lower;
input length = 5;
input extendsearch = 30;
input withinbars = 4;
input averageType = AverageType.WILDERS;

def ATR = MovingAverage(averageType, TrueRange(high, close, low), length);

def b1 = Hammer(length, extendsearch) within withinbars bars;
def b2 = MorningStar(length, extendsearch) within withinbars bars;
def b3 = PiercingLine(length, extendsearch) within withinbars bars;
def b4 = ThreeWhiteSoldiers(length, extendsearch) within withinbars bars;
def b5 = Engulfing(length, extendsearch)."Bullish" within withinbars bars;
def b6 = Harami(length, extendsearch)."Bullish" within withinbars bars;



def d1 = DarkCloudCover(length, extendsearch) within withinbars bars;
def d2 = EveningStar(length, extendsearch) within withinbars bars;
def d3 = HangingMan(length, extendsearch) within withinbars bars;
def d4 = ShootingStar(length, extendsearch) within withinbars bars;
def d5 = Engulfing(length, extendsearch)."Bearish" within withinbars bars;
def d6 = Harami(length, extendsearch)."Bearish" within withinbars bars;

def ball_ = b1 + b2 + b3 + b4 + b5 + b6;
def dall_ = d1 + d2 + d3 + d4 + d5 + d6;

def ball = ball_ * ATR -ATR;
def dall = dall_ * ATR -ATR;

plot enter = ball > 0.05 and dall < 0;
plot exit = dall > 0.05 and ball < 0;
