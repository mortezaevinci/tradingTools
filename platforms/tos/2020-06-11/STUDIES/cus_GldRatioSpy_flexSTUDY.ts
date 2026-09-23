#
# TD Ameritrade IP Company, Inc. (c) 2015-2020
#

input price0 = FundamentalType.CLOSE;
input symbol0 = "SPY";


def symboldayclose = Fundamental(fundamentaltype = FundamentalType.OPEN, symbol = symbol0);
def multiplier = 1 / symboldayclose;
plot Ratio =if (GetSymbol()=="GLD") then (close)/ (multiplier * Fundamental(price0, symbol0)) else double.NaN;

Ratio.DefineColor("Up", Color.UPTICK);
Ratio.DefineColor("Down", Color.DOWNTICK);
Ratio.AssignValueColor(if Ratio >= Ratio[1] then Ratio.Color("Up") else Ratio.Color("Down"));