#
# TD Ameritrade IP Company, Inc. (c) 2018-2020
#

input aggregationPeriod = AggregationPeriod.DAY;
input multiplier1=0.38;
input multiplier2=0.62;
input multiplier3=1;

def PH = high(period = aggregationPeriod)[1];
def PL = low(period = aggregationPeriod)[1];
def PC = close(period = aggregationPeriod)[1];

def ATR = MovingAverage(AverageType.WILDERS, TrueRange(high(period = AggregationPeriod.DAY), close(period = AggregationPeriod.DAY), low(period = AggregationPeriod.DAY)), 14);

plot R3;
plot R2;
plot R1;
plot PP;
plot S1;
plot S2;
plot S3;

PP = (PH + PL + PC)/3;
R1 = PP +multiplier1* ATR;
R2 = PP +multiplier2* ATR;
R3 = PP +multiplier3* ATR ;
S1 = PP -multiplier1* ATR ;
S2 = PP -multiplier2* ATR ;
S3 = PP -multiplier3* ATR;

R3.SetDefaultColor(GetColor(5));
R2.SetDefaultColor(GetColor(5));
R1.SetDefaultColor(GetColor(5));
PP.SetDefaultColor(GetColor(0));
S1.SetDefaultColor(GetColor(6));
S2.SetDefaultColor(GetColor(6));
S3.SetDefaultColor(GetColor(6));

R3.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
R2.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
R1.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
PP.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S1.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S2.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S3.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);