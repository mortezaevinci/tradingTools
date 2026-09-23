%% prepare 
 ncommon=numel(commonticks);
nsymbols=numel(looperParams.symbols);

calculations=cell(1,nsymbols);
result=cell(1,nsymbols);
params=cell(1,nsymbols);


for si=1:nsymbols
    mainticks{si}.params=tempsymbol.params;
    mainticks{si}.params.symbol=looperParams.symbols{si};
    
end

for si=1:nsymbols
if (looperParams.train>0)
trainingdata{si}.net=net_init_t1();
end
end
