function layout=graphStrategy_t10(layout,looperEngine,params,calculations,result)
try
    pskip=0;
    pdraw=0;
if (~isempty(layout))
    if (params.doBookOnly==0)
    if (looperEngine.process.type==1)
    timetablePrimary=params.TimeTables.Day(end-90:end,:);
    end
    
   if (looperEngine.process.type==0)
    timetablePrimary=params.TimeTables.Minute;
    level_startdate=timetablePrimary.Date(1)-hours(4);
    level_enddate=timetablePrimary.Date(1)+hours(9);
    leveldate=[level_startdate level_enddate];
   end
   
     %;disp('graph');
     %;tic;
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

%;ticgrange=toc
    end
    
%;tic
if (looperEngine.graph.showSections(1)==1)
    try
[book,bid,ask,date]=readbookBn2(looperEngine,params.contract.FileSymbol);
midpoint=(bid+ask)/2;
if (~isempty(book))

if (datetime()-minutes(3)>date)
fc=[1 .5 .5];
else
fc=[0 0 0];
end

book=cleanbook(book,midpoint);
%profile(book(:,1),book(:,2));
set(layout.ax{1}.Title,'String',num2str(midpoint));
 set(layout.bar_profile, 'XData', book(:,2), 'YData', book(:,1),'EdgeColor',fc);
 set(layout.plot_profile,'XData',0,'YData',midpoint);

 if (params.doBookOnly==0)
 set(layout.ax{1},'YTickLabel',[]);
 end
end
 catch exception
dumpReport('error.log', exception)
 end
end

if (params.doBookOnly==1)
    layout.ax{1}.YLim=([midpoint*0.9 ,midpoint*1.1]);
%    drawnow;
    return;
end

%;ticgbook=toc

%axes(layout.ax{2});
%title([num2str(timetablePrimary.Close(end)) ' at ' datestr(timetablePrimary.Date(end))]);
set(layout.ax{2}.Title,'String',[num2str(timetablePrimary.Close(end)) ' at ' datestr(timetablePrimary.Date(end))]);
layout.ax{2}.YLim=([scale_min ,scale_max]);

%;tic
 try
if (looperEngine.graph.showSections(2)==1)
plotcount=1;
%layout.pmain{plotcount}=plot(dsample,timetablePrimary.Close(end)+rand(size(dsample)));
%set(layout.pmain{plotcount}, 'XData',dsample , 'YData', timetablePrimary.Close(end)+rand(size(dsample)));
%plotcount=plotcount+1;
for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.profilelvls)
   
 if (calculations.localOptimaProfile{j}.profilelvls(i)>scale_min && calculations.localOptimaProfile{j}.profilelvls(i)<scale_max)
 ydata1=calculations.localOptimaProfile{j}.profilelvls(i);
 crc=simplecrc(ydata1);
 
 if (crc~=layout.localOptimaProfile{plotcount}.crc)
%      disp('localptima');
 set(layout.localOptimaProfile{plotcount}.handle, 'XData', leveldate, 'YData', [ydata1,ydata1],'Color',calculations.localOptimaProfile{j}.color,'LineStyle',calculations.localOptimaProfile{j}.style,'LineWidth',min(4,calculations.localOptimaProfile{j}.width_profilelvls(i)));
  layout.localOptimaProfile{plotcount}.crc=crc;
    pdraw=pdraw+1;
 else
     pskip=pskip+1;
 end
  plotcount=plotcount+1;
 end
end
end
     end
 catch exception
dumpReport('error.log', exception)
 end
%;ticgprofilelvls=toc

%;tic
    try
        if (looperEngine.graph.showSections(3)==1)
plotcount=1;
for i=1:numel(calculations.levels.values)
    if (calculations.levels.values(i)>scale_min && calculations.levels.values(i)<scale_max)
    ydata1=calculations.levels.values(i);
    crc=simplecrc(ydata1);
    if (crc~=layout.levels{plotcount}.crc)
