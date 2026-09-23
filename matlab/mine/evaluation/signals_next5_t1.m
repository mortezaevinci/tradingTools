function result=signals_next5_t1(params,calculations)
try
    
pbto=calculations.indicators{1}.eval.pbto;
pbto(end-5:end)=0;
psto=calculations.indicators{1}.eval.psto;
psto(end-5:end)=0;

dc=shift(params.TimeTables.Minute.Close,-5)-params.TimeTables.Minute.Close;

result.success_bto=(pbto>0).*dc;
result.success_sto=-(psto>0).*dc;

result.success=sum(result.success_bto)+sum(result.success_sto);
catch
   result.success=0; 
end
end