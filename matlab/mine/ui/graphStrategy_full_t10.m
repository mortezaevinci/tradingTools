function layout=graphStrategy_full_t9(layout,looperEngine,params,calculations,result)
try
if (~isempty(layout))
    if (looperEngine.process.type==1)
    timetablePrimary=params.TimeTables.Day(end-90:end,:);
    end
    
   if (looperEngine.process.type==0)
    timetablePrimary=params.TimeTables.Minute;
   end
 if (looperEngine.graph.showlimit>0)
showlimit_=min(looperEngine.graph.showlimit,numel(timetablePrimary.Date)-1);
genericrange=(numel(timetablePrimary.Date)-showlimit_):numel(timetablePrimary.Date);
genericrangefull=(numel(params.TimeTables.MinuteFull.Date)-showlimit_):numel(params.TimeTables.MinuteFull.Date);
else
genericrange=1:numel(timetablePrimary.Date);
genericrangefull=1:numel(params.TimeTables.MinuteFull.Date);
end
dsample=timetablePrimary.Date(genericrange);

scale_min=min(timetablePrimary.Low(genericrange));
scale_max=max(timetablePrimary.High(genericrange));
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*looperEngine.graph.scalepercent;
scale_max=scale_max+scale_d*looperEngine.graph.scalepercent;

[book,bid,ask,date]=readbookBn2(looperEngine,params.contract.FileSymbol);
midpoint=(bid+ask)/2;
if (~isempty(book))
book=cleanbook(book,midpoint);
 set(layout.bar_profile, 'XData', book(:,2), 'YData', book(:,1));
else
%volumeprofile(timetablePrimary5d,layout.bar_profile);
 %set(layout.plot_profile,'XData','YData',timetablePrimary.Close(end));
end

try
%axes(layout.ax{2});
%title([num2str(timetablePrimary.Close(end)) ' at ' datestr(timetablePrimary.Date(end))]);
set(layout.ax{2}.Title,'String',[num2str(timetablePrimary.Close(end)) ' at ' datestr(timetablePrimary.Date(end))]);
layout.ax{2}.YLim=([scale_min ,scale_max]);
 catch exception
dumpReport('error.log', exception)
    end


try
if (looperEngine.graph.showSections(2)==1)
plotcount=1;
for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.profilelvls)
  if (calculations.localOptimaProfile{j}.profilelvls(i)>scale_min && calculations.localOptimaProfile{j}.profilelvls(i)<scale_max)
 set(layout.plocalOptimaProfile{plotcount}, 'XData', [timetablePrimary.Date(genericrange(1)), timetablePrimary.Date(end)], 'YData', [calculations.localOptimaProfile{j}.profilelvls(i),calculations.localOptimaProfile{j}.profilelvls(i)],'Color',calculations.localOptimaProfile{j}.color,'LineStyle',calculations.localOptimaProfile{j}.style,'LineWidth',min(4,calculations.localOptimaProfile{j}.width_profilelvls(i)));
  plotcount=plotcount+1;
end
end
end
end
 catch exception
dumpReport('error.log', exception)
    end


 try
        if (looperEngine.graph.showSections(3)==1)
