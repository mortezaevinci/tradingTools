function layout=graphStrategy_t7_init(panel,looperParams,params,result)
layout=[];
try

if (isvalid(panel))
if (looperParams.graph.showlimit>0)
showlimit_=min(looperParams.graph.showlimit,numel(params.TimeTables.Minute.Date)-1);
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

layout.ax{1}=nexttile(tlt,[8,3]);
layout.bar_profile=barh(0,0,'k');
DCM_ON;
hold on;
layout.plot_profile=plot(0,0,'r*');
DCM_ON;
hold off;
layout.ax{2}=nexttile(tlt,[8 7]);
linkaxes([layout.ax{1} layout.ax{2}],'y');



hold on;
plotcount=1;
for j=1:50
 layout.plocalOptimaProfile{plotcount}=plot(datetime(),0,'ButtonDownFcn',@generalPlotCallback);
  plotcount=plotcount+1;
end

plotcount=1;
for i=1:50
 layout.plevels{plotcount}=plot(datetime(),0,'DisplayName','','ButtonDownFcn',@generalPlotCallback);%plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
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
   layout.pindicators{plotcount}=plot(datetime(),0,'k--','linewidth',1,'ButtonDownFcn',@generalPlotCallback);
    plotcount=plotcount+1;
end

%% entries
plotcount=1;
layout.pmain{plotcount}=plot(datetime(),0,'m^','linewidth',4,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;
layout.pmain{plotcount}=plot(datetime(),0,'mv','linewidth',4,'ButtonDownFcn',@generalPlotCallback);
plotcount=plotcount+1;



%% candle 
Close=[1:looperParams.graph.showlimit]';
Low=Close;
High=Close;
Open=Close;
Date=datetime()+minutes(Close);
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


hold off;

set(layout.ax{2},'ytick',[]);
%axes(layout.ax{2});
set(layout.ax{2}.Title,'String',[num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
%title([num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
ylim([scale_min ,scale_max])

 %;disp('lower');
 nexttile(tlt,[2 3]);
layout.axlower{1}=nexttile(tlt,[2 7]);
%axes(layout.axlower{1});
%maxvol=max(params.TimeTables.Minute.Volume);
%pvs_=(calculations.up.cond | calculations.dn.cond).*params.TimeTables.Minute.Volume;
%pvs_(pvs_==0)=NaN;

layout.bar_lower1{1}=bar(datetime(),0,'g');
DCM_ON;
grid on;
hold on;
layout.bar_lower1{2}=bar(datetime(),0,'r');
layout.p_lower1=plot(datetime(),0,'*b');
set(layout.axlower{1}.Title,'String',['maxvol=' fliplr(regexprep(fliplr(num2str(0)),'\d{3}(?=\d)', '$0,'))]);
hold off;

linkaxes([layout.ax{2} layout.axlower{1}],'x');
hold off;
else
    disp('panel invalid');
end
catch exception
getReport(exception,'extended','hyperlinks','off')
end
end