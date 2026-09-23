#
# TD Ameritrade IP Company, Inc. (c) 2009-2020
#

declare lower;

input length = 10;
input correlationWithSecurity = "SPX";

plot Correlation = correlation(close, close(correlationWithSecurity), length);
Correlation.SetDefaultColor(GetColor(5));

plot zero=0;