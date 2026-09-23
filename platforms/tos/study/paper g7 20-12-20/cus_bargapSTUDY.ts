declare lower;
#gap-move of last day
def lastdaymove=(close[1]-open[1]);
def gap=open-close[1];

def lostmove=gap-lastdaymove;

plot goodgap=if ((gap>0 and lastdaymove>0 and lostmove>0 and high[1]<open) or (gap<0 and lastdaymove<0 and lostmove<0 and low[1]>open)) then lostmove else 0;


