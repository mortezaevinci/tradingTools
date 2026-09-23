function dcs=largedcandle(table)
try 

dem=1./(table.High-table.Low);
dem(isnan(dem))=0;
dem(isinf(dem))=0;
dcs.close=(2*table.Close-table.Low-table.High).*dem;
dcs.open=(table.High+table.Low-2*table.Open).*dem;
dcs.total=(table.Close-table.Open).*dem;
dcs.fight=dcs.close-dcs.open;
catch exception
    getReport(exception,'extended','hyperlinks','off')
   dcs.open= zeros(size(table.Volume)); ;
   dcs.close= zeros(size(table.Volume)); ;
   dcs.total= zeros(size(table.Volume)); ;
   dcs.fight= zeros(size(table.Volume)); ;
    
end
end