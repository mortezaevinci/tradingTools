#
# TD Ameritrade IP Company, Inc. (c) 2007-2020
#

declare lower;

input length = 10;
input overBought = -20;
input overSold = -80;
input averageType = AverageType.EXPONENTIAL;

def hh = Highest(high, length);
def ll = Lowest(low, length);
def result = if hh == ll then -100 else (hh - close) / (hh - ll) * (-100);

plot WR = if result > 0 then 0 else result;

WR.SetDefaultColor(GetColor(1));

plot Over_Sold = overSold;
Over_Sold.SetDefaultColor(GetColor(8));

plot Over_Bought = overBought;
Over_Bought.SetDefaultColor(GetColor(8));