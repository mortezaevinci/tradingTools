function n=graphStrategy(panel,params,calculations,result)
if (isvalid(panel))
showlimit_=min(params.showlimit,numel(params.TimeTables.Minute.Date)-1);
genericrange=(numel(params.TimeTables.Minute.Date)-showlimit_):numel(params.TimeTables.Minute.Date);

scale_min=min(params.TimeTables.Minute.Low(genericrange));
scale_max=max(params.TimeTables.Minute.High(genericrange));
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*params.scalepercent;
scale_max=scale_max+scale_d*params.scalepercent;

%figure(gcf);
tlt=tiledlayout(panel,10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";

ax1=nexttile(tlt,[8 10]);
ylim([scale_min ,scale_max])
hold on;

for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.profilelvls)
 plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.localOptimaProfile{j}.profilelvls(i),calculations.localOptimaProfile{j}.profilelvls(i)],calculations.localOptimaProfile{j}.color,'linewidth',min(4,calculations.localOptimaProfile{j}.width_profilelvls(i)));
end
end
for i=1:numel(calculations.levels.values)
 plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
end
plot(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.pbto(genericrange)*1.001,'c^','linewidth',4);
plot(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.psto(genericrange)*0.999,'cv','linewidth',4);

cndl4(params.TimeTables.Minute(genericrange,:));
grid on;
hold on;

text(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.up.final(genericrange)));
text(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.psto(genericrange)*0.999,num2str(calculations.dn.final(genericrange)));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.pbto*1.01,num2str(result.success_bto));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.psto*.99,num2str(result.success_sto));
for j=1:numel(calculations.localOptimaProfile)
plot(params.TimeTables.Minute.Date(genericrange),calculations.localOptimaProfile{j}.localoptima{1}(genericrange),'k.','linewidth',j);
plot(params.TimeTables.Minute.Date(genericrange),calculations.localOptimaProfile{j}.localoptima{2}(genericrange),'k.','linewidth',j);
end
hold off;

maxvol=max(params.TimeTables.Minute.Volume);
pvs_=(calculations.up.cond | calculations.dn.cond).*params.TimeTables.Minute.Volume;
pvs_(pvs_==0)=NaN;

ax2=nexttile(tlt,[2 10]);
bar(params.TimeTables.Minute.Date(genericrange),params.TimeTables.Minute.Volume(genericrange),'g');
grid on;
hold on;
bar(params.TimeTables.Minute.Date(genericrange),calculations.sellv(genericrange),'r');
plot(params.TimeTables.Minute.Date(genericrange),pvs_(genericrange),'*b');
title(['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);
hold off;

linkaxes([ax1 ax2],'x');
%vertical_cursors;
end
end