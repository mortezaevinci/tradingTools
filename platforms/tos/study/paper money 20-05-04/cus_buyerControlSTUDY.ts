
declare lower;

def candlelow = if (open < close) then open else close;

def candleigh = if (open < close) then close else open;

plot buyercontrol = (((candlelow - low) - (high - candleigh))  * volume);

buyercontrol.AssignValueColor(if (buyercontrol > 0) then Color.GREEN else Color.RED);
