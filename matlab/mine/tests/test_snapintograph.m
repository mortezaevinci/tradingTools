close all;

symbol='fb';
date='2020-07-02';

tmfn=['Z:\My files\Project trading\traderdata\data\' symbol '\' symbol ' minute ' date '.mat'];

load(tmfn);

tt=table2timetable(tm);

papfn=['Z:\My files\Project trading\traderdata\data_processed\priceactionprofile\PAPP1 ' symbol '.mat'];

load(papfn);

availablepoint=250; % snap into minute 1 and minute 100, and try predicting the rest


%xxxmor, this is for testing ... in reality ttmin is only available from 1
%to 100, we are not using it any other way anyway
% but it is VIEWED in totality

%available data
tta=tt(1:availablepoint,:);

 %this is the same 100, but for the sake of code transfer

% %% process
% tms=size(tta,1);
% ttp.min=min(tta.Open);
% ttp.max=max(tta.Open);
% 
% ttp.snap1=tta.Open(1);
% ttp.snap2=tta.Open(end);
% 
% snappedpap=movmedian(PriceActionProfile.Open,[1 1]);
% 
% pap.min=min(snappedpap(1:tms));
% pap.max=max(snappedpap(1:tms));
% 
% snappedpap=snappedpap*(ttp.max-ttp.min)/(pap.max-pap.min);
% pap.snap1=snappedpap(1);
% pap.snap2=snappedpap(tms);
% 
% snapextention=numel(PriceActionProfile.Open);
% 
% ttpl=linspace(ttp.snap1,ttp.snap2+(ttp.snap2-ttp.snap1)*snapextention/(tms+snapextention),snapextention)';
% papl=linspace(pap.snap1,pap.snap2+(pap.snap2-pap.snap1)*snapextention/(tms+snapextention),snapextention)';
% 
% snappedpap=snappedpap-papl+ttpl;

SnappedPAP=snappap(tta,PriceActionProfile);

h=figure('Position',[0 0 1800 800 ]);

cndl5(tt);
ylim([min(tt.Low)*0.95, max(tt.High)*1.05])
hold on;

plot([tta.Date(end) tta.Date(end)],[tta.Close(end)*2 0]);

tempDate=datetime([date ' 09:30:00'])+minutes((0:389)');
plot(tempDate,SnappedPAP);

% 
% h=figure('Position',[0 0 1800 800 ]);
% 
% plot(tt.Date,tt.Open);
% ylim([min(tt.Low)*0.95, max(tt.High)*1.05])
% hold on;
% 
% tempDate=datetime([date ' 09:30:00'])+minutes((0:389)');
% plot(tempDate,SnappedPAP);
% 
% 
% h=figure('Position',[0 0 1800 800 ]);
% plot(tt.Date,tt.Open-SnappedPAP);
% ylim([min(tt.Low)*0.95, max(tt.High)*1.05])
