#
declare lower;
def aggregationPeriod = AggregationPeriod.DAY;
def lastDayHighLow = AbsValue(high(period = aggregationPeriod)[1] - low(period = aggregationPeriod)[1]);

def ibar0 = 3;
def ibar1 = 2;
def ibar2 = 1;
def ibar3 = 0;
def ibar4 = 0;

def bar1_ishigher =  (high[ibar0] - close[ibar1]) < 0;
def bar1_ishigh =  (close[ibar1] - open[ibar1]) > lastDayHighLow / 80;
def bar1_meaty =  AbsValue(close[ibar1] - open[ibar1]) > .5 * (high[ibar1] - low[ibar1]);
def bar1_notToohigh =1;# (close[ibar1] - open[ibar1]) < lastDayHighLow / 4;
def bar1_igniting1 = (open[ibar1] - low[ibar1]) > (high[ibar1] - close[ibar1]);
def bar1_igniting2 = (high[ibar1] - close[ibar1]) < (close[ibar1] - open[ibar1]) / 8;
def bar2_highasbar1 = AbsValue(high[ibar1] - high[ibar2]) < (close[ibar1] - open[ibar1]) / 8;
def bar2_lowis_high = (low[ibar2] - low[ibar1]) > (close[ibar1] - low[ibar1]) / 2;
def bar2_consolidating = (high[ibar2] - low[ibar2]) < (high[ibar1] - low[ibar1]) /2;
def bar2_neg = 1;#(close[ibar2] - open[ibar2]) < 0;

#def bar3_highasbar1 = AbsValue(high[ibar1] - high[ibar3]) < (close[ibar1] - open[ibar1]) / 8;
#def bar3_lowis_high = (low[ibar3] - low[ibar1]) < (close[ibar1] - low[ibar1]) / 2;
#def bar3_consolidating = (high[ibar3] - low[ibar3]) < (high[ibar1] - open[ibar1]) / 3;
#def bar3_pos = (close[ibar3] - open[ibar3]) > 0;
def bar3_expands = close > high[ibar2] and close > high[ibar1];
def bar3_pos=close>open;
def bar3_meaty =  AbsValue(close[ibar3] - open[ibar3]) > .5 * (high[ibar3] - low[ibar1]);
def bar3_notdeath = (high[ibar3] - close[ibar3]) < (close[ibar3] - open[ibar3]) / 8;

def bar1 = bar1_meaty and bar1_ishigher and bar1_ishigh and bar1_notToohigh and bar1_igniting1 and bar1_igniting2;
def bar2 = bar2_highasbar1 and bar2_lowis_high and bar2_consolidating and bar2_neg;
#plot bar3 = bar3_highasbar1 and bar3_lowis_high and bar3_consolidating and bar3_pos;
def bar3 = bar3_expands and bar3_pos and bar3_meaty and bar3_notdeath;


plot enter = ( bar1 +2* bar2 +4* bar3);