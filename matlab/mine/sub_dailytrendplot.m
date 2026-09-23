figure
hold off;

l2=numel(params.TimeTables.Day.Date);
l1=max(1,l2-30);
range=l1:l2;

cndl5(params.TimeTables.Day(range,:));
hold on;
plot(params.TimeTables.Day(range,:).Date,params.TimeTables.Day(range,:).High.*updays(range),'b^','linewidth',2,'markersize',2);
plot(params.TimeTables.Day(range,:).Date,params.TimeTables.Day(range,:).High.*dndays(range),'bv','linewidth',2,'markersize',2);
if (~isempty(allgoodconditions{2}))
result=eval(allgoodconditions{2});
signalup=(params.TimeTables.Day(range,:).Low-0.5) .*(result(range));
plot(params.TimeTables.Day.Date(range,:),signalup,'g*','linewidth',5,'markersize',5);
end

if (~isempty(allgoodconditions{1}))
result=eval(allgoodconditions{1});
signaldn=(params.TimeTables.Day(range,:).Low-1) .*(result(range));
plot(params.TimeTables.Day(range,:).Date,signaldn,'r*','linewidth',5,'markersize',5);
end

title([symbol]);