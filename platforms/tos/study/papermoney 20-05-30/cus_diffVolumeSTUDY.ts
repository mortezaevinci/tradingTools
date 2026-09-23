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
# SV.setPaintingStrategy(PaintingStrategy.Histogram);
def newDay=Getday()<>getday()[1] and doDaily;
rec rTSV =CompoundValue(1, if newDay then SV else rTSV[1] + SV, 0);# TotalSum(SV);

rec rfirstvolume=if (newday) then volume else rfirstvolume[1];
plot firstvolume=rfirstvolume;

plot TSV=rTSV;
plot zero = 0;
plot volhigh = firstvolume;# Highest(volume, 480);
plot vollow = -volhigh;


#plot voh2 = HighestAll(volume);
#plot vlo2 = -voh2;

AddLabel(1,"dvol c:"+ TSV / volhigh);