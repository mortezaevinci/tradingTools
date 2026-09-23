%purpose of prediction)
%samplesizediff=inputDelays(end);%+predictmanysamples;
range=1:size(X,2);
xx=X;

Tall=convertTargetTocondensed(T);
tt=Tall;
yy = net(xx);



figure
subplot(3,1,1);

plot(viewx);
xlim([1 size(viewx,1)]);
subplot(3,1,2);

plot(tt);
xlim([1 size(viewx,1)]);
subplot(3,1,3);

%plot(convertTargetTocondensed(yy));
imagesc(yy);

