#
# TD Ameritrade IP Company, Inc. (c) 2013-2020
#

input priceH = high;
input priceL = low;
input priceC = close;
input kPeriod = 10;
input slowing_period = 3;
input over_bought = 80;
input over_sold = 20;
input averageType = AverageType.SIMPLE;

def fullK = reference StochasticFull("k period" = kPeriod, "price h" = priceH, "price l" = priceL, "price c" = priceC, "slowing period" = slowing_period, "average type" = averageType).FullK;

AddOrder(OrderType.sell_to_CLOSE, fullK crosses above over_sold, tickColor = GetColor(8), arrowColor = GetColor(8), name = "SLE");
AddOrder(OrderType.buy_to_close, fullK crosses below over_bought, tickColor = GetColor(6), arrowColor = GetColor(6), name = "StochasticSE");