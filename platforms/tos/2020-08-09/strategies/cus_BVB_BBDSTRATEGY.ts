#
# TD Ameritrade IP Company, Inc. (c) 2016-2020
#

input secondarySymbol = "/CL";
input length = 20;

def secClose = close(secondarySymbol);
def divergence = reference BBDivergence(length = length, "secondary symbol" = secondarySymbol);
def macd = reference MACD("fast length" = 12, "slow length" = 26);
def stochastic = reference StochasticFull("k period" = 30, "slowing period" = 3);
def roc = reference RateOfChange(price = secClose, length = 3);


AddOrder(OrderType.SELL_TO_CLOSE,
    (macd crosses below ExpAverage(macd, 9) and stochastic > 85) or
    (Lowest(divergence, 3) < -20 and roc < -3) or
    (close < Lowest(low, 15)[1] and Correlation(close, secClose, 60) < -0.4),
    tickcolor = GetColor(4), arrowcolor = GetColor(4), name = "BBDLX");

AddOrder(OrderType.BUY_TO_CLOSE,
    (macd crosses above ExpAverage(macd, 9) and stochastic < 25 and secClose >= 1.04 * Lowest(secClose, 4)) or
    (Highest(divergence, 3) > 20 and roc > 4.5) or
    (close > Highest(high, 15)[1] and Correlation(close, secClose, 60) < -0.4),
    tickcolor = GetColor(6), arrowcolor = GetColor(6), name = "BBDSX");