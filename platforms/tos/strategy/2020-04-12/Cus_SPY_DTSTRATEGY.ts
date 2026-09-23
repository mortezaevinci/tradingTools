# Original name: Big_Hand_Arrows_On_Study_w_Agg

# Script by Waylock

# AlphaInvestor - 05/12/2017 - force to weekly aggregation

# Modified by BenTen to work on lower timeframe. Alerts added.

declare lower;

input agg = AggregationPeriod.FIFTEEN_MIN;

input fastLength = 19;

input slowLength = 39;

def c = close(period = agg);

plot Value = ExpAverage(c, fastLength) - ExpAverage(c, slowLength);

def Value_color = if Value > 0 then yes else no;

Value.DefineColor( "ValueUp", Color.GREEN );

Value.DefineColor( "ValueDn", Color.RED );

Value.AssignValueColor( if Value_color then Value.Color( "ValueUp" ) else Value.Color( "ValueDn" ) );

plot ZeroLine = 0;

Value.SetDefaultColor(Color.CYAN);

ZeroLine.SetDefaultColor(Color.YELLOW);

ZeroLine.HideTitle();

ZeroLine.HideBubble();

def xUndr = Value[1] < 0 and Value > 0;

def xOver = Value[1] > 0 and Value < 0;

plot ArrowUp = if xUndr then xOver else Double.NaN;

ArrowUp.SetPaintingStrategy(PaintingStrategy.ARROW_UP);

ArrowUp.SetDefaultColor(Color.YELLOW);

ArrowUp.SetLineWeight(5);

ArrowUp.HideTitle();

ArrowUp.HideBubble();

plot ArrowDn = if xOver then xUndr else Double.NaN;

ArrowDn.SetPaintingStrategy(PaintingStrategy.ARROW_DOWN);

ArrowDn.SetDefaultColor(Color.YELLOW);

ArrowDn.SetLineWeight(5);

ArrowDn.HideTitle();

ArrowDn.HideBubble();

def data = Value;

# Alerts
Alert(ArrowUp, " ", Alert.Bar, Sound.Chimes);
Alert(ArrowDn, " ", Alert.Bar, Sound.Bell);

# End Study