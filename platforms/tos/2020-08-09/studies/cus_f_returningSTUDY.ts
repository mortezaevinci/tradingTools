input length = 48; #days
input distance=5;

def newday=getday()==getday()[length];

plot lolo = if newday then Lowest(low[5], length) else double.nan;
plot hihi = if newday then Highest(high[5], length) else double.nan;



plot midcrisis = (lolo + hihi )/2;
def mclo = lolo;
def mchi = hihi;


def retraced = if close > mclo and close < mchi then close else Double.NaN;