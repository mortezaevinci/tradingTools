function [hlvls llvls]=roundLevels(table)
try
low=table.Open(1)*.8;
high=table.Open(1)*1.2;

rval=roundLevelsLogic(table.Open(1));
  
for rr=1:2
  rhigh=ceil(table.Open(1)/rval(rr))*rval(rr);
  hlvls{rr} =rhigh:rval(rr):high;
  rlow=floor(table.Open(1)/rval(rr))*rval(rr);
  llvls{rr}=rlow:-rval(rr):low;
end
catch exception
dumpReport('error.log', exception)
hlvls={};
llvls={};
end
end