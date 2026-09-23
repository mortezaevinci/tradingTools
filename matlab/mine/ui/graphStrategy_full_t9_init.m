function layout=graphStrategy_full_t9_init(panel,looperEngine,params,result)
layout=struct();
layout.extended=1;
try

if (isvalid(panel))
% if (looperEngine.graph.showlimit>0)
% showlimit_=min(looperEngine.graph.showlimit,numel(params.TimeTables.Minute.Date)-1);
% genericrange=(numel(params.TimeTables.Minute.Date)-showlimit_):numel(params.TimeTables.Minute.Date);
% else
% genericrange=1:numel(params.TimeTables.Minute.Date);
% end
%dsample=params.TimeTables.Minute.Date(genericrange);

% 
% scale_min=min(params.TimeTables.Minute.Low(genericrange));
% scale_max=max(params.TimeTables.Minute.High(genericrange));
% scale_d=scale_max-scale_min;
scale_min=0;%scale_min-scale_d*params.scalepercent;
scale_max=100;%scale_max+scale_d*params.scalepercent;

tlt=tiledlayout(panel,10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";


layout.ax{2}=nexttile(tlt,[7 9]);

hold on;
%plots
plotcount=1;
for j=1:50
 layout.plocalOptimaProfile{plotcount}=plot(datetime(),0,'ButtonDownFcn',@generalPlotCallback);
  plotcount=plotcount+1;
  hold on;
end

plotcount=1;
for i=1:150
 layout.plevels{plotcount}=plot(datetime(),0,'ButtonDownFcn',@generalPlotCallback);%plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
plotcount=plotcount+1;
end

plotcount=1;

for j=1:50
layout.plocalOptimaTrend{plotcount}= plot(datetime(),0,'LineStyle',':','Color',[0 0.75 1 1]);% plot(params.TimeTables.Minute.Date(onlyvals),vsample(onlyvals),'c:','linewidth',j);
    plotcount=plotcount+1;
end

plotcount=1;
%% show upper indicators
 %;disp('upper indicators');
for i=1:20
   layout.pindicators{plotcount}=plot(datetime(),0,'k--','linewidth',1,'ButtonDownFcn',@generalPlotCallback);
    plotcount=plotcount+1;
end
%% entries
plotcount=1;
layout.pmain{plotcount}=plot(datetime(),0,'m^','linewidth',2,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pmain{plotcount}=plot(datetime(),0,'mv','linewidth',2,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;

%% exits
plotcount=1;
layout.pexits{plotcount}=plot(datetime(),0,'ks','linewidth',2,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pexits{plotcount}=plot(datetime(),0,'ks','linewidth',2,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;

%% net entries
plotcount=1;
layout.pnet{plotcount}=plot(datetime(),0,'Marker','^','LineStyle','none','Color',[0 0.75 1 1],'linewidth',2,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pnet{plotcount}=plot(datetime(),0,'Marker','v','LineStyle','none','Color',[0 0.75 1 1],'linewidth',2,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;


%% book levels
plotcount=1;
layout.pbooklvls{plotcount}=plot(datetime(),0,'LineStyle','--','Color',[1 0 1 1],'linewidth',1,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pbooklvls{plotcount}=plot(datetime(),0,'LineStyle','--','Color',[1 0 1 1],'linewidth',1,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;

%% guides
plotcount=1;
layout.guides{plotcount}.handle=plot(datetime(),0,'LineStyle','-','Color',[0 .7 0 1],'linewidth',1);
layout.guides{plotcount}.crc=0;
plotcount=plotcount+1;
layout.guides{plotcount}.handle=plot(datetime(),0,'LineStyle','-','Color',[.7 0 0 1],'linewidth',1);
layout.guides{plotcount}.crc=0;
plotcount=plotcount+1;

%% profiles

plotcount=1;
layout.pprofiles{plotcount}=plot(datetime(),0,'b--','linewidth',1);
plotcount=plotcount+1;

%% candle 
Close=zeros(2,1);%1:looperEngine.graph.showlimit]';
Low=Close;
High=Close;
Open=Close;
Date=[datetime();datetime()+minutes(1)];
samplett=timetable(Date,Open,High,Low,Close);

layout.candleplotformat=cndl5(samplett);

set(layout.ax{2},'ytick',[]);
%set(layout.ax{2}.Title,'String',[num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
ylim([scale_min ,scale_max])
set(gca,'XMinorGrid','on');
set(gca,'XGrid','on');
grid on;
%set(gca,'Position',[0 0 1 1]);
DCM_ON;
%layout.textBTO=text(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.DirectionPrediction{1}.final(genericrange)));
%layout.textSTO=text(dsample,calculations.indicators{1}.eval.psto(genericrange)*0.999,num2str(calculations.DirectionPrediction{2}.final(genericrange)));



hold off;


layout.ax{1}=nexttile(tlt,[7 1]);
layout.bar_profile=barh(0,0,'k');
DCM_ON;
hold on;
layout.plot_profile=plot(0,0,'r*');
DCM_ON;
%set(gca,'Position',[0 0 1 1]);
hold off;

%maxvol=max(params.TimeTables.Minute.Volume);
%pvs_=(calculations.DirectionPrediction{1}.Condition | calculations.DirectionPrediction{2}.Condition).*params.TimeTables.Minute.Volume;
%pvs_(pvs_==0)=NaN;


layout.axlower{1}=nexttile(tlt,[1 9]);
layout.bar_lower1{1}=bar(datetime(),0,'g');
DCM_ON;
grid on;
hold on;
layout.bar_lower1{2}=bar(datetime(),0,'r');
layout.p_lower1=plot(datetime(),0,'*b');
hold off;

atemp=nexttile(tlt,[1 1]);
atemp.Visible=false;
%set(gca,'Position',[0 0 1 1]);

for axi=1:2

layout.axlower{axi+1}=nexttile([1 9]);
hold on;
DCM_ON;
 %indicatorindex=params.lower_indicators{axi};%{indi};%find(strcmp(calculations.indicators{1}.lower.Properties.VariableNames,params.lower_indicators{axi}{indi})) 
if (false)%~isempty(indicatorindex))
   
    layout.lowerx{axi}=plot([[datetime();datetime()],[datetime();datetime()],[datetime();datetime()]],[[0;0],[0;0],[0;0]]);
    layout.lowerx_legend{axi}=legend({'','',''});

else
    %set some zero values
    layout.lowerx{axi}=plot([[datetime();datetime()],[datetime();datetime()],[datetime();datetime()]],[[0;0],[0;0],[0;0]]);
    layout.lowerx_legend{axi}=legend({'','',''});
end
%set(gca,'Position',[0 0 1 1]);
grid on;
hold off;

atemp=nexttile(tlt,[1 1]);
atemp.Visible=false;
end


linkaxes([layout.ax{1} layout.ax{2}],'y');
linkaxes([layout.ax{2} layout.axlower{1} layout.axlower{2} layout.axlower{3}],'x');
hold off;
%vertical_cursors;
else
    disp('invalid panel');
end
catch exception
dumpReport('error.log', exception)
end
end