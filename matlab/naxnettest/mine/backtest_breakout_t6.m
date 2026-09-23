%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show


%% prepare 
somethingtodo=0;
 ncommon=numel(commonticks);
nsymbols=numel(looperParams.symbols);

calculations=cell(1,nsymbols);
result=cell(1,nsymbols);
params=cell(1,nsymbols);

figsize=[0 .1 1 .8];

 global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;

%WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
%Audio = audioplayer(WarnWave, 22050);
if (looperParams.graph.show>0)
   
if (looperParams.runOnce)
for si=1:nsymbols
bbFig{si}=figure('units','normalized','outerposition',figsize);
panel{si}=uipanel('Title',looperParams.symbols{si},'Position',[0 0 1 1]);
set(bbFig{si}, 'KeyPressFcn', @myKeyPressFcn)
end
else
bbFig{1}=figure('units','normalized','outerposition',figsize);
set(bbFig{1}, 'KeyPressFcn', @myKeyPressFcn)

%bbFigspecial=figure('units','normalized','outerposition',figsize);
%panelspecial=uipanel('Title','Selected','Position',[0 0 1 1]);
%set(bbFigspecial, 'KeyPressFcn', @myKeyPressFcn);
end

end
KEY_IS_PRESSED = 0;

sir=min(2,nsymbols);
sis=ceil(nsymbols/sir);
w=1;
h=1;

crumb=[];
rq=[];

%if (tempsymbol.params.getdatainit==1)
%   [rq,crumb]=getdata_today_func(tempsymbol.params,rq,crumb,0,0);
%end


for si=1:ncommon
   
     disp(['init ' commonticks{si}.params.symbol '...']);
    
if (commonticks{si}.params.getdatainit==1)
   [rq,c]=getdata_today_func(commonticks{si}.params,rq,crumb,0,0);
end
    
    commonticks{si}.params=strategy_getdata(commonticks{si}.params);

end

for si=1:nsymbols
   
    mainticks{si}.params=tempsymbol.params;
    mainticks{si}.params.symbol=looperParams.symbols{si};
     disp(['init ' filefriendlysymbol(mainticks{si}.params.symbol) '...']);
    
if (mainticks{si}.params.getdatainit==1)
   [rq,c]=getdata_today_func(mainticks{si}.params,rq,crumb,0,0);
end
    success=0;
    
    [mainticks{si}.params, success]=strategy_getdata(mainticks{si}.params);
    if (success==0)
        
        [rq,c]=getdata_today_func(mainticks{si}.params,rq,crumb,0,1);
        [mainticks{si}.params, success]=strategy_getdata(mainticks{si}.params);
       
    end
    if (success==0)
        disp('could not get data successfully.');
    end
    sc=floor((si-1)/sir);
    sr=si-1-sc*sir;
    if (looperParams.runOnce)
        
    else
        if (looperParams.graph.show>0)
      panel{si}=uipanel('Title',[looperParams.symbols{si} '(' (char('a'+si-1)) ')'],'Position',[w*sc/sis h*sr/sir w*1/sis h/sir]);
        end
    end
end

%threadPlot_special = parallel.pool.DataQueue;
%threadPlot_special.afterEach(@(x) graphStrategy_full_t5(panelspecial,x{1},x{2},x{3},1)); 
threadPlot_single = parallel.pool.DataQueue;
threadPlot_single.afterEach(@(x) graphStrategy_full_t6(x{2}.layout,x{2},x{3},x{4},1)); 
threadPlot = parallel.pool.DataQueue;
threadPlot.afterEach(@(x) graphStrategy_t6(x{2}.layout,x{2},x{3},x{4}));

%init graph
disp('initializing graphs');
for  si=1:nsymbols


disp(mainticks{si}.params.symbol);
%% main tester
if (mainticks{si}.params.getalldatainrealtime==1)
      getdata_today_func(mainticks{si}.params,rq,crumb,1,0);
end

%% update real-time could be lower, if orb level was done a bit differently
if (mainticks{si}.params.updaterealtime==1)
    mainticks{si}.params.TimeTables.Minute=updaterealtime(mainticks{si}.params.symbol,mainticks{si}.params.TimeTables.Minute);
