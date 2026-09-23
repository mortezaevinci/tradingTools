%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show




%% prepare 

nsymbols=numel(looperParams.symbols);

figsize=[0 0 1 1];



%% keep loop

disp('Go!');


%% loop

crumb=[];
rq=[];



for si=1:nsymbols
   try
    params=tempsymbol.params;
    params.symbol=looperParams.symbols{si};
    disp(params.symbol);
    
%% main tester

if (params.getalldatainrealtime==1)
      getdata_today_func(params,rq,crumb,0,0);
      params=strategy_getdata(params);
end



calculations=strategy_breakout_t2(params);
result=signals_next5_t1(params,calculations);

%% results
somethingtodo=alertSignals(params,calculations);

if (somethingtodo)
%play(Audio); 
end

if (params.graph==2 || (params.graph==1 && somethingtodo))
bbFig=figure('units','normalized','outerposition',figsize);
panel=uipanel('Title',looperParams.symbols,'Position',[0 0 1 1]);
graphStrategy_full_t2(panel,params,calculations,result);

saveas(bbFig,['Z:\My files\Project trading\traderdata\figures_offline\fig_' params.symbol datestr(datetime(),"yy-mm-dd hh_MM_ss") '.svg']);
savefig(bbFig,['Z:\My files\Project trading\traderdata\figures_offline\fig_' params.symbol datestr(datetime(),"yy-mm-dd hh_MM_ss") '.fig']);

end

close all;

   catch
       
      disp('ignored'); 
   end
end