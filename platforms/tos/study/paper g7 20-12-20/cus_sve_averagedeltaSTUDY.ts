#
# TD Ameritrade IP Company, Inc. (c) 2018-2020
#

input aggregationPeriod = AggregationPeriod.DAY;
input length=14;

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

PP = (PH + PL + PC) / 3;
R1 = PP+MovingAverage(AverageType.WILDERS, PP - PL,length);
R2 = PP+MovingAverage(AverageType.WILDERS, PH - PL,length);
R3 = PP+MovingAverage(AverageType.WILDERS, PP + (PH - 2 * PL),length);
S1 = PP+MovingAverage(AverageType.WILDERS, PP - PH,length);
S2 = PP-MovingAverage(AverageType.WILDERS, (PH - PL),length);
S3 = PP+MovingAverage(AverageType.WILDERS, PP - (2 * PH - PL),length);


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