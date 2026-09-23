function []=viewNet(titlename,viewx,net,X,T,t)

Y=net(X);
y=convertTargetTocondensed(Y);

figure
tlt=tiledlayout(4,1);

acount=1;
ax{acount}=nexttile(tlt,[1 1]);acount=acount+1;
try
plot(viewx);

ylim([min(viewx),max(viewx)]);
catch
end
hold on

plot((y>0.8).*viewx,'g^','linewidth',3);
plot((y<-0.8).*viewx,'rv','linewidth',3);

title(titlename);
xlim([1 size(viewx,2)]);
hold off
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