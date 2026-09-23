load('Z:\My files\Project trading\traderdata\data_other\IB\GOOG\GOOG tickbidask -BID_ASK 2022-03-16.mat');

tba = tickslast;

balance = tba.PriceBid .* double(tba.SizeBid) - tba.PriceAsk .* double(tba.SizeAsk);
midpoint = (tba.PriceBid .* double(tba.SizeBid) + tba.PriceAsk .* double(tba.SizeAsk))./(double(tba.SizeBid) + double(tba.SizeAsk));

fs=5000;
[b,a] = butter(8,20/(fs/2));

balancef = filtfilt(b,a,balance);


tlt=tiledlayout(gcf,2,1);
tlt.Padding = "none";
tlt.TileSpacing = "none";
ax{1}=nexttile(tlt,[1 1]);
plot(tba.Date,balancef);

ax{2}=nexttile(tlt,[1 1]);
plot(tba.Date,tba.PriceBid,'b');
hold on;
plot(tba.Date,tba.PriceAsk,'r');
plot(tba.Date,midpoint,'y');
linkaxes([ax{1} ax{2}],'x');
