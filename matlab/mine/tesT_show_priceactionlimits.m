base='Z:\My files\Project trading\traderdata\data\';

date0=lastBusDay()
datatype='daily 1y';
filesymbol='FLY';

fn=getDataFileName(base,filesymbol,date0,datatype);
load(fn);

ttd=table2timetable(td);

figure
ax=cndlv(ttd);
hold (ax{1},'on');
hold (ax{2},'on');
vertical_cursors;

levelsfirst=1;
levelslast=200;%numel(ttd.Date)


ttdde=ttd.Date(levelslast);
for i=levelsfirst:levelslast
   plot(ax{1},[ttd.Date(1),ttdde],[ttd.High(i) ttd.High(i)]); 
   plot(ax{1},[ttd.Date(1),ttdde],[ttd.Low(i) ttd.Low(i)]); 
   plot(ax{1},[ttd.Date(1),ttdde],[ttd.Open(i) ttd.Open(i)]); 
   plot(ax{1},[ttd.Date(1),ttdde],[ttd.Close(i) ttd.Close(i)]); 
    
end