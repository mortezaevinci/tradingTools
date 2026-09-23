 #
# TD Ameritrade IP Company, Inc. (c) 2008-2020
#

declare lower;

input period0=aggregationperiod.day;

input CorrelationWithSecurity = "SPX";
def close2 = close(CorrelationWithSecurity);

def RS = if close2 == 0 then 0 else close/close2;

def od= close[5];
def odx=close(correlationWithSecurity)[5];
def sr = od/odx; #CompoundValue("historical data" = RS, 
plot percentile=(RS-sr)*100/(sr);

def cc=min(255,max(125+percentile*10,0));
addlabel(1,"RS:"+percentile+"%",createcolor(255-cc,cc,0));
plot zero=0;

#identical to percentile
#def pcpx=(close(CorrelationWithSecurity)-odx)/odx*100;
#plot relPriceUpgrade2=pcp-pcpx;
