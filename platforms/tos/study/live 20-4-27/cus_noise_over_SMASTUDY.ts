declare lower;

input SMAlength=50;

plot noise =close-SimpleMovingAvg(fundamentaltype.close,50,0,no);
