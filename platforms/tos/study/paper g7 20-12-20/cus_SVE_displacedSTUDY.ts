#
# TD Ameritrade IP Company, Inc. (c) 2018-2020
#

input aggregationPeriod = AggregationPeriod.DAY;
input displace=1;

def PH = high(period = aggregationPeriod)[1+displace];
def PL = low(period = aggregationPeriod)[1+displace];
def PC = close(period = aggregationPeriod)[1+displace];

plot R3;
plot R3M;
plot R2;
plot R2M;
plot R1;
plot R1M;
plot HH;
plot PP;
plot LL;
plot S1M;
plot S1;
plot S2M;
plot S2;
plot S3M;
plot S3;

HH = PH;
LL = PL;
PP = (PH + PL + PC) / 3;
R1 = 2 * PP - PL;
R1M = (R1 - PP) / 2 + PP;
R2 = PP + (PH - PL);
R2M = (R2 - R1) / 2 + R1;
R3 = 2 * PP + (PH - 2 * PL);
R3M = (R3 - R2) / 2 + R2;
S1 = 2 * PP - PH;
S1M = (PP - S1) / 2 + S1;
S2 = PP - (PH - PL);
S2M = (S1 - S2) / 2 + S2;
S3 = 2 * PP - (2 * PH - PL);
S3M = (S2 - S3) / 2 + S3;

R3.SetDefaultColor(GetColor(5));
R3M.SetDefaultColor(GetColor(5));
R2.SetDefaultColor(GetColor(5));
R2M.SetDefaultColor(GetColor(5));
R1.SetDefaultColor(GetColor(5));
R1M.SetDefaultColor(GetColor(5));
HH.SetDefaultColor(GetColor(4));
PP.SetDefaultColor(GetColor(0));
LL.SetDefaultColor(GetColor(1));
S1.SetDefaultColor(GetColor(6));
S1M.SetDefaultColor(GetColor(6));
S2.SetDefaultColor(GetColor(6));
S2M.SetDefaultColor(GetColor(6));
S3.SetDefaultColor(GetColor(6));
S3M.SetDefaultColor(GetColor(6));

R3.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
R3M.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
R2.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
R2M.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
R1.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
R1M.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
HH.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
PP.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
LL.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S1.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S1M.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S2.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S2M.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S3.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
S3M.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);

R3M.SetStyle(Curve.SHORT_DASH);
R2M.SetStyle(Curve.SHORT_DASH);
R1M.SetStyle(Curve.SHORT_DASH);
HH.SetStyle(Curve.MEDIUM_DASH);
LL.SetStyle(Curve.MEDIUM_DASH);
S1M.SetStyle(Curve.SHORT_DASH);
S2M.SetStyle(Curve.SHORT_DASH);
S3M.SetStyle(Curve.SHORT_DASH);

R3M.Hide();
R2M.Hide();
R1M.Hide();
HH.Hide();
LL.Hide();
S1M.Hide();
S2M.Hide();
S3M.Hide();