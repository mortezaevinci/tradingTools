input smalength=50;

input checklength=1;

def sma = DailySMA(FundamentalType.CLOSE, AggregationPeriod.DAY, smalength, 0, no);

def h = DailyHighLow(AggregationPeriod.DAY, checklength, 0, no)."DailyHigh";
def l = DailyHighLow(AggregationPeriod.DAY, checklength, 0, no)."DailyLow";

def extra = (h - l) * 10 / 100;

def hh = h + extra;
def ll = l - extra;

plot Data = if ((sma>ll) and (sma<hh)) then sma else double.nan;