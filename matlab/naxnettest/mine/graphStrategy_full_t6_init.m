function layout=graphStrategy_full_t6_init(panel,params,calculations,result)
layout=[];
try

if (isvalid(panel))
if (params.showlimit>0)
showlimit_=min(params.showlimit,numel(params.TimeTables.Minute.Date)-1);
genericrange=(numel(params.TimeTables.Minute.Date)-showlimit_):numel(params.TimeTables.Minute.Date);
else
genericrange=1:numel(params.TimeTables.Minute.Date);
end
dsample=params.TimeTables.Minute.Date(genericrange);


scale_min=min(params.TimeTables.Minute.Low(genericrange));
scale_max=max(params.TimeTables.Minute.High(genericrange));
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*params.scalepercent;
scale_max=scale_max+scale_d*params.scalepercent;

tlt=tiledlayout(panel,10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";
layout.ax{1}=nexttile(tlt,[7 1]);
layout.bar_profile=barh(0,0,'k');
DCM_ON;
hold on;
layout.plot_profile=plot(0,0,'r*');
DCM_ON;
hold off;
layout.ax{2}=nexttile(tlt,[7 9]);
linkaxes([layout.ax{1} layout.ax{2}],'y');

hold on;
%plots
plotcount=1;
for j=1:50
 layout.plocalOptimaProfile{plotcount}=plot(datetime(),0);
  plotcount=plotcount+1;
  hold on;
end

plotcount=1;
for i=1:50
 layout.plevels{plotcount}=plot(datetime(),0);%plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
plotcount=plotcount+1;
end

plotcount=1;

for j=1:50
layout.plocalOptimaTrend{plotcount}= plot(datetime(),0,'c:');% plot(params.TimeTables.Minute.Date(onlyvals),vsample(onlyvals),'c:','linewidth',j);
    plotcount=plotcount+1;
end

plotcount=1;
%% show upper indicators
 %;disp('upper indicators');
for i=1:20
   layout.pindicators{plotcount}=plot(datetime(),0,'k--','linewidth',1);
    plotcount=plotcount+1;
end
%% entries
plotcount=1;
layout.pmain{plotcount}=plot(datetime(),0,'c^','linewidth',4);
plotcount=plotcount+1;
layout.pmain{plotcount}=plot(datetime(),0,'cv','linewidth',4);
plotcount=plotcount+1;

%% candle 
Close=[1:params.showlimit]';
Low=Close;
High=Close;
Open=Close;
Date=datetime()+minutes(Close);
samplett=timetable(Date,Open,High,Low,Close);

layout.candleplotformat=cndl5(samplett);
set(layout.ax{2},'ytick',[]);
set(layout.ax{2}.Title,'String',[num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
ylim([scale_min ,scale_max])

grid on;
hold on;
DCM_ON;
%layout.textBTO=text(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.up.final(genericrange)));
%layout.textSTO=text(dsample,calculations.indicators{1}.eval.psto(genericrange)*0.999,num2str(calculations.dn.final(genericrange)));



hold off;

%maxvol=max(params.TimeTables.Minute.Volume);
pvs_=(calculations.up.cond | calculations.dn.cond).*params.TimeTables.Minute.Volume;
pvs_(pvs_==0)=NaN;
nexttile(tlt,[1 1]);
layout.axlower{1}=nexttile(tlt,[1 9]);
layout.bar_lower1{1}=bar(dsample,params.TimeTables.Minute.Volume(genericrange),'g');
DCM_ON;
grid on;
hold on;
layout.bar_lower1{2}=bar(dsample,calculations.sellv(genericrange),'r');
layout.p_lower1=plot(dsample,pvs_(genericrange),'*b');
hold off;



for axi=1:2
nexttile(tlt,[1 1]);
layout.axlower{axi+1}=nexttile([1 9]);
hold on;
DCM_ON;
 indicatorindex=params.lower_indicators{axi};%{indi};%find(strcmp(calculations.indicators{1}.lower.Properties.VariableNames,params.lower_indicators{axi}{indi})) 
if (~isempty(indicatorindex))
     
    layout.lowerx{axi}=plot(dsample,calculations.indicators{1}.lower(genericrange,indicatorindex).Variables);
    legend(calculations.indicators{1}.lower.Properties.VariableNames(indicatorindex));
else
    %set some zero values
    layout.lowerx{axi}=plot(dsample,zeros(size(dsample)));
end
grid on;
hold off;
end
linkaxes([layout.ax{2} layout.axlower{1} layout.axlower{2} layout.axlower{3}],'x');
hold off;
%vertical_cursors;
else
    disp('invalid panel');
end
catch exception
getReport(exception,'extended','hyperlinks','off')
end
end