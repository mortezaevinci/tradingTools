def newday=getday()<>getday()[1];
rec rgap=if (newday) then open(period= AggregationPeriod.DAY)-close(period= AggregationPeriod.DAY)[1] else rgap[1];
def gap=rgap;
addlabel(1,"Gap:"+gap);