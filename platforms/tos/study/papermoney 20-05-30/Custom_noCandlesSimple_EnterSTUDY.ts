declare lower;
input length = 5;
input extendsearch = 30;
input withinbars = 5;
input averageType = AverageType.WILDERS;

def ATR = MovingAverage(averageType, TrueRange(high, close, low), length);

def b1 = ConcealingBabySwallow(length, extendsearch) within withinbars bars;
def b2 = Hammer(length, extendsearch) within withinbars bars;
def b3 = HighPriceGappingPlay(length, extendsearch) within withinbars bars;
def b4 = HomingPigeon(length, extendsearch) within withinbars bars;
def b5 = InvertedHammer(length, extendsearch) within withinbars bars;
def b6 = MatchingLow(length, extendsearch) within withinbars bars;
def b7 = MatHold(length, extendsearch) within withinbars bars;
def b8 = MorningDojiStar(length, extendsearch) within withinbars bars;
def b9 = MorningStar(length, extendsearch) within withinbars bars;
def b10 = OneWhiteSoldier(length, extendsearch) within withinbars bars;
def b11 = PiercingLine(length, extendsearch) within withinbars bars;
def b12 =  RisingThreeMethods(length, extendsearch) within withinbars bars;
def b13 =  StickSandwich(length, extendsearch) within withinbars bars;
def b14 =  ThreeInsideUp(length, extendsearch) within withinbars bars;
def b15 =  ThreeStarsInTheSouth(length, extendsearch) within withinbars bars;
def b16 =  ThreeWhiteSoldiers(length, extendsearch) within withinbars bars;
def b17 =  UniqueThreeRiverBottom(length, extendsearch) within withinbars bars;
def b18 =  UpsideGapThreeMethods(length, extendsearch) within withinbars bars;
def b19 =  UpsideTasukiGap(extendsearch) within withinbars bars;
def b20 =  AbandonedBaby(length, extendsearch)."Bullish" within withinbars bars;
def b21 =  BeltHold(length, extendsearch)."Bullish" within withinbars bars;
def b22 =  Breakaway(length, extendsearch)."Bullish" within withinbars bars;
def b24 =  Engulfing(length, extendsearch)."Bullish" within withinbars bars;
def b25 =  Harami(length, extendsearch)."Bullish" within withinbars bars;
def b26 =  HaramiCross(length, extendsearch)."Bullish" within withinbars bars;
def b27 =  Kicking(length)."Bullish" within withinbars bars;
def b28 =  LongLeggedDoji(length, extendsearch)."Bullish" within withinbars bars;
def b29 =  Marubozu(length)."Bullish" within withinbars bars;
def b30 =  MeetingLines(length, extendsearch)."Bullish" within withinbars bars;
def b31 =  SeparatingLines(length, extendsearch)."Bullish" within withinbars bars;
def b32 =  SideBySideWhiteLines(length, extendsearch)."Bullish" within withinbars bars;
def b33 =  ThreeLineStrike(length, extendsearch)."Bullish" within withinbars bars;
def b23 =  TriStar(length, extendsearch)."Bullish" within withinbars bars;

def ball_ = b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8 + b9 + b10 + b11 + b12 + b13 + b14 + b15 + 
b16 + b17 + b18 + b19 + b20 + b21 + b22 + b23 + b24 + b25 + b26 + b27 + b28 + b29 + b30 + 
b31 + b32 + b33;

def ball = ball_ * ATR - ATR;

plot ballp = ball;

ballp.SetDefaultColor(Color.GREEN);


plot enter = ball > 0.05;
