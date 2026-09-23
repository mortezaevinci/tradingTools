
input averagelength=15;
input thresh=0.1;
def O = open;
def H = high;
def C = close;
def L = low;
def V = volume;

def buysellratio = if ((C - L) >5* (H - c)) then 5 else ((C - L) / (H - c) );

plot bsr=SimpleMovingAvg(buysellratio,averagelength);

input comp=2;

def upsignal=bsr>comp+thresh and bsr[1]<comp+thresh;
def dnsignal=bsr<comp-thresh and bsr[1]>comp-thresh;

plot pup=upsignal;#if (upsignal) then close else double.nan;
pup.setpaintingstrategy(paintingStrategy.booLEAN_ARROW_UP);

plot pdn= dnsignal;#if (dnsignal) then close else double.nan;
pdn.setpaintingstrategy(paintingStrategy.boolean_ARROW_DOWN);
