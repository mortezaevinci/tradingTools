declare lower;

input symbol0 = "$TICK";

def tickclose =Fundamental(FundamentalType.CLOSE, symbol0);
def tickhigh =Fundamental(FundamentalType.high, symbol0);
def ticklow =Fundamental(FundamentalType.low, symbol0);

input length = 5;

plot condtionedClose = if (tickclose > 0) then tickhigh else ticklow;

def marktestarted = (GetTime() - RegularTradingStart(GetYYYYMMDD())) / 1000 / 60; #ignore first 4 minutes

#def movinglength=min(marktestarted,length);

plot CCMA;


if (marktestarted<length) {
ccma=condtionedClose;
} else {
 ccma= Average(condtionedClose, length);
}

plot zero=0;
plot overbought=1000;
plot oversold=-1000;
