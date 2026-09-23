declare lower;

input aveLength=21;

def ave=movingaverage(averagetype.simple,close,aveLength);
def aveMARKET=movingaverage(averagetype.simple,close("SPY"),aveLength);

plot betarate=log(close/ave*Beta(aveLength,1,"SPX")*Beta(aveLength,1,"SPX")/(close("SPY")/aveMARKET));
