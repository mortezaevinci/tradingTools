
if (iscell(params))
params=mainticks{1}.params;
end
calculations=[];
result=[];


params.thresh.dcs.fight.min=1;
params.thresh.avs.min=.7;
params.thresh.rvs.min=0.4; 
params.thresh.dvs.open.min=0;0.2;
params.thresh.dvs.close.min=0;0.3;
params.thresh.dvs.total.min=0;0.5;0.5;
params.thresh.dsma5.min=0.05;
params.thresh.ddsma5.min=0;
params.thresh.minNextLvlByPercent=0.05;

looperParams.date='today';

params.symbol='AMD';
params=strategy_getdata(looperParams,params);

strategy_copypaste;

result=signals_max10_t1(params,calculations);

fig=figure('units','normalized','outerposition',[0 0 .95 1]);
ppp=uipanel('Title',looperParams.symbols{si},'Position',[0 0 1 1]);
graphStrategy_full_t5(ppp,params,calculations,result,1); 