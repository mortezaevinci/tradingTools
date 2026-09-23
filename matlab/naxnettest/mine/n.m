%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show


%% prepare 

nsymbols=numel(looperParams.symbols);

calculations=cell(1,nsymbols);
result=cell(1,nsymbols);
params=cell(1,nsymbols);

figsize=[0 0 .6 .6];

 global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;

%WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
%Audio = audioplayer(WarnWave, 22050);
if (looperParams.graph.show>0)
   
if (looperParams.runOnce)
for si=1:nsymbols
bbFig{si}=figure('units','normalized','outerposition',figsize);
panel{si}=uipanel('Title',looperParams.symbols{si},'Position',[0 0 1 1]);
end
else
bbFig{1}=figure('units','normalized','outerposition',figsize);
set(bbFig{1}, 'KeyPressFcn', @myKeyPressFcn)
end

end


sir=min(2,nsymbols);
sis=ceil(nsymbols/sir);
w=1;
h=1;

crumb=[];
rq=[];

%if (tempsymbol.params.getdatainit==1)
%   [rq,crumb]=getdata_today_func(tempsymbol.params,rq,crumb,0,0);
%end


for si=1:nsymbols
   
    mainticks{si}.params=tempsymbol.params;
    mainticks{si}.params.symbol=looperParams.symbols{si};
     disp(['init ' filefriendlysymbol(mainticks{si}.params.symbol) '...']);
    
if (mainticks{si}.params.getdatainit==1)
   [rq,c]=getdata_today_func(mainticks{si}.params,rq,crumb,0,0);
   
   
   
   
end
    
    mainticks{si}.params=strategy_getdata(mainticks{si}.params);
    sc=floor((si-1)/sir);
    sr=si-1-sc*sir;
    if (looperParams.runOnce)
        
    else
        if (looperParams.graph.show>0)
      panel{si}=uipanel('Title',looperParams.symbols{si},'Position',[w*sc/sis h*sr/sir w*1/sis h/sir]);
        end
    end
end

if (nsymbols==1 || looperParams.runOnce)
threadPlot = parallel.pool.DataQueue;
threadPlot.afterEach(@(x) graphStrategy_full_t2(panel{x{1}},mainticks{x{1}}.params,x{2},x{3},0));  
else
threadPlot = parallel.pool.DataQueue;
threadPlot.afterEach(@(x) graphStrategy_t2(panel{x{1}},mainticks{x{1}}.params,x{2},x{3}));
end
%% keep loop

disp('Go!');
while(~KEY_IS_PRESSED)

%% loop

crumb=[];
rq=[];

if (tempsymbol.params.getalldatainrealtime==1)
   [rq,crumb]=getdata_today_func(tempsymbol.params,rq,crumb,1,0);
end

parfor (si=1:nsymbols,useparfor)
    disp(mainticks{si}.params.symbol);
%% main tester

if (mainticks{si}.params.getalldatainrealtime==1)
      getdata_today_func(mainticks{si}.params,rq,crumb,1,0);
end

%% update real-time could be lower, if orb level was done a bit differently
if (mainticks{si}.params.updaterealtime==1)
    mainticks{si}.params.TimeTables.Minute=updaterealtime(mainticks{si}.params.symbol,mainticks{si}.params.TimeTables.Minute);
end


mainticks{si}.calculations=strategy_breakout_t2(mainticks{si}.params);
result{si}=signals_next5_t1(mainticks{si}.params,mainticks{si}.calculations);

%% results
somethingtodo=alertSignals(mainticks{si}.params,mainticks{si}.calculations);

if (somethingtodo)
%play(Audio); 
end

if (mainticks{si}.params.graph==2 || (mainticks{si}.params.graph==1 && somethingtodo))
%graphStrategy_t2(bbFig,panel{si},mainticks{si}.params,calculations,result);
send(threadPlot,{si,mainticks{si}.calculations,result{si}});
drawnow
end
end


if (looperParams.graph.saveFigures)
    disp('saving figures...');
    nfig=numel(bbFig);
    for i=1:nfig
        if (nfig==numel(looperParams.symbols))
            ' filefriendlysymbol(symname)=looperParams.symbols{i};
        else
            ' filefriendlysymbol(symname)=strjoin(looperParams.symbols);
        end
       
       saveas(bbFig{i},['Z:\My files\Project trading\traderdata\figures\fig_' ' filefriendlysymbol(symname) datestr(datetime(),"yy-mm-dd hh_MM_ss") '.svg']);
       savefig(bbFig{i},['Z:\My files\Project trading\traderdata\figures\fig_' ' filefriendlysymbol(symname) datestr(datetime(),"yy-mm-dd hh_MM_ss") '.fig']);
    end
end

if (looperParams.runOnce==1) 
    break;
end
end