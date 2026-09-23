
table=TimeTables.Minute;

table2m=table;
table2m.High(2:end)=max([table.High(2:end),table.High(1:end-1)],[],2);
table2m.Low(2:end)=min([table.Low(2:end),table.Low(1:end-1)],[],2);
table2m.Open(2:end)=table.Open(1:end-1);
