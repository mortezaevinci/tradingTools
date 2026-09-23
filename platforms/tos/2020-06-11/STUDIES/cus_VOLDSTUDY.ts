declare lower;

input symbol0 = "$VOLD";

plot tickclose =Fundamental(FundamentalType.CLOSE, symbol0);
def tickhigh =Fundamental(FundamentalType.high, symbol0);
def ticklow =Fundamental(FundamentalType.low, symbol0);
