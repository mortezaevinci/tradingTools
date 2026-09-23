function result=signals_max10_t1(params,calculations)

forwardWindow=15;
mmax=100*(movmax(params.TimeTables.Minute.Close,[0 forwardWindow])-params.TimeTables.Minute.Close)./params.TimeTables.Minute.Close;
mmin=100*(movmin(params.TimeTables.Minute.Close,[0 forwardWindow])-params.TimeTables.Minute.Close)./params.TimeTables.Minute.Close;


result.success_bto=(calculations.indicators{1}.eval.pbto>0).*mmax;
result.success_sto=-(calculations.indicators{1}.eval.psto>0).*mmin;

result.success=sum(result.success_bto)+sum(result.success_sto);

end