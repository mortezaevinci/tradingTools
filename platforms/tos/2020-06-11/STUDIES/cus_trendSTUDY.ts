declare lower;

def length = 9;
def sma = SimpleMovingAvg(close, length)."sma";
plot dsma = (sma - sma[length]) / length;
plot asma= (dsma-dsma[length])/length;
plot iasma = TotalSum(asma);

def sma5 = SimpleMovingAvg(close, 5)."SMA";
plot bvbindicator=(sma5-sma5[5])/close*100;

plot zero = 0;