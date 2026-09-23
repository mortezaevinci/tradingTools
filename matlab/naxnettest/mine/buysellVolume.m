%type=0 is total
function [buy,sell]=buysellVolume(table,type)
try
    buy=table.Volume.*(table.Close-table.Low+table.High-table.Open)/2./(table.High-table.Low);
    sell=table.Volume.*(-table.Close-table.Low+table.High+table.Open)/2./(table.High-table.Low);
catch exception
getReport(exception,'extended','hyperlinks','off')
end
end