declare lower;

def typicalp=(high+low+close)/3;
def tpv=typicalp*volume;

def newday=getDay()<>getday()[1];

rec tpcum=if (newday) then typicalp else tpcum[1]+typicalp;
rec vcum=if (newday) then 0 else vcum[1]+volume;


plot vwapbase=vwap-typicalp;
#plot VWAP=tpcum/vcum;