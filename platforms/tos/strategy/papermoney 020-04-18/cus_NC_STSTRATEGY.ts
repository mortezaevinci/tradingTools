input negthresh = 0.04;
input thresh = 0.06;
input length = 5;
input extendsearch = 30;
input withinbars = 4;
input averageType = AverageType.WILDERS;

def lasthour = (RegularTradingEnd(GetYYYYMMDD()) - GetTime()) / 60000;


def ATR = MovingAverage(averageType, TrueRange(high, close, low), length);
def VolAvg = Average(volume, length);

def b1 = 0;#ConcealingBabySwallow(length, extendsearch) within withinbars bars;
def b2 = Hammer(length, extendsearch) within withinbars bars;
def b3 = HighPriceGappingPlay(length, extendsearch) within withinbars bars;
def b4 = HomingPigeon(length, extendsearch) within withinbars bars;
def b5 = InvertedHammer(length, extendsearch) within withinbars bars;
def b6 = MatchingLow(length, extendsearch) within withinbars bars;
def b7 = MatHold(length, extendsearch) within withinbars bars;
def b8 = 0;#MorningDojiStar(length, extendsearch) within withinbars bars;
def b9 = MorningStar(length, extendsearch) within withinbars bars;
def b10 = OneWhiteSoldier(length, extendsearch) within withinbars bars;
def b11 = PiercingLine(length, extendsearch) within withinbars bars;
def b12 = RisingThreeMethods(length, extendsearch) within withinbars bars;
def b13 = StickSandwich(length, extendsearch) within withinbars bars;
def b14 = ThreeInsideUp(length, extendsearch) within withinbars bars;
def b15 = ThreeStarsInTheSouth(length, extendsearch) within withinbars bars;
def b16 = ThreeWhiteSoldiers(length, extendsearch) within withinbars bars;
def b17 = UniqueThreeRiverBottom(length, extendsearch) within withinbars bars;
def b18 = UpsideGapThreeMethods(length, extendsearch) within withinbars bars;
def b19 = UpsideTasukiGap(extendsearch) within withinbars bars;
def b20 = AbandonedBaby(length, extendsearch)."Bullish" within withinbars bars;
def b21 = BeltHold(length, extendsearch)."Bullish" within withinbars bars;
def b22 = Breakaway(length, extendsearch)."Bullish" within withinbars bars;
def b24 = Engulfing(length, extendsearch)."Bullish" within withinbars bars;
def b25 = Harami(length, extendsearch)."Bullish" within withinbars bars;
def b26 = HaramiCross(length, extendsearch)."Bullish" within withinbars bars;
def b27 = Kicking(length)."Bullish" within withinbars bars;
def b28 = LongLeggedDoji(length, extendsearch)."Bullish" within withinbars bars;
def b29 = Marubozu(length)."Bullish" within withinbars bars;
def b30 = MeetingLines(length, extendsearch)."Bullish" within withinbars bars;
def b31 = SeparatingLines(length, extendsearch)."Bullish" within withinbars bars;
def b32 = SideBySideWhiteLines(length, extendsearch)."Bullish" within withinbars bars;
def b33 = ThreeLineStrike(length, extendsearch)."Bullish" within withinbars bars;
def b23 = TriStar(length, extendsearch)."Bullish" within withinbars bars;

def ball_ = b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8 + b9 + b10 + b11 + b12 + b13 + b14 + b15 + 
b16 + b17 + b18 + b19 + b20 + b21 + b22 + b23 + b24 + b25 + b26 + b27 + b28 + b29 + b30 + 
b31 + b32 + b33;

def ball = ball_ * ATR - ATR;

def ballp = ball;

#ballp.SetDefaultColor(Color.GREEN);

def d1 = 0;#AdvanceDecline(length,extendsearch) within withinbars bars;
def d2 = DarkCloudCover(length, extendsearch) within withinbars bars;
def d3 = Deliberation(length, extendsearch) within withinbars bars;
def d4 = DownsideTasukiGap(extendsearch) within withinbars bars;
def d5 = EveningDojiStar(length, extendsearch) within withinbars bars;
def d6 = EveningStar(length, extendsearch) within withinbars bars;
def d7 = FallingThreeMethods(length, extendsearch) within withinbars bars;
def d8 = HangingMan(length, extendsearch) within withinbars bars;
def d9 = IdenticalThreeCrows(length, extendsearch) within withinbars bars;
def d10 = InNeck(length, extendsearch) within withinbars bars;
def d11 = OneBlackCrow(length, extendsearch) within withinbars bars;
def d12 = OnNeck(length, extendsearch) within withinbars bars;
def d13 = ShootingStar(length, extendsearch) within withinbars bars;
def d14 = ThreeBlackCrows(length, extendsearch) within withinbars bars;
def d15 = ThreeInsideDown(length, extendsearch) within withinbars bars;
def d16 = ThreeOutsideDown(length, extendsearch) within withinbars bars;
def d17 = Thrusting(extendsearch) within withinbars bars;
def d18 = TwoCrows(length, extendsearch) within withinbars bars;
def d19 = UpsideGapTwoCrows(length, extendsearch) within withinbars bars;
def d20 = AbandonedBaby(length, extendsearch)."Bearish" within withinbars bars;
def d21 = BeltHold(length, extendsearch)."Bearish" within withinbars bars;
def d22 = Breakaway(length, extendsearch)."Bearish" within withinbars bars;
def d24 = Engulfing(length, extendsearch)."Bearish" within withinbars bars;
def d25 = Harami(length, extendsearch)."Bearish" within withinbars bars;
def d26 = HaramiCross(length, extendsearch)."Bearish" within withinbars bars;
def d27 = Kicking(length)."Bearish" within withinbars bars;
def d28 = LongLeggedDoji(length, extendsearch)."Bearish" within withinbars bars;
def d29 = Marubozu(length)."Bearish" within withinbars bars;
def d30 = MeetingLines(length, extendsearch)."Bearish" within withinbars bars;
def d31 = SeparatingLines(length, extendsearch)."Bearish" within withinbars bars;
def d32 = SideBySideWhiteLines(length, extendsearch)."Bearish" within withinbars bars;
def d33 = ThreeLineStrike(length, extendsearch)."Bearish" within withinbars bars;
def d23 = TriStar(length, extendsearch)."Bearish" within withinbars bars;


def dall_ = d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8 + d9 + d10 + d11 + d12 + d13 + d14 + d15 + 
d16 + d17 + d18 + d19 + d20 + d21 + d22 + d23 + d24 + d25 + d26 + d27 + d28 + d29 + d30 + 
d31 + d32 + d33;


def dall = dall_ * ATR - ATR;
def dallp = dall;


input tradeSize = 1;

def enter = ball > thresh and ball - dall > thresh and lasthour > 60;
def exit = dall > negthresh and dall - ball > negthresh;






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

def ATR2 = MovingAverage(AverageType.HULL, TrueRange(RSIAvg, RSIAvg, RSIAvg), nATR);
def UP = RSIAvg + (AtrMult * ATR2);
def DN = RSIAvg + (-AtrMult * ATR2);

def ST = if RSIAvg < ST[1] then UP else DN;


AddOrder(OrderType.BUY_TO_OPEN, enter and ST < RSIAvg, open[-1], tradeSize, Color.GREEN, Color.GREEN);

AddOrder(OrderType.SELL_TO_CLOSE, exit and ST > RSIAvg, open[-1], tradeSize, Color.RED, Color.RED);