plotcount=1;
for i=1:numel(calculations.levels.values)
 if (calculations.levels.values(i)>scale_min && calculations.levels.values(i)<scale_max)
 %plot([timetablePrimary.Date(genericrange(1)), timetablePrimary.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
 set(layout.plevels{plotcount}, 'XData', [timetablePrimary.Date(genericrange(1)), timetablePrimary.Date(end)], 'YData', [calculations.levels.values(i),calculations.levels.values(i)],'Color',calculations.levels.color{i},'LineStyle',calculations.levels.style{i},'LineWidth',calculations.levels.width(i),'DisplayName',calculations.levels.name{i});
   plotcount=plotcount+1;
    end
    end
end
catch exception
dumpReport('error.log', exception)
    end

try
        if (looperEngine.graph.showSections(4)==1)
plotcount=1;
for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.localoptima)
    try
        vsample=calculations.localOptimaProfile{j}.localoptima{i};%=(genericrange);
         onlyvals=vsample>0;
    set(layout.plocalOptimaTrend{plotcount}, 'XData', timetablePrimary.Date(onlyvals), 'YData', vsample(onlyvals),'LineWidth',j);
    plotcount=plotcount+1;
    catch 
       disp('inde error again. fix this later.');
       size(timetablePrimary.Date(onlyvals))
       size(vsample(onlyvals))
    end
end
end
end

 catch exception
dumpReport('error.log', exception)
    end
 
%% show upper indicators

    try
plotcount=1;
if (~isempty(params.lower_indicators))
%% show upper indicators
 %;disp('upper indicators');
for i=1:numel(params.upper_indicators)
     set(layout.pindicators{plotcount}, 'XData',dsample , 'YData', calculations.indicators{1}.upper(genericrange,params.upper_indicators{i}.VariableName).Variables,'LineStyle',params.upper_indicators{i}.LineStyle,'Color',params.upper_indicators{i}.Color);
  plotcount=plotcount+1;   
end
end
 catch exception
dumpReport('error.log', exception)
    end
    
     
%% entries
try
    if (looperEngine.graph.showSections(5)==1)
 pbto=calculations.indicators{1}.eval.pbto(genericrange);
bto=find(pbto);
psto=calculations.indicators{1}.eval.psto(genericrange);
sto=find(psto);

%% entries
plotcount=1;
 set(layout.pmain{plotcount}, 'XData',dsample(bto) , 'YData', pbto(bto)*1+scale_d*.1);
 plotcount=plotcount+1;
 set(layout.pmain{plotcount}, 'XData',dsample(sto), 'YData', psto(sto)*1-scale_d*.1);
 plotcount=plotcount+1;
 end
catch exception
dumpReport('error.log', exception)
end

%% exists
try
if (looperEngine.graph.showSections(6)==1)
pstc=calculations.indicators{1}.eval.pstc(genericrange);
stc=find(pstc);
pbtc=calculations.indicators{1}.eval.pbtc(genericrange);
btc=find(pbtc);

%% exits grap
plotcount=1;
 set(layout.pexits{plotcount}, 'XData',dsample(stc) , 'YData', pstc(stc));
 plotcount=plotcount+1;
 set(layout.pexits{plotcount}, 'XData',dsample(btc), 'YData', pbtc(btc));
 plotcount=plotcount+1;
end
catch exception
dumpReport('error.log', exception) 
end

%% net entries
try
if (looperEngine.graph.showSections(7)==1 && looperEngine.net.use>0)
nbto=find(calculations.net.DirectionPrediction{1}.final(genericrange)>0);
nsto=find(calculations.net.DirectionPrediction{2}.final(genericrange)>0);

closesample=timetablePrimary.Close(genericrange);


plotcount=1;
 set(layout.pnet{plotcount}, 'XData',dsample(nbto), 'YData', closesample(nbto)+scale_d*.08);
 plotcount=plotcount+1;
 set(layout.pnet{plotcount}, 'XData',dsample(nsto), 'YData', closesample(nsto)-scale_d*.08);
 plotcount=plotcount+1;
 
    end
catch exception
dumpReport('error.log', exception) 
end

%% book levels
try
if (looperEngine.graph.showSections(8)==1)
if (isfield(params,'marketdata'))
plotcount=1;
ydata=shiftpad(params.marketdata.BookLevels(:,1),0);
 yind=find(~isnan(ydata));
 set(layout.pbooklvls{plotcount}, 'XData',params.marketdata.Date(yind)  , 'YData',ydata(yind) );
 plotcount=plotcount+1;
 ydata=shiftpad(params.marketdata.BookLevels(:,2),0);
  yind=find(~isnan(ydata));
 set(layout.pbooklvls{plotcount}, 'XData',params.marketdata.Date(yind) , 'YData',ydata(yind) );
 plotcount=plotcount+1;
 end
end
catch 
%dumpReport('error.log', exception)
end

endxlim=dsample(end)+seconds(30);

%% profiles

if (isfield(calculations,'SnappedPAP'))
    plotcount=1;
    tempdate=timetablePrimary.Date(1)+minutes(0:numel( calculations.SnappedPAP)-1);
 set(layout.pprofiles{plotcount}, 'XData', tempdate, 'YData', calculations.SnappedPAP);
 endxlim=tempdate(end)+seconds(30);
end
layout.ax{2}.XLim=([dsample(1)-seconds(30) endxlim]);
%% candle

hold on;
try
    if (isempty(params.TimeTables.MinuteFull))
    %axes(layout.ax{2});hold on;layout.candleplotformat=cndl5(timetablePrimary(genericrange,:));%,layout.candleplotformat);
    cndl5layout(timetablePrimary(genericrange,:),layout.candleplotformat);
    else
        cndl5layout(params.TimeTables.MinuteFull(genericrangefull,:),layout.candleplotformat);
    end


