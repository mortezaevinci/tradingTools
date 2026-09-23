input PilotsAgg = AggregationPeriod.DAY;
input PilotsAgg2 = AggregationPeriod.WEEK;
input PilotsAgg3 = AggregationPeriod.MONTH;

plot PH = high(period = PilotsAgg)[1];
plot PL = low(period = PilotsAgg)[1];
plot PC = close(period = PilotsAgg)[1];

plot PH2 = high(period = PilotsAgg2)[1];
plot PL2 = low(period = PilotsAgg2)[1];
plot PC2 = close(period = PilotsAgg2)[1];

plot PH3 = high(period = PilotsAgg3)[1];
plot PL3 = low(period = PilotsAgg3)[1];
plot PC3 = close(period = PilotsAgg3)[1];