%         disp('levels');
  set(layout.levels{plotcount}.handle, 'XData', leveldate, 'YData', [ydata1,ydata1],'Color',calculations.levels.color{i},'LineStyle',calculations.levels.style{i},'LineWidth',calculations.levels.width(i),'DisplayName',calculations.levels.name{i});
  layout.levels{plotcount}.crc=crc;
   pdraw=pdraw+1;
 else
     pskip=pskip+1;
    end
   plotcount=plotcount+1;
    end
end
        end
 catch exception
dumpReport('error.log', exception)
    end
%;ticglevels=toc
%;tic;
    try
        if (looperEngine.graph.showSections(4)==1)
plotcount=1;
for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.localoptima)
    try
        vsample=calculations.localOptimaProfile{j}.localoptima{i};%=(genericrange);
         onlyvals=vsample>0;
         ydata=vsample(onlyvals);
         crc=simplecrc(ydata);
         if (crc~=layout.localOptimaTrend{plotcount}.crc)
%              disp('local optima lines');
        set(layout.localOptimaTrend{plotcount}.handle, 'XData', timetablePrimary.Date(onlyvals), 'YData', ydata,'LineWidth',j);
        layout.localOptimaTrend{plotcount}.crc=crc;
         pdraw=pdraw+1;
 else
     pskip=pskip+1;
         end
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
    
    %;ticglocaloptima=toc
%;tic;
    try
plotcount=1;
%% show upper indicators
 
for i=1:numel(params.upper_indicators)
 ydata=calculations.indicators{1}.upper(genericrange,params.upper_indicators{i}).Variables;
 crc=simplecrc(ydata);
 if (crc~=layout.indicators{plotcount}.crc)
%      disp('upper ind');
     set(layout.indicators{plotcount}.handle, 'XData',dsample , 'YData', ydata);
     layout.indicators{plotcount}.crc=crc;
      pdraw=pdraw+1;
 else
     pskip=pskip+1;
 end
  plotcount=plotcount+1;   
end
 catch exception
dumpReport('error.log', exception)
    end
    %;ticgupper=toc
    
%%prep entries
%;tic
try
    if (looperEngine.graph.showSections(5)==1)
pbto=calculations.indicators{1}.eval.pbto(genericrange);
bto=find(pbto);
psto=calculations.indicators{1}.eval.psto(genericrange);
sto=find(psto);

%% entries
plotcount=1;
ydata=pbto(bto)*1.001;
crc=simplecrc(ydata);
if (crc~=layout.entries{plotcount}.crc)
%     disp('entrues bto');
 set(layout.entries{plotcount}.handle, 'XData',dsample(bto) , 'YData',ydata );
 layout.entries{plotcount}.crc=crc;
  pdraw=pdraw+1;
 else
     pskip=pskip+1;
end
 plotcount=plotcount+1;
 
 ydata=psto(sto)*0.999;
 crc=simplecrc(ydata);
if (crc~=layout.entries{plotcount}.crc)
%     disp('entres sto');
 set(layout.entries{plotcount}.handle, 'XData',dsample(sto), 'YData', ydata);
  layout.entries{plotcount}.crc=crc;
   pdraw=pdraw+1;
 else
     pskip=pskip+1;
end
 plotcount=plotcount+1;
    end
 catch
end
%;ticgentries=toc

%% exists
%;tic;
try
if (looperEngine.graph.showSections(6)==1)
pstc=calculations.indicators{1}.eval.pstc(genericrange);
stc=find(pstc);
pbtc=calculations.indicators{1}.eval.pbtc(genericrange);
btc=find(pbtc);

%% exits grap
plotcount=1;
ydata=pstc(stc);
crc=simplecrc(crc);
if (crc~=layout.exits{plotcount}.crc)
%     disp('exit stc');
 set(layout.exits{plotcount}.handle, 'XData',dsample(stc) , 'YData', ydata);
 layout.exits{plotcount}.crc=crc;
 pdraw=pdraw+1;
 else
     pskip=pskip+1;
