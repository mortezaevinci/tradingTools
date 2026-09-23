input longLength = 25;
input shortLength = 13;
input signalLength = 8;
input averageType = AverageType.EXPONENTIAL;


input length = 13;
input overBought = -20;
input overSold = -80;

def dfindend = if (close[-2]) then 1 else 2;
def dfindend2 = 3;
def isatend ;
if (dfindend2 > dfindend)
then
{
    isatend = 0;
}
else {
    isatend = 1;
}



def hh = Highest(high, length);
def ll = Lowest(low, length);
def result = if hh == ll then -100 else (hh - close) / (hh - ll) * (-100);

plot WR = if result > 0 then 0 else result;


def diff = close - close[1];
def doubleSmoothedAbsDiff = MovingAverage(averageType, MovingAverage(averageType, AbsValue(diff), longLength), shortLength);

def TSI;
def Signal;

TSI = if doubleSmoothedAbsDiff == 0 then 0
      else 100 * (MovingAverage(averageType, MovingAverage(averageType, diff, longLength), shortLength)) / doubleSmoothedAbsDiff;
Signal = MovingAverage(averageType, TSI, signalLength);


def marktestarted = GetTime() > RegularTradingStart(GetYYYYMMDD());
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;

def LE = TSI crosses above Signal and (WR < overBought within 2 bars);
def SE = TSI crosses below Signal and (WR > overSold within 2 bars);

plot pLE=LE;
plot pSE=SE;
pLE.AssignValueColor(Color.GREEN);
pLE.SetLineWeight(2);
pLE.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);

pSE.AssignValueColor(Color.RED);
pSE.SetLineWeight(2);
pSE.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);

Alert(SE and isatend, "short " + GetSymbol(), Alert.ONCE, Sound.Ding);
Alert(LE and isatend, "long " + GetSymbol(), Alert.ONCE, Sound.Ding);