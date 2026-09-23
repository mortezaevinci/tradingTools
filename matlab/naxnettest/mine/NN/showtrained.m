Y=trainingdata{si}.net(X);
y=convertTargetTocondensed(Y);

viewx=mainticks{si}.params.TimeTables.Minute.Open;

figure
subplot(4,1,1);
plot(viewx);
xlim([1 size(viewx,1)]);

subplot(4,1,2);
plot(t);
xlim([1 size(viewx,1)]);

subplot(4,1,3);
plot(y);
xlim([1 size(viewx,1)]);

subplot(4,1,4);
imagesc(Y);
xlim([1 size(viewx,1)]);

drawnow