#Hint: Bollinger Bands for IV

declare lower;

 input length = 10;

 input NumberofDevs = 2;

 def data = ImpVolatility();
 def up = close > open;

 def down = close < open;

 def offset = NumberofDevs * Stdev(data, length);

#The plots that will be drawn on the chart
 plot IV = data;
 plot MidLine = Average(data, length);

 plot UpperBand = MidLine + offset;
plot LowerBand = MidLine - offset;

 #Changing the color of the chart to make it pop and significant time

 AssignPriceColor(if data > upperBand and down then Color.YELLOW else if data < lowerBand and up then color.BLUE else color.current); 