catch exception
    dumpReport('error.log', exception)
end
hold off;



%% draw vol
try
%text(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,num2str(calculations.DirectionPrediction{1}.final(genericrange)));

maxvol=max(timetablePrimary.Volume);
%pvs_=(calculations.DirectionPrediction{1}.Condition | calculations.DirectionPrediction{2}.Condition).*timetablePrimary.Volume;
%pvs_(pvs_==0)=NaN;


%bar(dsample,timetablePrimary.Volume(genericrange),'g');
 set(layout.bar_lower1{1}, 'XData',dsample , 'YData', calculations.indicators{1}.lower.VolumeBuzzRatio(genericrange));

%bar(dsample,calculations.indicators{1}.lower.SellVolume(genericrange),'r');
set(layout.bar_lower1{2}, 'XData', dsample, 'YData',calculations.indicators{1}.lower.SellVolumeBuzzRatio(genericrange));
%plot(dsample,pvs_(genericrange),'*b');
 %set(layout.p_lower1, 'XData', dsample, 'YData',pvs_(genericrange)./calculations.indicators{1}.lower.VolumeBuzz(genericrange));
set(layout.axlower{1}.Title,'String',['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);

catch exception
    dumpReport('error.log', exception)
end


%xxxmor, note that for now lower indicators will overwrite eval ones
%% draw eval indicators

try
if (~isempty(params.eval_indicators))
for axi=1:2
indicatorindex=params.eval_indicators{axi};

if (~isempty(indicatorindex))
nind=numel(indicatorindex);
%hold off
for indi=1:nind
    ni=indicatorindex{indi};
     if (~isempty(ni))
   yd=calculations.indicators{1}.eval(genericrange,ni).Variables;
   axtemp=layout.lowerx{axi};
   set(axtemp(indi), 'XData', dsample, 'YData', yd);

   end
end
layout.lowerx_legend{axi}.String=calculations.indicators{1}.eval.Properties.VariableNames(ni);
 
end
end
end
catch exception
    dumpReport('error.log', exception)
end


%% draw lower indicators

try
if (~isempty(params.lower_indicators))
for axi=1:2
indicatorindex=params.lower_indicators{axi};

if (~isempty(indicatorindex))
nind=numel(indicatorindex);
%hold off
for indi=1:nind
    ni=indicatorindex{indi};
     if (~isempty(ni))
 
   yd=calculations.indicators{1}.lower(genericrange,ni).Variables;
   axtemp=layout.lowerx{axi};
   set(axtemp(indi), 'XData', dsample, 'YData', yd);

    end
end
layout.lowerx_legend{axi}.String=calculations.indicators{1}.lower.Properties.VariableNames(ni);
 
end
end
end
catch exception
    dumpReport('error.log', exception)
end


%drawnow
%vertical_cursors;
end
catch exception
dumpReport('error.log', exception)
end
end