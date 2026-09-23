%% prepare 
 ncommon=numel(commonticks);
ncontracts=numel(looperEngine.contracts);

for si=1:ncontracts
    mainticks{si}.params=tempsymbol.params;
    mainticks{si}.params.contract=looperEngine.contracts{si};
    mainticks{si}.params.si=si;
end
