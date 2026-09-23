function layout=graphStrategy_t7_init(panel,looperEngine,params,result)
layout=struct();
layout.extended=0;
try

if (isvalid(panel))
% if (looperEngine.graph.showlimit>0)
% showlimit_=min(looperEngine.graph.showlimit,numel(params.TimeTables.Minute.Date)-1);
% genericrange=(numel(params.TimeTables.Minute.Date)-showlimit_):numel(params.TimeTables.Minute.Date);
% else
% genericrange=1:numel(params.TimeTables.Minute.Date);
% end
% 
% scale_min=min(params.TimeTables.Minute.Low(genericrange));
% scale_max=max(params.TimeTables.Minute.High(genericrange));
% scale_d=scale_max-scale_min;
scale_min=0;%scale_min-scale_d*params.scalepercent;
scale_max=100;%scale_max+scale_d*params.scalepercent;

tlt=tiledlayout(panel,10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";

layout.ax{2}=nexttile(tlt,[8 8]);

hold on;
plotcount=1;
for j=1:50
 layout.plocalOptimaProfile{plotcount}=plot(datetime(),0,'ButtonDownFcn',@generalPlotCallback);
  plotcount=plotcount+1;
end

plotcount=1;
for i=1:150
 layout.plevels{plotcount}=plot(datetime(),0,'DisplayName','','ButtonDownFcn',@generalPlotCallback);%plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
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
layout.pmain{plotcount}=plot(datetime(),0,'m^','linewidth',3,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pmain{plotcount}=plot(datetime(),0,'mv','linewidth',3,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;

%% exits
plotcount=1;
layout.pexits{plotcount}=plot(datetime(),0,'ks','linewidth',3,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pexits{plotcount}=plot(datetime(),0,'ks','linewidth',3,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;


%% net entries
plotcount=1;
layout.pnet{plotcount}=plot(datetime(),0,'Marker','^','LineStyle','none','Color',[0 0.75 1 1],'linewidth',3,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pnet{plotcount}=plot(datetime(),0,'Marker','v','LineStyle','none','Color',[0 0.75 1 1],'linewidth',3,'MarkerSize',3,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;


%% candle 
Close=zeros(2,1);%Close=[1:looperEngine.graph.showlimit]';
Low=Close;
High=Close;
Open=Close;
Date=[datetime();datetime()+minutes(1)];
samplett=timetable(Date,Open,High,Low,Close);

layout.candleplotformat=cndl5(samplett);
grid on;
hold on;
DCM_ON;

% 
% timearray=datetime():minutes(1):(datetime()+minutes(1000));
% dataarray=1:1001;
% textarray=cell(1,1001);
% 
% layout.maintexts=text(timearray,dataarray,textarray);
%% book levels
plotcount=1;
layout.pbooklvls{plotcount}=plot(datetime(),0,'g--','linewidth',1,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pbooklvls{plotcount}=plot(datetime(),0,'r--','linewidth',1,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;

hold off;

%set(layout.ax{2},'ytick',[]);
%axes(layout.ax{6});
%set(layout.ax{2}.Title,'String',[num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
%title([num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
ylim([scale_min ,scale_max])

layout.ax{1}=nexttile(tlt,[8,2]);
layout.bar_profile=barh(0,0,'k');
DCM_ON;
hold on;
layout.plot_profile=plot(0,0,'r*');
DCM_ON;
hold off;


%% 'lower');

layout.axlower{1}=nexttile(tlt,[2 8]);
%axes(layout.axlower{1});
%maxvol=max(params.TimeTables.Minute.Volume);
%pvs_=(calculations.DirectionPrediction{1}.Condition | calculations.DirectionPrediction{2}.Condition).*params.TimeTables.Minute.Volume;
%pvs_(pvs_==0)=NaN;

layout.bar_lower1{1}=bar(datetime(),0,'g');
DCM_ON;
grid on;
hold on;
layout.bar_lower1{2}=bar(datetime(),0,'r');
layout.p_lower1=plot(datetime(),0,'*b');
set(layout.axlower{1}.Title,'String',['maxvol=' fliplr(regexprep(fliplr(num2str(0)),'\d{3}(?=\d)', '$0,'))]);
hold off;

linkaxes([layout.ax{1} layout.ax{2}],'y');
linkaxes([layout.ax{2} layout.axlower{1}],'x');
hold off;

atemp=nexttile(tlt,[2 2]);
atemp.Visible=false;

else
    disp('panel invalid');
end
catch exception
dumpReport('error.log', exception)
end
end