def entryp = EntryPrice();
input tradesize = 1;

plot stc;
stc.setpaintingstrategy(paintingStrategy.ARROW_DOWN);
plot btc;
stc.setpaintingstrategy(paintingStrategy.ARROW_UP);
def level;

def r3 = SVEPivots(AggregationPeriod.DAY)."r3";
def r2 = SVEPivots(AggregationPeriod.DAY)."r2";
def r1 = SVEPivots(AggregationPeriod.DAY)."r1";
def pp = SVEPivots(AggregationPeriod.DAY)."pp";
def s1 = SVEPivots(AggregationPeriod.DAY)."s1";
def s2 = SVEPivots(AggregationPeriod.DAY)."s2";
def s3 = SVEPivots(AggregationPeriod.DAY)."s3";


if (entryp > r3)
then
{
    level = r3 + (r3 - r2) / 2;
    stc = (high > level );
    btc=0;
}
else if (entryp > r2)
{
    level = r2 + (r3 - r2) / 2;
    stc = (high > level );
btc=0;
}
else if (entryp > r1)
{
    level = r1 + (r2 - r1) / 2;
    stc = (high > level);
btc=0;
}
else if (entryp < s3)
then
{
    level = s3 + (s3 - s2) /2;
    btc = (low < level );
stc=0;
}
else if (entryp < s2)
{
    level = s2 + (s3 - s2) / 2;
    btc = (low < level);
stc=0;
}
else if (entryp < s1)
{
    level = s1 + (s2 - s1) / 2;
    btc = (low < level);
stc=0;
}
else if (entryp < pp)
{
    level = s1;
    btc = (low < level);
stc=0;
}
else if (entryp > pp)
{
    level = r1;
    btc = (high> level);
stc=0;
}
else
{
    level = 0;
    stc = 0;
    btc = 0;
}

 
AddOrder(OrderType.SELL_TO_CLOSE, stc, open[-1], tradesize, Color.GREEN, Color.GREEN, "1$T stc@" + open[-1]);
AddOrder(OrderType.BUY_TO_CLOSE, btc, open[-1], tradesize, Color.RED, Color.RED, "1$T btc@" + open[-1]);