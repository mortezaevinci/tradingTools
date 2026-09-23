# Market Maker Move 

input LineOnExpansion = yes;
input show_label = yes;
input label_color = {"magenta", "green", "pink", "cyan", "orange", "red", default "blue", "gray", "violet"};


def PrevClose = close(period = AggregationPeriod.DAY)[1];
def MMM = if IsNaN(GetMarketMakerMove()) 
          then MMM[1] 
          else GetMarketMakerMove();

def bar = if IsNaN(close + MMM) 
             then if LineOnExpansion
                     then bar[1]
                     else Double.NaN
             else BarNumber();
def ThisBar = HighestAll(bar);
def barCount   = if bar == ThisBar 
                 then (close + MMM)
                 else Double.NaN;

plot upper = if ThisBar <= bar
           then HighestAll(barCount)
           else Double.NaN;
upper.SetDefaultColor(Color.BLUE);
upper.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
upper.SetLineWeight(3);


def bar2 = if IsNaN(close - MMM) 
             then if LineOnExpansion
                     then bar[1]
                     else Double.NaN
             else BarNumber();
def ThisBar2 = HighestAll(bar);
def barCount2   = if bar == ThisBar 
                 then (close - MMM)
                 else Double.NaN;

plot lower = if ThisBar2 <= bar2
           then HighestAll(barCount2)
           else Double.NaN;
lower.SetDefaultColor(GetColor(label_color));
lower.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);
lower.SetLineWeight(3);


def StockPrice = close;
def condition = GetMarketMakerMove();
def MMMpercent = condition / StockPrice;
AddLabel(condition >= 0 and show_label, "Market Maker Move =  " + AsDollars(condition) + "  ...  " + AsPercent(MMMpercent), GetColor(label_color));

AddCloud(lower, upper, Color.CYAN, Color.CYAN);

AddChartBubble(bar == ThisBar, close(period = aggregationPeriod.DAY) + GetMarketMakerMove(), "MMM range HIGH: " + round(upper, 2), Color.LIGHT_GRAY, yes);

AddChartBubble(bar == ThisBar2, close(period = aggregationPeriod.DAY) - GetMarketMakerMove(), "MMM range LOW: " + round(lower, 2), Color.LIGHT_GRAY, no);

