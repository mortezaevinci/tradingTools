def DownVolume = If(close < close[1], volume, 0);
def upVolume = If(close > close[1], volume, 0);

def marktestartedbars1m = GetTime() - RegularTradingStart(GetYYYYMMDD()) / 60000;


def vold = TotalSum(upVolume - DownVolume);
def dayopen = open(period = AggregationPeriod.DAY);

plot rvold = vold  / dayopen * close;