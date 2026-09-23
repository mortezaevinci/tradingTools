input l1 = 6;
input l2 = 9;
input l3 = 12;
input tradeSize=1;

plot av1=Average(close, l1);
plot av2=Average(close, l2);
plot av3=Average(close, l3);
def cdiff=close/200;

def enter = (av2 crosses above (av3+cdiff)) or (av1 crosses above (av2+cdiff));
def exit= (av1 crosses below (av2));


def marktestarted = GetTime() < RegularTradingStart(GetYYYYMMDD());
def marketTime = marktestarted ;

AddOrder(OrderType.BUY_TO_OPEN, enter and marketTime, open[-1], tradeSize, Color.GREEN, Color.GREEN,"@"+ open[-1]);
AddOrder(OrderType.SELL_TO_CLOSE, exit and marketTime, open[-1], tradeSize, Color.RED, Color.RED,"@"+ open[-1]);