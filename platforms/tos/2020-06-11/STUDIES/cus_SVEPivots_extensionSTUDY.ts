input PilotsAgg = AggregationPeriod.DAY;


def PH = high(period = PilotsAgg)[1];
def PL = low(period = PilotsAgg)[1];
def PC = close(period = PilotsAgg)[1];

def PP = (PH + PL + PC) / 3;

plot pr4 = PP +2*(PH-PL);
plot ps4 = PP - 2*(PH - PL) ;

ps4.AssignValueColor(Color.GREEN);
pr4.AssignValueColor(Color.RED);

