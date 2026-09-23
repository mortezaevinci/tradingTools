%table.Date,table.High,table.Low,table.Open,table.Close
function plotformat=cndl2(table)

%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=table.Close-table.Open;

   plotformat.line=line([table.Date table.Date]',[table.Low table.High]','Color','black');
hold on
%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
     
plotformat.bar_low = bar(table.Date(n),[table.Close(n) -d(n)],0.95,'stacked', 'FaceColor','flat');
%ba(1).CData = [0.3 0.3 0.7];
plotformat.bar_low(2).CData = [1 0 0];
plotformat.bar_low(2).LineWidth=1;
plotformat.bar_low(2).EdgeColor='black';
alpha(plotformat.bar_low(1),0);
plotformat.bar_low(1).EdgeColor = 'none';
n=find(d>=0);

plotformat.bar_high = bar(table.Date(n),[table.Open(n) d(n)],0.95,'stacked', 'FaceColor','flat');
%ba(1).CData = [0.3 0.3 0.7];
plotformat.bar_high(2).CData = [0 1 0];
plotformat.bar_high(2).LineWidth=1;
plotformat.bar_high(2).EdgeColor='black';
alpha(plotformat.bar_high(1),0);
plotformat.bar_high(1).EdgeColor = 'none';
hold off

end