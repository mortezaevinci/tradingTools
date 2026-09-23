%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show




%% prepare 
 ncommon=numel(commonticks);
nsymbols=numel(looperParams.symbols);

figsize=[0 0 1 1];



%% keep loop

disp('Go!');


%% loop

crumb=[];
rq=[];

for si=1:ncommon
   
     disp(['init ' commonticks{si}.params.symbol '...']);
    
if (commonticks{si}.params.getdatainit==1)
   [rq,c]=getdata_today_func(commonticks{si}.params,rq,crumb,0,0);
end
    
    commonticks{si}.params=strategy_getdata(commonticks{si}.params);

end

for si=1:nsymbols
   try
    params=tempsymbol.params;
    params.symbol=looperParams.symbols{si};
    disp(params.symbol);
    
%% main tester
tic;
if (params.getalldatainrealtime==1)
      getdata_today_func(params,rq,crumb,0,0);
      params=strategy_getdata(params);
end
%;ticgetdata=toc


calculations=strategy_breakout_t5(params,commonticks);
try
%;tic;
result=signals_next5_t1(params,calculations);
%;ticresult=toc

catch
    
end

%% results
somethingtodo=alertSignals(params,calculations);

if (somethingtodo)
%play(Audio); 
end

if (params.graph==2 || (params.graph==1 && somethingtodo))
bbFig=figure('units','normalized','outerposition',figsize);
panel=uipanel('Title',looperParams.symbols,'Position',[0 0 1 1]);
try
%;tic;

    params.layout=graphStrategy_full_t6_init(panel,params,calculations,result);
%;tic
graphStrategy_full_t6( params.layout,params,calculations,result,0);
%;ticgfull=toc

%;ticgraphfull=toc
catch
    
end 
saveas(bbFig,['Z:\My files\Project trading\traderdata\figures_offline\fig_' params.symbol datestr(datetime(),"yy-mm-dd hh_MM_ss") '.svg']);
savefig(bbFig,['Z:\My files\Project trading\traderdata\figures_offline\fig_' params.symbol datestr(datetime(),"yy-mm-dd hh_MM_ss") '.fig']);

end



   catch exception
       
      disp('ignored'); 
      
      getReport(exception,'extended','hyperlinks','off')
   end
end