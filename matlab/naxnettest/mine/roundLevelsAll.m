function [hlvls llvls]=roundLevels(table)
try
low=table.Open(1)*.8;
high=table.Open(1)*1.2;

  if (table.Open(1)<20)
      rval(2)=1;
      rval(1)=0.5;
  elseif (table.Open(1)<100)
      rval(2)=5;
      rval(1)=1;
  elseif (table.Open(1)<500)
      rval(2)=10;
      rval(1)=5;
  elseif (table.Open(1)<1000)
      rval(2)=20;
      rval(1)=10;
  elseif (table.Open(1)<5000)
      rval(2)=50;
      rval(1)=10;
  elseif (table.Open(1)<500000)
      rval(2)=5000;
      rval(1)=1000;
  else
      rval(2)=50000;
      rval(1)=10000; 
  end
  
for rr=1:2
  rhigh=ceil(table.Open(1)/rval(rr))*rval(rr);
  hlvls{rr} =rhigh:rval(rr):high;
  rlow=floor(table.Open(1)/rval(rr))*rval(rr);
  llvls{rr}=rlow:-rval(rr):low;
end
catch exception
getReport(exception,'extended','hyperlinks','off')
hlvls={};
llvls={};
end
end