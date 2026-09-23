function dailytrendplot_func(params,allgoodconditions)

figure
cndl5(params.TimeTables.Day);
hold on;
plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*updays,'b^','linewidth',2,'markersize',2);
plot(params.TimeTables.Day.Date,params.TimeTables.Day.High.*dndays,'bv','linewidth',2,'markersize',2);
if (~isempty(allgoodconditions))
result=eval(allgoodconditions);
signalup=(params.TimeTables.Day.Low-0.5) .*(result);
plot(params.TimeTables.Day.Date,signalup,'g*','linewidth',5,'markersize',5);
end


end