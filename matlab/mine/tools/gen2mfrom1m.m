function table2m=gen2mfrom1m(table,n)
try

    
table2m=table;

if (n>=size(table,1))
    return;
end

table2m.High=movmax(table.High,[n 0]);
table2m.Low=movmin(table.Low,[n 0]);
%table2m.High(n:end)=max([table.High(n:end),table.High(1:end-n)],[],2);
%table2m.Low(2:end)=min([table.Low(2:end),table.Low(1:end-1)],[],2);
table2m.Open((1+n):end)=table.Open(1:end-n);
table2m.Volume((1+n):end)=(table.Volume(1:end-n)+table.Volume((1+n):end))/2;
catch exception
dumpReport('error.log', exception)
table2m=table;
end
end