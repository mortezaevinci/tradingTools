input length = 48; #days
input thresh = 10;#percent
def lolo = Lowest(low[1], length);
def hihi = Highest(high[1], length);

plot midcrisis = lolo + (-lolo + hihi) / 2;
def mclo = midcrisis * (100 - thresh) / 100;
def mchi = midcrisis * (100 + thresh) / 100;



def retraced = if close > mclo and close < mchi then close else Double.NaN;