end
 plotcount=plotcount+1;
 ydata=pbtc(btc);
 crc=simplecrc(crc);
if (crc~=layout.exits{plotcount}.crc)
%     disp('exit btc');
 set(layout.exits{plotcount}.handle, 'XData',dsample(btc), 'YData', ydata);
  layout.exits{plotcount}.crc=crc;
  pdraw=pdraw+1;
 else
     pskip=pskip+1;
end
 plotcount=plotcount+1;
    end
catch exception
dumpReport('error.log', exception)
end
%;ticgexits=toc
%% net entries
%;tic;
try
if (looperEngine.graph.showSections(7)==1 && looperEngine.net.use>0)
nbto=find(calculations.net.DirectionPrediction{1}.final(genericrange)>0);
nsto=find(calculations.net.DirectionPrediction{2}.final(genericrange)>0);

closesample=timetablePrimary.Close(genericrange);

if (looperEngine.net.use==1)
plotcount=1;
 ydata=closesample(nbto)+scale_d*.08;
 crc=simplecrc(ydata);
 if (crc~=layout.netentries{plotcount}.crc)
%      disp('net bto');
 set(layout.netentries{plotcount}.handle, 'XData',dsample(nbto), 'YData', ydata);
 layout.netentries{plotcount}.crc=crc;
 pdraw=pdraw+1;
 else
     pskip=pskip+1;
 end
 plotcount=plotcount+1;
 ydata=closesample(nsto)-scale_d*.08;
 crc=simplecrc(ydata);
 if (crc~=layout.netentries{plotcount}.crc)
%      disp('net sto');
 set(layout.netentries{plotcount}.handle, 'XData',dsample(nsto), 'YData', ydata);
 
  layout.netentries{plotcount}.crc=crc;
  pdraw=pdraw+1;
 else
     pskip=pskip+1;
 end
 plotcount=plotcount+1;
end
end

catch exception
dumpReport('error.log', exception) 
end
 %;ticgnetentries=toc
 
%% book levels
%;tic;
try
if (looperEngine.graph.showSections(8)==1)
if (isfield(params,'marketdata'))
    if (~isempty(params.marketdata))
plotcount=1;
ydata=shiftpad(params.marketdata.BookLevels(:,1),0);
  yind=find(~isnan(ydata));
   ydata_=ydata(yind);
crc=simplecrc(ydata_);
if (crc~=layout.booklvls{plotcount}.crc)
%     disp('book up');
  
 set(layout.booklvls{plotcount}.handle, 'XData',params.marketdata.Date(yind) , 'YData', ydata_);
 layout.booklvls{plotcount}.crc=crc;
 pdraw=pdraw+1;
 else
     pskip=pskip+1;
end
 plotcount=plotcount+1;
 ydata=shiftpad(params.marketdata.BookLevels(:,2),0) ;
 yind=find(~isnan(ydata));
 ydata_=ydata(yind);
crc=simplecrc(ydata_);
if (crc~=layout.booklvls{plotcount}.crc)
%     disp('book down');
    
 set(layout.booklvls{plotcount}.handle, 'XData',params.marketdata.Date(yind), 'YData',ydata_);
  layout.booklvls{plotcount}.crc=crc;
  pdraw=pdraw+1;
 else
     pskip=pskip+1;
end
 plotcount=plotcount+1;
 
    end
end
end
catch exception
dumpReport('error.log', exception)
end
   %;ticgbooklevels=toc 

   
   
%% guides
%;tic;
try
if (looperEngine.graph.showSections(10)==1)
if (isfield(calculations,'plotPointsW'))
plotcount=1;
gyi=find(~isnan(calculations.plotPointsW.gy));
crc=simplecrc(calculations.plotPointsW.gy(gyi));
if (crc~=layout.guides{plotcount}.crc)
 set(layout.guides{plotcount}.handle, 'XData',calculations.plotPointsW.gx , 'YData', calculations.plotPointsW.gy);
 layout.guides{plotcount}.crc=crc;
 pdraw=pdraw+1;
 else
  pskip=pskip+1;
