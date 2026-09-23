input accelerationFactor = 0.02;
input accelerationLimit = 0.2;
input crossingType = {default Bearish, Bullish};

def sar = ParabolicSAR(accelerationFactor = accelerationFactor, accelerationLimit = accelerationLimit);

plot signalsell = Crosses(sar, close, 1);
plot signalbuy = Crosses(sar, close, 0);

signalsell.setpaintingstrategy(paintingstrategy.boolEAN_ARROW_DOWN);
signalbuy.setpaintingstrategy(paintingstrategy.boolEAN_ARROW_UP);
signalsell.assignvaluecolor(color.gray);
signalbuy.assignvaluecolor(color.gray);

AddOrder(OrderType.SELL_TO_CLOSE, signalsell, tickColor = GetColor(6), arrowColor = GetColor(6), name = "PSARLX");
AddOrder(OrderType.BUY_TO_CLOSE, signalbuy, tickColor = GetColor(5), arrowColor = GetColor(5), name = "PSARSX");