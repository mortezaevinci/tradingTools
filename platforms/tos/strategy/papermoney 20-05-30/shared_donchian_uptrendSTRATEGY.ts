#HINT: Richard Donchian was a commodities trader sho started the very first commodites advisory firm in the 1940s.  \n\nDonchian channels can also be used on stocks, but should be limited to symbols with strong trend in one direction. \n.

input entry_length = 20;
input exit_length = 10;
input Trade_Size_Shares_or_Contracts = 1;

plot Uptrend_UpperBand = Highest(high, entry_length);
Uptrend_UpperBand.SetDefaultColor(color.GREEN);

plot Uptrend_LowerBand = Lowest(low, exit_length);
Uptrend_LowerBand.SetDefaultColor(color.RED);


AddOrder(OrderType.BUY_TO_OPEN, close > Uptrend_UpperBand[1], open[-1], Trade_Size_Shares_or_Contracts, Color.ORANGE, Color.ORANGE, "DLE");

AddOrder(OrderType.SELL_TO_CLOSE, close < Uptrend_LowerBand[1], open[-1], Trade_Size_Shares_or_Contracts, Color.ORANGE, Color.ORANGE, "DX");

