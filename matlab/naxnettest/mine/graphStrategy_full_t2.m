function n=graphStrategy_full_t2(panel,params,calculations,result)
if (isvalid(panel))
showlimit_=min(params.showlimit,numel(params.TimeTables.Minute.Date)-1);
genericrange=(numel(params.TimeTables.Minute.Date)-showlimit_):numel(params.TimeTables.Minute.Date);

scale_min=min(params.TimeTables.Minute.Low(genericrange));
scale_max=max(params.TimeTables.Minute.High(genericrange));
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*params.scalepercent;
scale_max=scale_max+scale_d*params.scalepercent;

%load(['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(params.symbol) ' intraday_week ' params.date '.mat']);
%TimeTables.Minute5d=table2timetable(tm);

%figure(gcf);
tlt=tiledlayout(panel,10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";
ax0=nexttile(tlt,[7 1]);
volumeprofile(params.TimeTables.Minute5d);

ax1=nexttile(tlt,[7 9]);

linkaxes([ax1 ax0],'y');
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

%% show upper indicators

for i=1:numel(params.upper_indicators)
   plot(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.upper(genericrange,params.upper_indicators{i}).Variables,'k--','linewidth',1);
    
end


%% candle 
cndl4(params.TimeTables.Minute(genericrange,:));
grid on;
hold on;

text(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.up.final(genericrange)));
text(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.eval.psto(genericrange)*0.999,num2str(calculations.dn.final(genericrange)));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.pbto*1.01,num2str(result.success_bto));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.psto*.99,num2str(result.success_sto));

for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.localoptima)
    onlyvals=calculations.localOptimaProfile{j}.localoptima{i}>0;
plot(params.TimeTables.Minute.Date(onlyvals),calculations.localOptimaProfile{j}.localoptima{i}(onlyvals),'c:','linewidth',j);
end
%plot(params.TimeTables.Minute.Date(genericrange),calculations.localOptimaProfile{j}.localoptima{2}(genericrange),'k:','linewidth',j);
end
hold off;

maxvol=max(params.TimeTables.Minute.Volume);
pvs_=(calculations.up.cond | calculations.dn.cond).*params.TimeTables.Minute.Volume;
pvs_(pvs_==0)=NaN;
nexttile(tlt,[1 1]);
ax2=nexttile(tlt,[1 9]);
bar(params.TimeTables.Minute.Date(genericrange),params.TimeTables.Minute.Volume(genericrange),'g');
grid on;
hold on;
bar(params.TimeTables.Minute.Date(genericrange),calculations.sellv(genericrange),'r');
plot(params.TimeTables.Minute.Date(genericrange),pvs_(genericrange),'*b');
title(['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);
hold off;


%find(strcmp(mainticks{1}.calculations.lower_indicators.Properties.VariableNames,'RelativeStrength'))

nexttile(tlt,[1 1]);
ax3=nexttile([1 9]);
if (~isempty(params.lower_indicators{1}))
plot(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.lower(genericrange,params.lower_indicators{1}).Variables);
legend(calculations.indicators{1}.lower.Properties.VariableNames(params.lower_indicators{1}));
end
grid on;
nexttile(tlt,[1 1]);
ax4=nexttile([1 9]);
if (~isempty(params.lower_indicators{2}))
plot(params.TimeTables.Minute.Date(genericrange),calculations.indicators{1}.lower(genericrange,params.lower_indicators{2}).Variables);
legend(calculations.indicators{1}.lower.Properties.VariableNames(params.lower_indicators{2}));
end
grid on;
linkaxes([ax1 ax2 ax3 ax4],'x');

%vertical_cursors;
end
end