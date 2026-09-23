function n=graphStrategy_t9(layout,looperEngine,params,calculations,result)
try
if (~isempty(layout))
    
     if (looperEngine.process.type==1)
    timetablePrimary=params.TimeTables.Day(end-120:end,:);
    end
    
   if (looperEngine.process.type==0)
    timetablePrimary=params.TimeTables.Minute;
   end
   
     %;disp('graph');
     %%tic;
if (looperEngine.graph.showlimit>0 && layout.extended==0)
showlimit_=min(looperEngine.graph.showlimit,numel(params.TimeTables.Minute.Date)-1);
genericrange=(numel(timetablePrimary.Date)-showlimit_):numel(timetablePrimary.Date);
else
genericrange=1:numel(timetablePrimary.Date);
end

dsample=timetablePrimary.Date(genericrange);

scale_min=min(timetablePrimary.Low(genericrange));
scale_max=max(timetablePrimary.High(genericrange));
scale_d=scale_max-scale_min;
scale_min=scale_min-scale_d*looperEngine.graph.scalepercent;
scale_max=scale_max+scale_d*looperEngine.graph.scalepercent;

%%ticgrange=toc

%%tic
if (looperEngine.graph.showSections(1)==1)
[book,bid,ask,date]=readbookBn2(looperEngine,params.contract.FileSymbol);
midpoint=(bid+ask)/2;
if (~isempty(book))

if (datetime()-miuntes(3)>date)
fc=[1 .5 .5];
else
fc=[0 0 0];
end

book=cleanbook(book,midpoint);
%profile(book(:,1),book(:,2));
 set(layout.bar_profile, 'XData', book(:,2), 'YData', book(:,1),'EdgeColor',fc);
 set(layout.plot_profile,'XData',0,'YData',timetablePrimary.Close(end));
set(layout.ax{1},'YTickLabel',[]);
end
end

if (params.doBookOnly==1)
    return;
end

%%ticgbook=toc

%axes(layout.ax{2});
%title([num2str(timetablePrimary.Close(end)) ' at ' datestr(timetablePrimary.Date(end))]);
set(layout.ax{2}.Title,'String',[num2str(timetablePrimary.Close(end)) ' at ' datestr(timetablePrimary.Date(end))]);
layout.ax{2}.YLim=([scale_min ,scale_max]);

%%tic
 try
     if (looperEngine.graph.showSections(2)==1)
plotcount=1;
%layout.pmain{plotcount}=plot(dsample,timetablePrimary.Close(end)+rand(size(dsample)));
%set(layout.pmain{plotcount}, 'XData',dsample , 'YData', timetablePrimary.Close(end)+rand(size(dsample)));
%plotcount=plotcount+1;
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
%%ticgprofilelvls=toc

%%tic
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
%%ticglevels=toc
%%tic;
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
    
    %%ticglocaloptima=toc
%%tic;
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
dumpReport('error.log', exception)
    end
    %%ticgupper=toc
    
%%prep entries
%%tic
try
    if (looperEngine.graph.showSections(5)==1)
pbto=calculations.indicators{1}.eval.pbto(genericrange);
bto=find(pbto);
psto=calculations.indicators{1}.eval.psto(genericrange);
sto=find(psto);

%% entries
plotcount=1;
 set(layout.pmain{plotcount}, 'XData',dsample(bto) , 'YData', pbto(bto)*1.001);
 plotcount=plotcount+1;
 set(layout.pmain{plotcount}, 'XData',dsample(sto), 'YData', psto(sto)*0.999);
 plotcount=plotcount+1;
    end
 catch
end
%%ticgentries=toc

%% exists
%%tic;
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
catch
    
end
%%ticgexits=toc
%% net entries
%%tic;
try
if (looperEngine.graph.showSections(7)==1)
nbto=find(calculations.net.DirectionPrediction{1}.final(genericrange)>0);
nsto=find(calculations.net.DirectionPrediction{2}.final(genericrange)>0);

closesample=timetablePrimary.Close(genericrange);

if (looperEngine.net.use==1)
plotcount=1;
 set(layout.pnet{plotcount}, 'XData',dsample(nbto), 'YData', closesample(nbto)+scale_d*.08);
 plotcount=plotcount+1;
 set(layout.pnet{plotcount}, 'XData',dsample(nsto), 'YData', closesample(nsto)-scale_d*.08);
 plotcount=plotcount+1;
end
end

catch exception
dumpReport('error.log', exception) 
end
 %%ticgnetentries=toc
 
%% book levels
%%tic;
try
    if (looperEngine.graph.showSections(8)==1)
if (isfield(params,'marketdata'))
plotcount=1;
 set(layout.pbooklvls{plotcount}, 'XData',dsample , 'YData', shiftpad(params.marketdata.BookLevels(genericrange,1),0));
 plotcount=plotcount+1;
 set(layout.pbooklvls{plotcount}, 'XData',dsample, 'YData',shiftpad(params.marketdata.BookLevels(genericrange,2),0) );
 plotcount=plotcount+1;
 
end
    end
catch
    
end
   %%ticgbooklevels=toc 

endxlim=dsample(end)+seconds(30);

%% profiles
if (layout.extended==1)
if (isfield(calculations,'SnappedPAP'))
    plotcount=1;
    tempdate=timetablePrimary.Date(1)+minutes(0:numel( calculations.SnappedPAP)-1);
 set(layout.pprofiles{plotcount}, 'XData', tempdate, 'YData', calculations.SnappedPAP);
 endxlim=tempdate(end)+seconds(30);
end
else
if (isfield(calculations,'SnappedPAP'))
    plotcount=1;
    tempdate=timetablePrimary.Date(1)+minutes(0:numel( calculations.SnappedPAP)-1);
 set(layout.pprofiles{plotcount}, 'XData', tempdate, 'YData', calculations.SnappedPAP);
 endxlim=endxlim+minutes(5);
end
end
   
   
%% candle 
%%tic;
try
    if (looperEngine.graph.showSections(9)==1)
cndl5layout(timetablePrimary(genericrange,:),layout.candleplotformat);

%cndl4(timetablePrimary(genericrange,:));
    end
catch exception
    dumpReport('error.log', exception)
end

%%ticgcndl=toc


try
  layout.ax{2}.XLim=([dsample(1)-seconds(30) endxlim]);

catch exception
dumpReport('error.log', exception)
end

%%tic;

maxvol=max(timetablePrimary.Volume);
%pvs_=(calculations.DirectionPrediction{2}.Condition | calculations.DirectionPrediction{1}.Condition).*timetablePrimary.Volume;
%pvs_(pvs_==0)=NaN;


%bar(dsample,timetablePrimary.Volume(genericrange),'g');
 set(layout.bar_lower1{1}, 'XData',dsample , 'YData', calculations.indicators{1}.lower.VolumeBuzzRatio(genericrange));

%bar(dsample,calculations.indicators{1}.lower.SellVolume(genericrange),'r');
set(layout.bar_lower1{2}, 'XData', dsample, 'YData',calculations.indicators{1}.lower.SellVolumeBuzzRatio(genericrange) );
%plot(dsample,pvs_(genericrange),'*b');
 %set(layout.p_lower1, 'XData', dsample, 'YData',pvs_(genericrange)./calculations.indicators{1}.lower.VolumeBuzz(genericrange) );
 set(layout.axlower{1}.Title,'String',['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);
%title(['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);

%%ticgvol=toc

%%tic
drawnow
%%ticgdraw=toc
%vertical_cursors;
end
catch exception
dumpReport('error.log', exception)
end
end