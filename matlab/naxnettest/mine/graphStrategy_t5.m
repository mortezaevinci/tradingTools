function n=graphStrategy(panel,params,calculations,result)
if (isvalid(panel))
     %;disp('graph');
     %%;tic;
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
%%;ticgprep=toc

%figure(gcf);
tlt=tiledlayout(panel,10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";
 %;disp('books');
 %%;tic;
book=readbook(params.symbol);
if (~isempty(book))

book=cleanbook(book,params.TimeTables.Minute.Close(end));
ax{1}=nexttile(tlt,[8,3]);
profile(book(:,1),book(:,2));
ax{2}=nexttile(tlt,[8 7]);
linkaxes([ax{1} ax{2}],'y');
set(ax{2},'ytick',[])
nexttile(tlt,[2 3]);
axlower{1}=nexttile(tlt,[2 7]);
else
ax{2}=nexttile(tlt,[8 10]); 
axlower{1}=nexttile(tlt,[2 10]);
end
%%;ticgprofile=toc
%%;tic;
axes(ax{2});
title([num2str(params.TimeTables.Minute.Close(end)) ' at ' datestr(params.TimeTables.Minute.Date(end))]);
ylim([scale_min ,scale_max])
%%;ticgax2=toc
%%;tic;
hold on;
 %;disp('profile');
for j=1:numel(calculations.localOptimaProfile)
for i=1:numel(calculations.localOptimaProfile{j}.profilelvls)
    %if (calculations.localOptimaProfile{j}.profilelvls(i)>scale_min && calculations.localOptimaProfile{j}.profilelvls(i)<scale_max)
 plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.localOptimaProfile{j}.profilelvls(i),calculations.localOptimaProfile{j}.profilelvls(i)],calculations.localOptimaProfile{j}.color,'linewidth',min(4,calculations.localOptimaProfile{j}.width_profilelvls(i)));
    %end
end
end
%%;ticglocaloptima1=toc
xlim([dsample(1) dsample(end)]);
%%;tic;
for i=1:numel(calculations.levels.values)
    if (calculations.levels.values(i)>=scale_min && calculations.levels.values(i)<=scale_max)
 plot([params.TimeTables.Minute.Date(genericrange(1)), params.TimeTables.Minute.Date(end)],[calculations.levels.values(i),calculations.levels.values(i)],calculations.levels.color{i},'linewidth',calculations.levels.width(i));
    end
end


plot(dsample,calculations.indicators{1}.eval.pbto(genericrange)*1.001,'c^','linewidth',4);
plot(dsample,calculations.indicators{1}.eval.psto(genericrange)*0.999,'cv','linewidth',4);
%%;ticglvls=toc

%% show upper indicators
%%;tic;
 %;disp('upper indicators');
for i=1:numel(params.upper_indicators)
   plot(dsample,calculations.indicators{1}.upper(genericrange,params.upper_indicators{i}).Variables,'k--','linewidth',1);
    
end
%%;ticgindicators=toc

%% candle 
%%;tic;
cndl4(params.TimeTables.Minute(genericrange,:));
%%;ticgcandle=toc
grid on;
hold on;
 pbto=calculations.indicators{1}.eval.pbto(genericrange);
bto=find(pbto);
psto=calculations.indicators{1}.eval.psto(genericrange);
sto=find(psto);
text(dsample(bto),calculations.indicators{1}.eval.pbto(bto)*1.001,num2str(calculations.up.final(bto)));
text(dsample(sto),calculations.indicators{1}.eval.psto(sto)*0.999,num2str(calculations.dn.final(sto)));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.pbto*1.01,num2str(result.success_bto));
%text(params.TimeTables.Minute.Date,calculations.indicators{1}.eval.psto*.99,num2str(result.success_sto));
%%;ticgorders=toc
%%;tic;
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
%%;ticlocaloptima2=toc
hold off;
 %;disp('lower');
 %%;tic;
axes(axlower{1});
maxvol=max(params.TimeTables.Minute.Volume);
%pvs_=(calculations.up.cond | calculations.dn.cond).*params.TimeTables.Minute.Volume;
%pvs_(pvs_==0)=NaN;
%%;ticgvolpprep=toc
%%;tic
bar(dsample,params.TimeTables.Minute.Volume(genericrange),'g');
%plot(dsample,params.TimeTables.Minute.Volume(genericrange),'g');
grid on;
hold on;
bar(dsample,calculations.sellv(genericrange),'r');
%plot(dsample,calculations.sellv(genericrange),'r');
%%;ticgvolpbars=toc
%%;tic;
%plot(dsample,pvs_(genericrange),'*b');
title(['maxvol=' fliplr(regexprep(fliplr(num2str(maxvol)),'\d{3}(?=\d)', '$0,'))]);
hold off;
%%;ticgvolpplottitle=toc
linkaxes([ax{2} axlower{1}],'x');
%vertical_cursors;
%%%;ticgraph=toc
end
end