function n=graphStrategy(gcf,params,calculations,result)

showlimit_=min(params.showlimit,numel(calculations.TimeTables.Minute.Date)-1);
genericrange=(numel(calculations.TimeTables.Minute.Date)-showlimit_):numel(calculations.TimeTables.Minute.Date);

scale_min=min(calculations.TimeTables.Minute.Close(genericrange));
scale_max=max(calculations.TimeTables.Minute.Close(genericrange));
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*params.scalepercent;
scale_max=scale_max+scale_d*params.scalepercent;


gcf=figure(gcf);%('units','normalized','outerposition',[0 0 1 1]); %for fullscreen
%set(gcf,'color','b');
tlt=tiledlayout(10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";

ax1=nexttile([8 10]);
ylim([scale_min ,scale_max])
hold on;

for i=1:numel(calculations.profilelvls)
 plot([calculations.TimeTables.Minute.Date(genericrange(1)), calculations.TimeTables.Minute.Date(end)],[calculations.profilelvls(i),calculations.profilelvls(i)],'y--','linewidth',min(4,calculations.width_plvls(i)));
end
for i=1:numel(calculations.levels.values)
 plot([calculations.TimeTables.Minute.Date(genericrange(1)), calculations.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
end
plot(calculations.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.pbto(genericrange)*1.001,'c^','linewidth',4);
plot(calculations.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.psto(genericrange)*0.999,'cv','linewidth',4);

cndl4(calculations.TimeTables.Minute(genericrange,:));
grid on;
hold on;

text(calculations.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.upc(genericrange)));
text(calculations.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.psto(genericrange)*0.999,num2str(calculations.dnc(genericrange)));
%text(calculations.TimeTables.Minute.Date,calculations.indicators{1}.eval.pbto*1.01,num2str(result.success_bto));
%text(calculations.TimeTables.Minute.Date,calculations.indicators{1}.eval.psto*.99,num2str(result.success_sto));

plot(calculations.TimeTables.Minute.Date(genericrange),calculations.localoptima{1}(genericrange),'k.');
plot(calculations.TimeTables.Minute.Date(genericrange),calculations.localoptima{2}(genericrange),'k.');

hold off;

pvs_=(calculations.upcond | calculations.dncond).*calculations.TimeTables.Minute.Volume;
pvs_(pvs_==0)=NaN;

ax2=nexttile([2 10]);
bar(calculations.TimeTables.Minute.Date(genericrange),calculations.TimeTables.Minute.Volume(genericrange),'g');
grid on;
hold on;
bar(calculations.TimeTables.Minute.Date(genericrange),calculations.sellv(genericrange),'r');
plot(calculations.TimeTables.Minute.Date(genericrange),pvs_(genericrange),'*b');
hold off;

linkaxes([ax1 ax2],'x');
end