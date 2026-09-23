def DownVolume = If(close < close[1], volume, 0);
def upVolume = If(close > close[1], volume, 0);

plot vold=totalsum(upvolume-downvolume);