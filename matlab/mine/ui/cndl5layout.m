%table.Date,table.High,table.Low,table.Open,table.Close
function cndl5layout(table,plotformat)
try
%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=table.Close-table.Open;

timedata=reshape([table.Date,table.Date,table.Date]',3*size(table.Date,1),1);
linedata=reshape([table.Low,table.High,nan(size(table.Date))]',3*size(table.Date,1),1);

crc=simplecrc(linedata);
 if (crc~=plotformat.plothighlow.crc)
set(plotformat.plothighlow.handle,'XData',timedata,'YData',linedata);
plotformat.plothighlow.crc=crc;
  end

ddate=table.Date(2)-table.Date(1);

%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
   n=find(d<0);
 crc=simplecrc(table.Close(n));
 if (crc~=plotformat.bar_low.crc)   
  xdata=[table.Date(1)-ddate*(2);table.Date(1)-ddate*(1);table.Date(n)];
set(plotformat.bar_low.handle(1),'XData',xdata ,'YDATA',[0;0;table.Close(n)],'CData',[0.8,0,0]);
set(plotformat.bar_low.handle(2),'XData', xdata,'YDATA',[0;0;-d(n)],'CData',[0.8,0,0]);
plotformat.bar_low.crc=crc;
 end
 n=find(d>=0);
 crc=simplecrc(table.Open(n));
 if (crc~=plotformat.bar_high.crc)   

 xdata=[table.Date(1)-ddate*(2);table.Date(1)-ddate*(1);table.Date(n)];
set(plotformat.bar_high.handle(1),'XData',xdata ,'YDATA', [0;0;table.Open(n)],'CData',[0 0.8 0]);
set(plotformat.bar_high.handle(2),'XData',xdata ,'YDATA', [0;0;d(n)],'CData',[0 0.8 0]);
plotformat.bar_high.crc=crc;
 end

catch exception
   dumpReport('error.log', exception) 
    
end