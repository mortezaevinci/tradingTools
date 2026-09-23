#
# TD Ameritrade IP Company, Inc. (c) 2007-2020
#

input length = 12;
input num_devs_dn = 2.0;
input bollinger_price = close;
input lower_band_price = close;

def bblow = Average(bollinger_price, length) - num_devs_dn * StDev(bollinger_price, length);
def bbhigh = Average(bollinger_price, length) + num_devs_dn * StDev(bollinger_price, length);
def signalup = lower_band_price crosses above bblow and high[-1] >= bblow;
def signaldn = lower_band_price crosses below bbhigh and low[-1] <= bbhigh;


AddOrder(OrderType.BUY_TO_CLOSE, signalup, open[0], 1, Color.RED, Color.RED,"BB_SX");
AddOrder(OrderType.SELL_TO_CLOSE, signaldn, open[0], 1, Color.RED, Color.RED,"BB_LX");
AddOrder(OrderType.BUY_TO_OPEN, signalup, open[-1], 1, Color.GREEN, Color.GREEN,"BB_LE");
AddOrder(OrderType.SELL_TO_OPEN, signaldn, open[-1], 1, Color.GREEN, Color.GREEN,"BB_SE");
