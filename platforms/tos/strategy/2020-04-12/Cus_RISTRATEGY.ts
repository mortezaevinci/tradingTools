#
# TD Ameritrade IP Company, Inc. (c) 2015-2020
#

input price0 = FundamentalType.CLOSE;
input symbol0 = "SPY";


def symboldayclose = Fundamental(fundamentaltype = price0, symbol = symbol0, period = AggregationPeriod.DAY);
def multiplier = 1 / symboldayclose;
def Ratio = 100 * (close - (close) / (multiplier * Fundamental(price0, symbol0))) / close;


input tradeSize = 1;
input maxDivergence = 2.5;
def exit = Ratio > -maxDivergence / 5;
def enter = Ratio < -maxDivergence;

def entershort=Ratio>maxDivergence;
def exitshort=Ratio<maxdivergence/5;

AddOrder(OrderType.BUY_TO_OPEN, enter, open[-1], tradeSize, Color.GREEN, Color.GREEN);

AddOrder(OrderType.SELL_TO_CLOSE, exit, open[-1], tradeSize, Color.RED, Color.RED);


AddOrder(OrderType.BUY_TO_CLOSE, exitshort, open[-1], tradeSize, Color.GREEN, Color.GREEN);

AddOrder(OrderType.SELL_TO_OpeN, entershort, open[-1], tradeSize, Color.RED, Color.RED);