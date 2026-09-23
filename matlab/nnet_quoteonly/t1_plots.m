%purpose of prediction)
samplesizediff=inputDelays(end);%+predictmanysamples;
range=1:size(X,2);
xx=X(range);
tt=T(range);%T0(range);%this doesn't matter... it may as well be any data with that structure
%try mx instead of T, which is a different column of data
[xs,xis,ais,ts] = preparets(nets,xx,tt);
ys = nets(xs,xis,ais);

xxm=cell2mat(xx);
ysm=cell2mat(ys);
for i=1:size(ysm,1)
figure
hold on;
title('prediction when it is available, predictmanysamples ahead of itme');
 
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
[xs,xis,ais,ts] = preparets(nets,xx,tt);
ys = nets(xs,xis,ais);

xxm=cell2mat(xx);
ysm=cell2mat(ys);
for i=1:size(ysm,1)
figure
hold on;
title('prediction when it happens');

plot(1:numel(xxm(2,:)),xxm(2,:),'g');
plot(1:numel(xxm(4,:)),xxm(4,:),'b');
plot(1:numel(xxm(3,:)),xxm(3,:),'r');
plot((1:numel(ysm(i,:)))+samplesizediff,ysm(i,:),'k--');
end