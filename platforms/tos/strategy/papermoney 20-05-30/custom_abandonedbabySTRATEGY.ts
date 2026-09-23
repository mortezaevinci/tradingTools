input length = 20;
input trendSetup = 3;
input tradeSize=1;

def IsPrevDoji = IsDoji(length)[1];

def Bearish = IsAscending(close, trendSetup)[2] and
    IsLongWhite(length)[2] and
    low[1] > close[2] and
    IsPrevDoji and
    high < low[1] and
    open > close;

def Bullish = IsDescending(close, trendSetup)[2] and
    IsLongBlack(length)[2] and
    high[1] < close[2] and
    IsPrevDoji and
    low > high[1] and
    open < close;

AddOrder(OrderType.BUY_TO_OPEN, Bullish, open[-1], tradeSize, Color.GREEN, Color.GREEN);

AddOrder(OrderType.SELL_TO_CLOSE, Bearish, open[-1], tradeSize, Color.RED, Color.RED);
