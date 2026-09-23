input length = 48; #days


def lolo = Lowest(low[1], length);
def hihi = Highest(high[1], length);


def PC = close[1];


plot midcrisis = (lolo + hihi ) / 2;
def mclo = lolo;
def mchi = hihi;


def retraced = if close > mclo and close < mchi then close else Double.NaN;