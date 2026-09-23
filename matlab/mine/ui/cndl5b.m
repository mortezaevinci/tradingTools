%table.Date,table.High,table.Low,table.Open,table.Close
function plotformat=cndl5(table)
try
%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=table.Close-table.Open;

timedata=reshape([table.Date,table.Date,table.Date]',3*size(table.Date,1),1);
linedata=reshape([table.Low,table.High,nan(size(table.Date))]',3*size(table.Date,1),1);


   plotformat.plothighlow.handle=plot(timedata,linedata,'color','k');%  line([table.Date table.Date]',[table.Low table.High]','Color','black');
   plotformat.plothighlow.crc=0;
hold on
%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
     
plotformat.bar_low.handle = bar(table.Date(n),[table.Close(n) -d(n)],0.95,'stacked', 'FaceColor','flat');%,'ButtonDownFcn',@candleBarPlotCallback,'XLimInclude','off','YLimInclude','off');
%ba(1).CData = [0.3 0.3 0.7];
plotformat.bar_low.handle(2).CData = [1 0.5 0.5];
plotformat.bar_low.handle(2).LineWidth=1;
plotformat.bar_low.handle(2).EdgeColor=[.8 0.5 0.5];
alpha(plotformat.bar_low.handle(1),0);
plotformat.bar_low.handle(1).EdgeColor = 'none';
plotformat.bar_low.crc=0;

n=find(d>=0);
plotformat.bar_high.handle = bar(table.Date(n),[table.Open(n) d(n)],0.95,'stacked', 'FaceColor','flat');%,'ButtonDownFcn',@candleBarPlotCallback,'XLimInclude','off','YLimInclude','off');
%ba(1).CData = [0.3 0.3 0.7];
plotformat.bar_high.handle(2).CData = [0.5 1 0.5];
plotformat.bar_high.handle(2).LineWidth=1;
plotformat.bar_high.handle(2).EdgeColor=[0.5 0.8 0.5];
alpha(plotformat.bar_high.handle(1),0);
plotformat.bar_high.handle(1).EdgeColor = 'none';
plotformat.bar_high.crc=0;
hold off
catch exception
    exception
end
end