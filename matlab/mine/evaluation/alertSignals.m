function somethingtodo=alertSignals(params,calculations)
somethingtodo=datetime('2020-01-01');
try
searchlen=0; %+
%alarm only the last one search len 0

upc_last=calculations.DirectionPrediction{1}.final(end-searchlen:end);
dnc_last=calculations.DirectionPrediction{2}.final(end-searchlen:end);
date_last=params.TimeTables.Minute.Date(end-searchlen:end);

btos=upc_last>0 & dnc_last==0;
stos=dnc_last>0 & upc_last==0;
conflict=upc_last>0 &dnc_last>0;

for i=find(stos)'
disp(['STO ' params.contract.Symbol]);
disp(['at:' datestr(date_last(stos)) ' strategy type=' num2str(dnc_last(stos))])
end
for i=find(btos)'
disp(['BTO ' params.contract.Symbol]);
disp(['at:' datestr(date_last(i)) ' strategy type=' num2str(upc_last(i))])
end
for i=find(conflict)' 
disp(['CONFLICT ' params.contract.Symbol]);
disp(['at:' datestr(date_last(conflict)) ' STO type=' num2str(dnc_last(conflict)) ' BTO type=' num2str(upc_last(conflict))])
end
if ((sum(upc_last)+sum(dnc_last)>0))
somethingtodo=datetime();
else
somethingtodo=datetime('2020-01-01');
end
catch exception
   dumpReport('error.log', exception) 
end
end