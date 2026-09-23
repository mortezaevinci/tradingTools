#HINT: Richard Donchian was a commodities trader sho started the very first commodites advisory firm in the 1940s.  \n\nDonchian channels can also be used on stocks, but should be limited to symbols with strong trend in one direction. \n.

input entry_length = 20;
input exit_length = 10;
input Trade_Size_Shares_or_Contracts = 1;

plot DownTrend_LowerBand = Lowest(low, entry_length);
DownTrend_LowerBand.SetDefaultColor(color.RED);

plot DownTrend_UpperBand = Highest(high, exit_length);
DownTrend_UpperBand.SetDefaultColor(color.GREEN);

AddOrder(OrderType.SELL_TO_OPEN, close < DownTrend_LowerBand[1], open[-1], Trade_Size_Shares_or_Contracts, Color.ORANGE, Color.ORANGE, "DSE");

AddOrder(OrderType.BUY_TO_CLOSE, close > DownTrend_UpperBand[1], open[-1], Trade_Size_Shares_or_Contracts, Color.ORANGE, Color.ORANGE, "DSX");
