

input length = 12;
input num_devs_dn = 2.0;


input price0 = FundamentalType.CLOSE;
input symbol0 = "SPY";


def close0=Fundamental(price0,symbol= symbol0,period=AggregationPeriod.DAY);
def value0 =BollingerBands(close0,0,length,-num_devs_dn,num_devs_dn).LowerBand;
def condition0 = close0 crosses above value0 and high[1] >= value0;

plot value =BollingerBands(close,0,length,-num_devs_dn,num_devs_dn).LowerBand;
plot condition = if ((close crosses above value or (close>value and low<value)) and high[1] >= value) then close else 0;
