symbol='AAPL';
date='2020-07-10';
basedir='Z:\My files\Project trading\traderdata\data\';

filename=[basedir symbol '\' symbol ' minute ' date '.mat'];

load(filename);

cndl5(tm);
ylim([min(tm.Low) max(tm.High)]);
figure
plot(tm.Close)
ylim([min(tm.Low) max(tm.High)]);
dclose=tm.Close-381.5;%tm.Open(1);

%1 being time difference
phi=atan(390*dclose./(1:numel(dclose))');

figure
plot((phi))