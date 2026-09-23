declare lower;

input usale=30;
input osale=70;

def enter=RSI()."RSI" crosses above usale and low crosses below 
BollingerBands()."LowerBand" within 8 bars;

def exit=RSI()."RSI" is less than RSI()."RSI" from 2 bars ago and RSI
()."RSI" crosses below osale and high crosses above BollingerBands
()."UpperBand" within 8 bars;

plot enterp=enter;
plot exitp=exit;

enterp.SetPaintingStrategy(PaintingStrategy.Line);
exitp.SetPaintingStrategy(PaintingStrategy.Line);

enterp.SetDefaultColor(Color.UPTICK);
exitp.SetDefaultColor(Color.DOWNTICK);
