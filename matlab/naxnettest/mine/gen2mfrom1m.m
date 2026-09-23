function table2m=gen2mfrom1m(table)
try
table2m=table;
table2m.High(2:end)=max([table.High(2:end),table.High(1:end-1)],[],2);
table2m.Low(2:end)=min([table.Low(2:end),table.Low(1:end-1)],[],2);
table2m.Open(2:end)=table.Open(1:end-1);
table2m.Volume(2:end)=(table.Volume(1:end-1)+table.Volume(2:end))/2;
catch exception
getReport(exception,'extended','hyperlinks','off')
table2m=table;
end
end