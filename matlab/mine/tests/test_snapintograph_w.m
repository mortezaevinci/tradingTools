close all;

symbol='FB';
date='2020-06-26';

tmfn=['Z:\My files\Project trading\traderdata\data\' symbol '\' symbol ' minute ' date '.mat'];

load(tmfn);

tt=table2timetable(tm);

papfn=['Z:\My files\Project trading\traderdata\data_processed\priceactionprofile\PAPP1 ' symbol '.mat'];

load(papfn);

availablepoint=160; % snap into minute 1 and minute 100, and try predicting the rest


%xxxmor, this is for testing ... in reality ttmin is only available from 1
%to 100, we are not using it any other way anyway
% but it is VIEWED in totality

%available data
tta=tt(1:availablepoint,:);

tms=size(tta,1); %this is the same 100, but for the sake of code transfer

%%

wd=weekday(date)-1;

%% process

ttp.min=min(tta.Open);
ttp.max=max(tta.Open);

ttp.snap1=tta.Open(1);
ttp.snap2=tta.Open(end);

snapextention=numel(PriceActionProfileW{wd}.Open);
snappedpap=movmedian(PriceActionProfileW{wd}.Open,[1 1]);

pap.min=min(snappedpap(1:tms));
pap.max=max(snappedpap(1:tms));

snappedpap=snappedpap*(ttp.max-ttp.min)/(pap.max-pap.min);
pap.snap1=snappedpap(1);
pap.snap2=snappedpap(tms);



ttpl=linspace(ttp.snap1,ttp.snap2+(ttp.snap2-ttp.snap1)*snapextention/tms,snapextention)';
papl=linspace(pap.snap1,pap.snap2+(pap.snap2-pap.snap1)*snapextention/tms,snapextention)';

snappedpap=snappedpap-papl+ttpl;

h=figure('Position',[0 0 1920 1080 ]);

cndl5(tta);
ylim([min(tt.Low)*0.95, max(tt.High)*1.05])
hold on;

tempDate=datetime([date ' 09:30:00'])+minutes((0:389)');
plot(tempDate,snappedpap);