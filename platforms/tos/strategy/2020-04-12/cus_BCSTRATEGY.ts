input length=3;

def candlelow = if (open < close) then open else close;
def candleigh = if (open < close) then close else open;
def buyercontrol =average(totalsum(((candlelow-low)-(high-candleigh))*volume), length);

input thresh = 100;

def enter = buyercontrol > thresh;
def exit = buyercontrol < -thresh;

def tradeSize = 1;
AddOrder(OrderType.BUY_TO_OPEN, enter, open[-1], tradeSize, Color.GREEN, Color.GREEN);
AddOrder(OrderType.SELL_TO_CLOSE, exit, open[-1], tradeSize, Color.RED, Color.RED);