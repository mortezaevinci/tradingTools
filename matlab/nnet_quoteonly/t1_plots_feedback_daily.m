%purpose of prediction)
samplesizediff=inputDelays(end);%+predictmanysamples;
range=1:size(X,2);
xx=X(range);
tt=T(range);%T0(range);%this doesn't matter... it may as well be any data with that structure
%try mx instead of T, which is a different column of data
[xs,xis,ais,ts] = preparets(nets,xx,{},tt);
ys = nets(xs,xis,ais);

xxm=cell2mat(xx);
ysm=cell2mat(ys);

figure
hold on;
title('prediction when it is available, predictmanysamples ahead of itme');
for i=1:size(ysm,1)

plot(1:numel(xxm(2,:)),xxm(2,:),'g');
plot(1:numel(xxm(4,:)),xxm(4,:),'b');
plot(1:numel(xxm(3,:)),xxm(3,:),'r');
plot((1:numel(ysm(i,:)))+samplesizediff,ysm(i,:),'k--');
end


%purpose of prediction)
samplesizediff=max(inputDelays(end),feedbackDelays(end))+predictmanysamples;
range=1:size(X,2);
xx=X(range);
tt=T(range);%T0(range);%this doesn't matter... it may as well be any data with that structure
%try mx instead of T, which is a different column of data
[xs,xis,ais,ts] = preparets(nets,xx,{},tt);
ys = nets(xs,xis,ais);

xxm=cell2mat(xx);
ysm=cell2mat(ys);
f=figure
hold on;
title('prediction when it happens');

% for i=1:size(ysm,1)
% 
% plot(1:numel(xxm(2,:)),xxm(2,:),'g');
% plot(1:numel(xxm(4,:)),xxm(4,:),'b');
% plot(1:numel(xxm(3,:)),xxm(3,:),'r');
% plot((1:numel(ysm(i,:)))+samplesizediff,ysm(i,:),'k--');
% end
%only in minute because of lazyness... old unmaintained code
 ttd=trainingdata{trainingindex}.mainticks{1}.params.TimeTables.Minute;
 normalref=ttd.Open(1);
 regeny=[NaN(samplesizediff,1);ysm']*normalref;
 
 ax=cndlv(ttd);
 hold(ax{1},'on');
 plot(ax{1},[ttd.Date;ttd.Date(end)+days(1)],regeny,'k--');