else
    mainticks{si}.params=strategy_getdata(mainticks{si}.params);
end
 
mainticks{si}.calculations=strategy_breakout_t5(mainticks{si}.params,commonticks);

if (mainticks{si}.params.graph==2 || (mainticks{si}.params.graph==1 && somethingtodo))
%graphStrategy_t2(bbFig,panel{si},mainticks{si}.params,calculations,result);

if (numel(KEY_IS_PRESSED)==1 && KEY_IS_PRESSED==('a'+si-1) && ~looperParams.runOnce)
   % graphStrategy_full_t5(panelspecial,mainticks{si}.params,mainticks{si}.calculations,result{si});
else
if (nsymbols==1 || looperParams.runOnce)
mainticks{si}.params.layout=graphStrategy_full_t6_init(panel{si},mainticks{si}.params,mainticks{si}.calculations,result{si});
else
mainticks{si}.params.layout=graphStrategy_t6_init(panel{si},mainticks{si}.params,mainticks{si}.calculations,result{si});

end
end


end
end


%% keep loop




disp('Go!');
while(KEY_IS_PRESSED(1)~='0')

%% loop

crumb=[];
rq=[];

%if (tempsymbol.params.getalldatainrealtime==1)
%   [rq,crumb]=getdata_today_func(tempsymbol.params,rq,crumb,1,0);
%end

%% evaluate commonticks
   %;disp('eval commonticks');
    parfor (si=1:ncommon,useparfor)
        if (mainticks{si}.params.getalldatainrealtime==1)
            getdata_today_func(commonticks{si}.params,rq,crumb,1,0);
        end
        commonticks{si}.params=strategy_getdata(commonticks{si}.params);
        commonticks{si}.calculations=strategy_breakout_t5(commonticks{si}.params,[]);
    end

%% evaluate symbols

%parfor  (si=1:nsymbols,useparfor)
for si=1:nsymbols

    if (KEY_IS_PRESSED(1)=='0')
        break;
    end
    
disp(mainticks{si}.params.symbol);
%% main tester
 %;disp('get data');
if (mainticks{si}.params.getalldatainrealtime==1)
      getdata_today_func(mainticks{si}.params,rq,crumb,1,0);
end

%% update real-time could be lower, if orb level was done a bit differently
%;tic
if (mainticks{si}.params.updaterealtime==1)
    mainticks{si}.params.TimeTables.Minute=updaterealtime(mainticks{si}.params.symbol,mainticks{si}.params.TimeTables.Minute);
else
    mainticks{si}.params=strategy_getdata(mainticks{si}.params);
end
%;ticbgetdata=toc
 %;disp('calculations');
if (mainticks{si}.params.doBookOnly==0)
mainticks{si}.calculations=strategy_breakout_t5(mainticks{si}.params,commonticks);
 %;disp('results');
result{si}=signals_next5_t1(mainticks{si}.params,mainticks{si}.calculations);

%% results
somethingtodo=alertSignals(mainticks{si}.params,mainticks{si}.calculations);
end

if (somethingtodo)
%play(Audio); 
end
 %;disp('graph');
if (mainticks{si}.params.graph==2 || (mainticks{si}.params.graph==1 && somethingtodo))
%graphStrategy_t2(bbFig,panel{si},mainticks{si}.params,calculations,result);

if (numel(KEY_IS_PRESSED)==1 && KEY_IS_PRESSED==('a'+si-1) && ~looperParams.runOnce)
send(threadPlot_special,{si,mainticks{si}.params,mainticks{si}.calculations,result{si}});  
else
if (nsymbols==1 || looperParams.runOnce)

%send(threadPlot_single,{si,mainticks{si}.params,mainticks{si}.calculations,result{si}});
graphStrategy_full_t6(mainticks{si}.params.layout,mainticks{si}.params,mainticks{si}.calculations,result{si});
else
%send(threadPlot,{si,mainticks{si}.params,mainticks{si}.calculations,result{si}});
graphStrategy_t6(mainticks{si}.params.layout,mainticks{si}.params,mainticks{si}.calculations,result{si});
end
end

drawnow;
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