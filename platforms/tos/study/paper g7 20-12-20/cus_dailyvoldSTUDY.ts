declare lower;
def vold = close("$VOLD") - open("$VOLD");

def dvold = vold + vold[1];

plot dvold10 = Average(dvold, 10);
plot dvold21 = Average(dvold, 21);
plot dvold50 = Average(dvold, 50);