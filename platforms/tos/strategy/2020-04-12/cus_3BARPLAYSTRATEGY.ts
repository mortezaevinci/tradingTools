#
def aggregationPeriod = AggregationPeriod.DAY;
def lastDayHighLow = (high(period = aggregationPeriod)[1] - low(period = aggregationPeriod)[1]);

def ibar0 = 4;
def ibar1 = 0;
def ibar2 = 2;
def ibar3 = 1;
def ibar4 = 0;

def bar1_ishigher = 1;#(close[ibar0]-open[ibar1])<0;
def bar1_ishigh = 1;#(close[ibar1] - open[ibar1]) > lastDayHighLow / 40;
def bar1_meaty=AbsValue(close[ibar1]-open[ibar1])>.5* (high[ibar1]-low[ibar1]);
def bar1_notToohigh = 1;#(close[ibar1]-open[ibar1])<lastDayHighLow/4;
def bar1_igniting1 = 1;#(open[ibar1] - low[ibar1]) > (close[ibar1] - open[ibar1]) / 4;
def bar1_igniting2 = 1;#(high[ibar1] - close[ibar1]) < (close[ibar1] - open[ibar1]) / 8;
def bar2_highasbar1 = AbsValue(high[ibar1] - high[ibar2]) < (close[ibar1] - open[ibar1]) / 8;
def bar2_lowis_high = (low[ibar2] - low[ibar1]) > (close[ibar1] - low[ibar1]) / 2;
def bar2_consolidating = (close[ibar2] - open[ibar2]) > -(close[ibar1] - open[ibar1]) / 4;
def bar2_neg = (close[ibar2] - open[ibar2]) < 0;
def bar3_highasbar1 = AbsValue(high[ibar1] - high[ibar2]) < (close[ibar1] - open[ibar1]) / 8;
def bar3_lowis_high = (low[ibar2] - low[ibar1]) > (close[ibar1] - low[ibar1]) / 2;
def bar3_consolidating = (close[ibar2] - open[ibar2]) < (close[ibar1] - open[ibar1]) / 4;
def bar3_pos = (close[ibar2] - open[ibar2]) > 0;
def bar4_expands = high > high[ibar2] and high > high[ibar1] and high > high[ibar3];

def bar1 =bar1_meaty and bar1_ishigher and bar1_ishigh and bar1_notToohigh and bar1_igniting1 and bar1_igniting2;
def bar2 = bar2_highasbar1 and bar2_lowis_high and bar2_consolidating and bar2_neg;
def bar3 = bar3_highasbar1 and bar3_lowis_high and bar3_consolidating and bar3_pos;

def enter = bar1;# and bar2 and bar3;

input tradeSize = 100;

AddOrder(OrderType.BUY_TO_OPEN, enter, open[-1], tradeSize, Color.GREEN, Color.GREEN);

AddOrder(OrderType.SELL_TO_CLOSE, enter, open[-1], tradeSize, Color.GREEN, Color.GREEN);