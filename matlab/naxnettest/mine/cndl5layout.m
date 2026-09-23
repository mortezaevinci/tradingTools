%table.Date,table.High,table.Low,table.Open,table.Close
function cndl5layout(table,plotformat)

%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=table.Close-table.Open;

  timedata=reshape([table.Date,table.Date,table.Date]',3*size(table.Date,1),1);
linedata=reshape([table.Low,table.High,nan(size(table.Date))]',3*size(table.Date,1),1);


set(plotformat.plothighlow,'XData',timedata,'YData',linedata);

%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
     
%set(plotformat.bar_low,'XData', [table.Date(n) table.Data(n)],'YData',[table.Close(n) -d(n)]);
%set(plotformat.bar_low,'XData', table.Date(n),'YDATA',-d(n) );

set(plotformat.bar_low(1),'XData', [table.Date(1)-minutes(2);table.Date(1)-minutes(1);table.Date(n)],'YDATA',[0;0;table.Close(n)],'CData',[1,0,0]);
set(plotformat.bar_low(2),'XData', [table.Date(1)-minutes(2);table.Date(1)-minutes(1);table.Date(n)],'YDATA',[0;0;-d(n)],'CData',[1,0,0]);
%plotformat.bar_low = bar(table.Date(n),[table.Close(n) -d(n)],0.95,'stacked', 'FaceColor','flat');

n=find(d>=0);
set(plotformat.bar_high(1),'XData',[table.Date(1)-minutes(2);table.Date(1)-minutes(1);table.Date(n)] ,'YDATA', [0;0;table.Open(n)],'CData',[0 1 0]);
set(plotformat.bar_high(2),'XData',[table.Date(1)-minutes(2);table.Date(1)-minutes(1);table.Date(n)] ,'YDATA', [0;0;d(n)],'CData',[0 1 0]);
%plotformat.bar_high = bar(table.Date(n),[table.Open(n) d(n)],0.95,'stacked', 'FaceColor','flat');

hold off