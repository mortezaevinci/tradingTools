#
# TD Ameritrade IP Company, Inc. (c) 2015-2020
#

declare lower;

input price = FundamentalType.CLOSE;
input symbol = "SPY";
input multiplier = 1.0;


plot Ratio =totalsum(close/ (multiplier * Fundamental(price, symbol)));

Ratio.DefineColor("Up", Color.UPTICK);
Ratio.DefineColor("Down", Color.DOWNTICK);
Ratio.AssignValueColor(if Ratio >= Ratio[1] then Ratio.Color("Up") else Ratio.Color("Down"));
