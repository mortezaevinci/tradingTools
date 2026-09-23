

load('Z:\My files\Project trading\traderdata\data_other\IB\GOOG\GOOG tickslast 2022-06-10.mat');
load('Z:\My files\Project trading\traderdata\data_other\IB\GOOG\GOOG minute 2022-06-10.mat');

vp = cumsum(double(tickslast.Size));
vwap = cumsum(double(tickslast.Size).*tickslast.Price)./vp;

vvar = cumsum(double(tickslast.Size).*(tickslast.Price - vwap).^2);

voff = (vvar./vp).^0.5;

b = 1.5;

tb1 = vwap + b*voff;
bb1 = vwap - b*voff;

ff = cndlv(tmfull);
axes(ff{1});
hold on;
plot(tickslast.Date,vwap);

plot(tickslast.Date,tb1);
plot(tickslast.Date,bb1);
