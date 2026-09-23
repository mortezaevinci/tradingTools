function n=graphStrategy_full_t5(panel,params,calculations,result,showall)
if (isvalid(panel))
if (showall || params.showlimit<0)
    genericrange=1:numel(params.TimeTables.Minute.Date);
    showlimit_=numel(params.TimeTables.Minute.Date)-1;
else
showlimit_=min(params.showlimit,numel(params.TimeTables.Minute.Date)-1);
genericrange=(numel(params.TimeTables.Minute.Date)-showlimit_):numel(params.TimeTables.Minute.Date);
end
dsample=params.TimeTables.Minute.Date(genericrange);

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
ax{1}=nexttile(tlt,[7 1]);

book=readbook(params.symbol);
if (~isempty(book))
book=cleanbook(book,params.TimeTables.Minute.Close(end));
profile(book(:,1),book(:,2));
else
volumeprofile(params.TimeTables.Minute5d);
end

ax{2}=nexttile(tlt,[7 9]);
title([num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
linkaxes([ax{1} ax{2}],'y');
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
plot(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,'c^','linewidth',4);
plot(dsample,calculations.indicators{1}.eval.psto(genericrange)*0.999,'cv','linewidth',4);

%% show upper indicators

for i=1:numel(params.upper_indicators)
   plot(dsample,calculations.indicators{1}.upper(genericrange,params.upper_indicators{i}).Variables,'k--','linewidth',1);
    
end


%% candle 
cndl4(params.TimeTables.Minute(genericrange,:));
grid on;
hold on;

text(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.up.final(genericrange)));
text(dsample,calculations.indicators{1}.eval.psto(genericrange)*0.999,num2str(calculations.dn.final(genericrange)));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.pbto*1.01,num2str(result.success_bto));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.psto*.99,num2str(result.success_sto));

for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.localoptima)
    
%    vsample=calculations.localOptimaProfile{j}.localoptima{i}(genericrange);
%    onlyvals=vsample>0;
%plot(dsample(onlyvals),vsample(onlyvals),'c:','linewidth',j);

  vsample=calculations.localOptimaProfile{j}.localoptima{i};%=(genericrange);
     onlyvals=vsample>0;
 plot(params.TimeTables.Minute.Date(onlyvals),vsample(onlyvals),'c:','linewidth',j);
end

end
hold off;

maxvol=max(params.TimeTables.Minute.Volume);
pvs_=(calculations.up.cond | calculations.dn.cond).*params.TimeTables.Minute.Volume;
pvs_(pvs_==0)=NaN;
nexttile(tlt,[1 1]);
axlower{1}=nexttile(tlt,[1 9]);
bar(dsample,params.TimeTables.Minute.Volume(genericrange),'g');
grid on;
hold on;
bar(dsample,calculations.sellv(genericrange),'r');
plot(dsample,pvs_(genericrange),'*b');
title(['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);
hold off;



for axi=1:2
nexttile(tlt,[1 1]);
axlower{axi+1}=nexttile([1 9]);
if (~isempty(params.lower_indicators{1}))
nind=numel(params.lower_indicators{1});
hold off
%for indi=1:nind
   indicatorindex=params.lower_indicators{axi};%{indi};%find(strcmp(calculations.indicators{1}.lower.Properties.VariableNames,params.lower_indicators{axi}{indi})) 
    plot(dsample,calculations.indicators{1}.lower(genericrange,indicatorindex).Variables);
    legend(calculations.indicators{1}.lower.Properties.VariableNames(indicatorindex));
 %   hold on
%end
end
grid on;
end
linkaxes([ax{2} axlower{1} axlower{2} axlower{3}],'x');
drawnow
%vertical_cursors;
end
end