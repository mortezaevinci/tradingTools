plot _data_ =
(
Fundamental(FundamentalType.CLOSE, period = AggregationPeriod.MIN)
+
Fundamental(FundamentalType.OPEN, period = AggregationPeriod.MIN)
+
close)
/ 3        ;