close all

profilerlength=[9 20];

run('config\looperparams_realtime_t10_ID3');

for si=2%1:numel(looperEngine.contracts)
    try
symbol=looperEngine.contracts{si}.FileSymbol;

date='today';
basedir='Z:\My files\Project trading\traderdata\data\';

filename=[basedir symbol '\' symbol ' minute ' date '.mat'];

load(filename);

% will need to be replaced with ATR

figure
cndl5(tm);
ylim([min(tm.Low) max(tm.High)]);
hold on;

calculations.atr=max(tm.High)-min(tm.Low);
for pli=1:numel(profilerlength)
pl=profilerlength(pli);
calculations.localOptimaProfile{pli}=localOptimaProfiler(pl,tm,1);
end

pp=findw(tm,calculations);

for pli=1:numel(profilerlength)
plot(pp{pli}.gx,pp{pli}.gy,'g');
plot(pp{pli}.rx,pp{pli}.ry,'r');
 
 plot(tm.Date,localOptimaProfile.localoptima{1},'v');
 plot(tm.Date,localOptimaProfile.localoptima{2},'^');

end

     catch exception
         disp(exception.message);
     end
end