
input negthresh = .4;
input thresh = .4;
input length = 20;
input extendsearch = 3;
input withinbars = 5;
input averageType = AverageType.WILDERS;
input volumelengthlong = 100;

def lasthour = (RegularTradingEnd(GetYYYYMMDD()) - GetTime()) / 60000;

def VolAvg = Average(volume, volumelengthlong);
def volind = volume / VolAvg;


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
def b34 = 0;#WilliamsFractal()."DownFractal";

def ball_ = b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8 + b9 + b10 + b11 + b12 + b13 + b14 + b15 + 
b16 + b17 + b18 + b19 + b20 + b21 + b22 + b23 + b24 + b25 + b26 + b27 + b28 + b29 + b30 + 
b31 + b32 + b33 + b34;

def ball = (ball_ - 1) * volind;


def d1 = 0;#####AdvanceDecline(length,extendsearch) within withinbars bars;
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
def d34 = 0;#williamsFractal()."UpFractal";

def dall_ = d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8 + d9 + d10 + d11 + d12 + d13 + d14 + d15 + 
d16 + d17 + d18 + d19 + d20 + d21 + d22 + d23 + d24 + d25 + d26 + d27 + d28 + d29 + d30 + 
d31 + d32 + d33 + d34;


def dall = (dall_ - 1) * volind;
def bdp = - ball + dall;

def SMA50=SimpleMovingAvg(CLOSE,50,0,no);


def enter = bdp < -thresh and lasthour > 60  and (DailySMA()."DailySMA" < close or SMA50<close);
def exit = bdp > negthresh;

input tradeSize = 1;

AddOrder(OrderType.BUY_TO_OPEN, enter, open[-1], tradeSize, Color.GREEN, Color.GREEN);
AddOrder(OrderType.SELL_TO_CLOSE, exit, open[-1], tradeSize, Color.RED, Color.RED);
