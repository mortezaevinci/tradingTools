function n=graphStrategy_full_t5(layout,params,calculations,result)
try
if (~isempty(layout))
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

book=readbook(params.symbol);
if (true)%~isempty(book))
book=cleanbook(book,params.TimeTables.Minute.Close(end));
 set(layout.bar_profile, 'XData', book(:,2), 'YData', book(:,1));
else
%volumeprofile(params.TimeTables.Minute5d,layout.bar_profile);
 %set(layout.plot_profile,'XData',,'YData',params.TimeTables.Minute.Close(end));
end

%axes(layout.ax{2});
%title([num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
set(layout.ax{2}.Title,'String',[num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
layout.ax{2}.YLim=([scale_min ,scale_max]);

try
plotcount=1;
for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.profilelvls)
  if (calculations.localOptimaProfile{j}.profilelvls(i)>scale_min && calculations.localOptimaProfile{j}.profilelvls(i)<scale_max)
 set(layout.plocalOptimaProfile{plotcount}, 'XData', [params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)], 'YData', [calculations.localOptimaProfile{j}.profilelvls(i),calculations.localOptimaProfile{j}.profilelvls(i)],'Color',calculations.localOptimaProfile{j}.color,'LineStyle',calculations.localOptimaProfile{j}.style,'LineWidth',min(4,calculations.localOptimaProfile{j}.width_profilelvls(i)));
  plotcount=plotcount+1;
          end
end
end
 catch exception
getReport(exception,'extended','hyperlinks','off')
    end


 try
plotcount=1;
for i=1:numel(calculations.levels.values)
 if (calculations.levels.values(i)>scale_min && calculations.levels.values(i)<scale_max)
 %plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
 set(layout.plevels{plotcount}, 'XData', [params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)], 'YData', [calculations.levels.values(i),calculations.levels.values(i)],'Color',calculations.levels.color{i},'LineStyle',calculations.levels.style{i},'LineWidth',calculations.levels.width(i));
   plotcount=plotcount+1;
    end
end
catch exception
getReport(exception,'extended','hyperlinks','off')
    end

try
plotcount=1;
for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.localoptima)
    try
        vsample=calculations.localOptimaProfile{j}.localoptima{i};%=(genericrange);
         onlyvals=vsample>0;
    set(layout.plocalOptimaTrend{plotcount}, 'XData', params.TimeTables.Minute.Date(onlyvals), 'YData', vsample(onlyvals),'LineWidth',j);
    plotcount=plotcount+1;
    catch 
       disp('inde error again. fix this later.');
       size(params.TimeTables.Minute.Date(onlyvals))
       size(vsample(onlyvals))
    end
end
end

 catch exception
getReport(exception,'extended','hyperlinks','off')
    end
 
%% show upper indicators

    try
plotcount=1;
%% show upper indicators
 %;disp('upper indicators');
for i=1:numel(params.upper_indicators)
  % plot(dsample,calculations.indicators{1}.upper(genericrange,params.upper_indicators{i}).Variables,'k--','linewidth',1);
     set(layout.pindicators{plotcount}, 'XData',dsample , 'YData', calculations.indicators{1}.upper(genericrange,params.upper_indicators{i}).Variables);
  plotcount=plotcount+1;   
end
 catch exception
getReport(exception,'extended','hyperlinks','off')
    end
    
     
%%prep entries
try
 pbto=calculations.indicators{1}.eval.pbto(genericrange);
bto=find(pbto);
psto=calculations.indicators{1}.eval.psto(genericrange);
sto=find(psto);

%% entries
plotcount=1;
%plot(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,'c^','linewidth',4);
 set(layout.pmain{plotcount}, 'XData',dsample(bto) , 'YData', pbto(bto)*1.001);
 plotcount=plotcount+1;
%plot(dsample,calculations.indicators{1}.eval.psto(genericrange)9*0.999,'cv','linewidth',4);
 set(layout.pmain{plotcount}, 'XData',dsample(sto), 'YData', psto(sto)*0.999);
 plotcount=plotcount+1;
catch
    
end
    
%% candle

try
cndl5layout(params.TimeTables.Minute(genericrange,:),layout.candleplotformat);

%cndl4(params.TimeTables.Minute(genericrange,:));
catch exception
    getReport(exception,'extended','hyperlinks','off')
end
layout.ax{2}.XLim=([dsample(1)-seconds(30) dsample(end)+seconds(30)]);


%text(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.up.final(genericrange)));

maxvol=max(params.TimeTables.Minute.Volume);
pvs_=(calculations.up.cond | calculations.dn.cond).*params.TimeTables.Minute.Volume;
pvs_(pvs_==0)=NaN;


%bar(dsample,params.TimeTables.Minute.Volume(genericrange),'g');
 set(layout.bar_lower1{1}, 'XData',dsample , 'YData', params.TimeTables.Minute.Volume(genericrange));

%bar(dsample,calculations.sellv(genericrange),'r');
set(layout.bar_lower1{2}, 'XData', dsample, 'YData',calculations.sellv(genericrange) );
%plot(dsample,pvs_(genericrange),'*b');
 set(layout.p_lower1, 'XData', dsample, 'YData',pvs_(genericrange) );
set(layout.axlower{1}.Title,'String',['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);



for axi=1:2

if (~isempty(params.lower_indicators{1}))
nind=numel(params.lower_indicators{1});
hold off
%for indi=1:nind
   indicatorindex=params.lower_indicators{axi};%{indi};%find(strcmp(calculations.indicators{1}.lower.Properties.VariableNames,params.lower_indicators{axi}{indi})) 
    if (~isempty(indicatorindex))
   %  plot(dsample,calculations.indicators{1}.lower(genericrange,indicatorindex).Variables);
   set(layout.lowerx{axi}, 'XData', dsample, 'YData', calculations.indicators{1}.lower(genericrange,indicatorindex).Variables);
    legend(calculations.indicators{1}.lower.Properties.VariableNames(indicatorindex));
    end
 %   hold on
%end
end
grid on;
end

drawnow
%vertical_cursors;
end
catch exception
getReport(exception,'extended','hyperlinks','off')
end
end