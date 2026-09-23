pexists=0;
if (exist('parf_ib_realtime'))
if (~isempty(parf_ib_realtime) || strcmp(parf_ib_realtime.State,'running'))
pexists=1;
   
end
end

 ib_realtime_run=0;

if (pexists==1)
     pause(2);
    try
cancel(parf_ib_realtime);
catch 
    
end
end


try
cancel(parf_ib_realtime);
catch 
    
end