end
 plotcount=plotcount+1;
 ryi=find(~isnan(calculations.plotPointsW.ry));
crc=simplecrc(calculations.plotPointsW.ry((gyi)));
if (crc~=layout.guides{plotcount}.crc)
%     disp('book down');
    
 set(layout.guides{plotcount}.handle, 'XData',calculations.plotPointsW.rx, 'YData',calculations.plotPointsW.ry);
  layout.guides{plotcount}.crc=crc;
  pdraw=pdraw+1;
 else
     pskip=pskip+1;
end
 plotcount=plotcount+1;
 
end
end
catch exception
dumpReport('error.log', exception)
end
   %;ticgbooklevels=toc  
   
   
endxlim=dsample(end)+seconds(30);
%% profiles

if (isfield(calculations,'SnappedPAP'))
    plotcount=1;
    
    tempdate=timetablePrimary.Date(1)+minutes(0:numel( calculations.SnappedPAP)-1);
    ydata=calculations.SnappedPAP;
    crc=simplecrc(ydata);
    if (crc~=layout.profiles{plotcount}.crc)
%         disp('pap');
   set(layout.profiles{plotcount}.handle, 'XData', tempdate, 'YData', ydata);
   layout.profiles{plotcount}.crc=crc;
   pdraw=pdraw+1;
 else
     pskip=pskip+1;
    end
   
   if (layout.extended==1)
 endxlim=tempdate(end)+seconds(30);
else
 endxlim=endxlim+minutes(5);
end
end
   
   
%% candle 
%;tic;
try
if (looperEngine.graph.showSections(9)==1)
   % axes(layout.ax{2});
   % hold on;
%layout.candleplotformat=cndl5(timetablePrimary(genericrange,:));%,layout.candleplotformat);

 
cndl5layout(timetablePrimary(genericrange,:),layout.candleplotformat);


    end
catch exception
    dumpReport('error.log', exception)
end

%;ticgcndl=toc


try
  layout.ax{2}.XLim=([dsample(1)-seconds(30) endxlim]);

catch exception
dumpReport('error.log', exception)
end

%;tic;

maxvol=max(timetablePrimary.Volume);
%pvs_=(calculations.DirectionPrediction{2}.Condition | calculations.DirectionPrediction{1}.Condition).*timetablePrimary.Volume;
%pvs_(pvs_==0)=NaN;
clear ydata;
ydata=calculations.indicators{1}.lower.VolumeBuzzRatio(genericrange);
 crc=simplecrc(ydata);
if (crc~=layout.bar_lower1{1}.crc)
%bar(dsample,timetablePrimary.Volume(genericrange),'g');
 set(layout.bar_lower1{1}.handle, 'XData',dsample , 'YData', ydata);
layout.bar_lower1{1}.crc=crc;
end
clear ydata;
ydata=calculations.indicators{1}.lower.SellVolumeBuzzRatio(genericrange);
 crc=simplecrc(ydata);
if (crc~=layout.bar_lower1{2}.crc)
%bar(dsample,calculations.indicators{1}.lower.SellVolume(genericrange),'r');
set(layout.bar_lower1{2}.handle, 'XData', dsample, 'YData',ydata );
layout.bar_lower1{2}.crc=crc;
end

%plot(dsample,pvs_(genericrange),'*b');
 %set(layout.p_lower1, 'XData', dsample, 'YData',pvs_(genericrange)./calculations.indicators{1}.lower.VolumeBuzz(genericrange) );
 set(layout.axlower{1}.Title,'String',['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);
%title(['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);

%;ticgvol=toc
% disp(['pdraw=',num2str(pdraw),' pskip=', num2str(pskip)]);
%;tic
%drawnow
%;ticgdraw=toc
%vertical_cursors;
end
catch exception
dumpReport('error.log', exception)
end
end