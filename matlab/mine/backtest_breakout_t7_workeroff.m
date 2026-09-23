pexists=0;
if (exist('parf_loop_calculations'))
if (~isempty(parf_loop_calculations) || strcmp(parf_loop_calculations.State,'running'))
pexists=1;
   
end
end

 loop_calculations_run=0;

if (pexists==1)
     pause(2);
   try
cancel(parf_loop_calculations);
catch 
    
end
end


try
cancel(parf_loop_calculations);
catch 
    
end

try
   stop(drawtimer); 
catch
    
end