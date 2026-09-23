input usale=30;
input osale=70;

input tradeSize=1;


def enter=RSI()."RSI" crosses above usale and low crosses below 
BollingerBands()."LowerBand" within 8 bars;

def exit=RSI()."RSI" is less than RSI()."RSI" from 2 bars ago and RSI
()."RSI" crosses below osale and high crosses above BollingerBands
()."UpperBand" within 8 bars;

addOrder(OrderType.BUY_TO_OPEN, enter, open[-1], tradeSize, Color.Green, Color.Green);

addOrder(OrderType.SELL_TO_CLOSE, exit, open[-1], tradeSize, Color.Red,Color.Red);
