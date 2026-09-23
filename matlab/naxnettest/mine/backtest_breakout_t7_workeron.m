

if (exist('parf_loop_calculations'))
if (~isempty(parf_loop_calculations) || strcmp(parf_loop_calculations.State,'running'))
    cancel(parf_loop_calculations);
end
end

 ncommon=numel(commonticks);
nsymbols=numel(looperParams.symbols);
for si=1:nsymbols
   
    mainticks{si}.params=tempsymbol.params;
    mainticks{si}.params.symbol=looperParams.symbols{si};
end

parf_loop_calculations=parfeval(@loop_calculations, 1,params,commonticks,looperParams);
