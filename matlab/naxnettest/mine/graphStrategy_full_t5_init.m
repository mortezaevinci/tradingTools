function layout=graphStrategy_full_t6_init(panel,params)
if (isvalid(panel))
layout=[];
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

layout.bar_profile=bar(1,1);

layout.ax{2}=nexttile(tlt,[7 9]);
linkaxes([ax{1} ax{2}],'y');
ylim([scale_min ,scale_max])
hold on;
%plots
for i=1:50
   layout.p_under{i}=plot(0,0); 
    
end

%% candle 
layout.candleplotformat=cndl4(params.TimeTables.Minute(genericrange,:));
grid on;
hold on;

for i=1:50
   layout.p_over{i}=plot(0,0); 
    
end

hold off;

nexttile(tlt,[1 1]);
layout.axlower{1}=nexttile(tlt,[1 9]);
layout.bar_lower1{1}=bar(dsample,params.TimeTables.Minute.Volume(genericrange),'g');
grid on;
hold on;
layout.bar_lower1{2}=bar(dsample,calculations.sellv(genericrange),'r');
p_lower1=plot(dsample,pvs_(genericrange),'*b');
hold off;



for axi=1:2
nexttile(tlt,[1 1]);
layout.axlower{axi+1}=nexttile([1 9]);
hold on;
for i=1:10
   layout.p_lowerx{i}=plot(0,0); 
end
grid on;
hold off;
end
linkaxes([layout.ax{2} layout.axlower{1} layout.axlower{2} layout.axlower{3}],'x');
drawnow
%vertical_cursors;
end
end