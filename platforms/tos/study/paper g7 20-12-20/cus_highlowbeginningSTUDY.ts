input ORBegin2 = 0930;
input OREnd2 = 1030;

def ORActive2 = if SecondsTillTime(OREnd2) > 0 and SecondsFromTime(ORBegin2) >= 0 then 1 else 0;
rec ORHigh2 = if ORHigh2[1] == 0 or ORActive2[1] == 0 and ORActive2 == 1 then high else if ORActive2 and high > ORHigh2[1] then high else ORHigh2[1];
rec ORLow2 = if ORLow2[1] == 0 or ORActive2[1] == 0 and ORActive2 == 1 then low else if ORActive2 and low < ORLow2[1] then low else ORLow2[1];

# Define all the plots:
plot ORH2 = ORHigh2;
plot ORL2 = ORLow2;

ORL2.HideBubble();
ORH2.HideBubble();
# Formatting:
ORH2.SetDefaultColor(Color.GREEN);
ORH2.SetStyle(Curve.LONG_DASH);
ORH2.SetLineWeight(1);
ORL2.SetDefaultColor(Color.RED);
ORL2.SetStyle(Curve.LONG_DASH);
ORL2.SetLineWeight(1);
