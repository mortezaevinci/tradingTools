function []=viewNet(titlename,viewx,trainingdata,X,T,t)

Y=trainingdata.net(X);
y=convertTargetTocondensed(Y);

figure
tlt=tiledlayout(4,1);

acount=1;
ax{acount}=nexttile(tlt,[1 1]);acount=acount+1;
try
plot(viewx);
catch
end
title(titlename);
xlim([1 size(viewx,2)]);

ax{acount}=nexttile(tlt,[1 1]);acount=acount+1;
plot(t);

ax{acount}=nexttile(tlt,[1 1]);acount=acount+1;
plot(y);

ax{acount}=nexttile(tlt,[1 1]);acount=acount+1;
imagesc(Y);
set(gca,'YDir','normal')

linkaxes([ax{1} ax{2} ax{3} ax{4}],'x');

drawnow
end