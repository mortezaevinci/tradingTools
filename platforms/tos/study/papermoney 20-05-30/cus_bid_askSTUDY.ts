declare lower;

def bid = close(pricetype=priceType.bid);
def ask = close(pricetype=priceType.ask);

def vol=volume;
#vol.setpaintingstrategy(paintingstrategy.histogram);
#vol.assignvaluecolor(if (close==bid) then color.red else ( if (close==ask) then color.green else color.white));

def diff=ask-bid;
def cntr=(ask+bid)/2;


def marktestarted = GetTime()  > RegularTradingStart(GetYYYYMMDD()); #ignore first 4 minutes
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;

def incontrol;
if (diff!=0 and marketTime)
{
incontrol=(close-cntr)/diff*volume;
}
else
{
incontrol=0;
}
plot incontrolsum=totalsum(incontrol);