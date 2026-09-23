#HINT: This study color codes volume by amount of volume on up-tick versus amount of volume on down-tick

declare lower;
input doDaily=1;
input averagelength = 1;
def O = open;
def H = high;
def C = close;
def L = low;
def V = volume;
def diffvol =  if (H==l) then 0 else (SimpleMovingAvg( V * (C * 2 - L - H) / (H - L),averagelength));

# Selling Volume
def SV = diffvol; 


input length=10;
def domPSV=highest(SV,length);
def domNSV=lowest(SV,length);

plot domSV=domPSV+domNSV;
domSV.setPaintingStrategy(PaintingStrategy.Histogram);
plot zero = 0;
