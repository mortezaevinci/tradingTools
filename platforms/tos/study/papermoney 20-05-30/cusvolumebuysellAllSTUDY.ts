#HINT: This study color codes volume by amount of volume on up-tick versus amount of volume on down-tick

declare lower;

def O = open;
def H = high;
def C = close;
def L = low; 
def V = volume;
def Buying = V*(C-L+H-O)/2/(H-L);
def Selling = V*(H-C+O-L)/2/(H-L);

# Selling Volumea
 Plot SV = selling; 
 SV.setPaintingStrategy(PaintingStrategy.Histogram);
 SV.SetDefaultColor(Color.Red);
 SV.HideTitle();
 SV.HideBubble();
 SV.SetLineWeight(5);

# Buying Volume
# Plot BV = Buying;
# Note that Selling + Buying Volume = Volume.
 Plot BV =  volume; 
 BV.setPaintingStrategy(PaintingStrategy.Histogram);
 BV.SetDefaultColor(Color.Dark_Green);
 BV.HideTitle();
 BV.HideBubble();
 BV.SetLineWeight(5);