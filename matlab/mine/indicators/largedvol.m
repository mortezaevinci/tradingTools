function dvs=largedvol(table,multiplier)
 try
 if ((size(table,1))<2)
  comp=table.Volume(1);        
 else
  comp=sum(table.Volume(1:2))/2;
     
 end
comp=comp*multiplier;
  
dem=table.Volume./(table.High-table.Low)/comp;
dem(isnan(dem))=0;
dem(isinf(dem))=0;
dvs.close=(2*table.Close-table.Low-table.High).*dem;
dvs.open=(table.High+table.Low-2*table.Open).*dem;
dvs.total=(table.Close-table.Open).*dem;
dvs.fight=dvs.close-dvs.open;
 catch exception
     
  dvs.close=  zeros(size(table.Volume)); 
  dvs.open= zeros(size(table.Volume)); 
  dvs.total= zeros(size(table.Volume)); 
  dvs.fight= zeros(size(table.Volume)); 
 end
end