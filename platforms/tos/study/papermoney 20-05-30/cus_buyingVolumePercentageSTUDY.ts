declare lower;

input averagelength=5;
def O = open;
def H = high;
def C = close;
def L = low;
def V = volume;

def Buying =  if (H == L) then 0 else (SimpleMovingAvg((C - L) / (H - L) * 100-50,averagelength));

def buysellratio = if ((C - L) >5* (H - c)) then 500 else ((C - L) / (H - c) * 100);

plot bsr=SimpleMovingAvg(buysellratio,averagelength);

plot zero = 0;
plot hundred = 100;
plot mhundred = -100;

plot hundred3 = 200;


def newDay=Getday()<>getday()[1];
rec rBuying =CompoundValue(1, if newDay then Buying else rBuying[1] + Buying, 0);#

plot pb=rBuying;