#
# TD Ameritrade IP Company, Inc. (c) 2018-2020
#

input length = 9;
input factor = 0.75;
input volRatio = 1.0;
input volAvgLength = 9;
input volDelay = 9;
input mode = {default Range, ATR};

def range = reference AccumulationDistribution(length = length, factor = factor, mode = mode);
def consolidation = range < factor * range[length];
def top;
def bot;
if (consolidation) {
    top = Highest(high, length);
    bot = Lowest(low, length);
} else {
    top = top[1];
    bot = bot[1];
}
def avgVolume = Average(volume, volAvgLength);

def cond1=close > top and
    bot > bot[12] and
    avgVolume[volDelay] > volRatio * avgVolume[volAvgLength + volDelay];
AddOrder(OrderType.buy_to_close,
    cond1,
    tickcolor = GetColor(4), arrowcolor = GetColor(4), name = "SL ADLE"
   );
AddOrder(OrderType.sell_TO_CLOSE, close < bot, tickcolor = GetColor(1), arrowcolor = GetColor(1), name = "SL ADLX");
