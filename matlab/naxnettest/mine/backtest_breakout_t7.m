%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show


%% prepare 
somethingtodo=datetime('2019-01-01');
 ncommon=numel(commonticks);
nsymbols=numel(looperParams.symbols);

calculations=cell(1,nsymbols);
result=cell(1,nsymbols);
params=cell(1,nsymbols);

figsize=[0 .1 2 .9];

 global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;

WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
Audio = audioplayer(WarnWave, 22050);
if (looperParams.graph.show>0)
   
if (looperParams.graph.isfull)
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
%   [rq,crumb]=getdata_yahoo_func(looperParams,tempsymbol.params,rq,crumb,0,0);
%end


for si=1:ncommon
   
     disp(['init ' commonticks{si}.params.symbol '...']);
    
if (commonticks{si}.params.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperParams,commonticks{si}.params,rq,crumb,0,0);
end
    
    commonticks{si}.params=strategy_getdata(looperParams,commonticks{si}.params);

end

for si=1:nsymbols
   
    mainticks{si}.params=tempsymbol.params;
    mainticks{si}.params.symbol=looperParams.symbols{si};
    
end

% for si=1:nsymbols
%      disp(['init ' filefriendlysymbol(mainticks{si}.params.symbol) '...']);
% if (mainticks{si}.params.getdatainit==1)
%    [rq,c]=getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,0,0);
% elseif (mainticks{si}.params.getdatainit==2)
%     [rq,c]=getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,1,0);
% end
%     success=0;
%     
%     [mainticks{si}.params, success]=strategy_getdata(looperParams,mainticks{si}.params);
%     if (success==0)
%         
%         [rq,c]=getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,0,1);
%         [mainticks{si}.params, success]=strategy_getdata(looperParams,mainticks{si}.params);
%        
%     end
%     if (success==0)
%         disp('could not get data successfully.');
%     end
% end

parfeval(@initGetdata_t7,1,looperParams,params);
    
for si=1:nsymbols    
    sc=floor((si-1)/sir);
    sr=(si-1)-sc*sir;
    sr=-si+(sc+1)*sir;
    if (looperParams.graph.isfull)
        
    else
        if (looperParams.graph.show>0)
           panel{si}=uipanel('Title',[looperParams.symbols{si} '(' (char('a'+si-1)) ')'],'Position',[w*sc/sis h*sr/sir w*1/sis h/sir]);
        end
    end
end

%threadPlot_special = parallel.pool.DataQueue;
%threadPlot_special.afterEach(@(x) graphStrategy_full_t5(panelspecial,looperParams,x{1},x{2},x{3},1)); 
threadPlot_single = parallel.pool.DataQueue;
threadPlot_single.afterEach(@(x) graphStrategy_full_t7(x{2}.layout,x{2},x{3},x{4},x(5))); 
threadPlot = parallel.pool.DataQueue;
threadPlot.afterEach(@(x) graphStrategy_t7(x{2}.layout,x{2},x{3},x{4},x(5)));

pause(2); %graphs need to init first

%init graph
disp('initializing graphs...');
for  si=1:nsymbols
disp(mainticks{si}.params.symbol);
%% main tester
%if (mainticks{si}.params.getalldatainrealtime==1)
%      getdata_yahoo_func(looperParams,mainticks{si}.params,rq,crumb,1,0);
%end

%% update real-time could be lower, if orb level was done a bit differently
%if (mainticks{si}.params.updaterealtime==1)
%    mainticks{si}.params.TimeTables.Minute=updaterealtime(mainticks{si}.params.symbol,mainticks{si}.params.TimeTables.Minute);
%else
    mainticks{si}.params=strategy_getdata(looperParams,mainticks{si}.params);
%end
 
%mainticks{si}.calculations=strategy_breakout_t8(looperParams,mainticks{si}.params,commonticks);

if (looperParams.graph.show==2 || (looperParams.graph.show==1 && somethingtodo))
%graphStrategy_t2(bbFig,panel{si},mainticks{si}.params,calculations,result);

if (numel(KEY_IS_PRESSED)==1 && KEY_IS_PRESSED==('a'+si-1) && ~looperParams.runOnce)
   % graphStrategy_full_t5(panelspecial,mainticks{si}.params,mainticks{si}.calculations,result{si});
else
if (looperParams.graph.isfull)
mainticks{si}.params.layout=graphStrategy_full_t7_init(panel{si},looperParams,mainticks{si}.params,result{si});
else
mainticks{si}.params.layout=graphStrategy_t7_init(panel{si},looperParams,mainticks{si}.params,result{si});

end
end
end
end


%% keep loop


disp('Go!');

%% evaluate symbols
lastalert=datetime();

while(KEY_IS_PRESSED(1)~='0')

%% loop

 %% evaluate commonticks
 %;tic
   %;disp('eval commonticks');
    for si2=1:ncommon
        
        commonticks{si2}.params=strategy_getdata(looperParams,commonticks{si2}.params);
        commonticks{si2}.calculations=strategy_breakout_t8(commonticks{si2}.params,[]);
    end
 %;ticbcommon=toc

%parfor  (si=1:nsymbols,useparfor)
for si=1:nsymbols
if (KEY_IS_PRESSED(1)=='0')
    break;
end
       disp(mainticks{si}.params.symbol);
    
%% update real-time could be lower, if orb level was done a bit differently
%;tic
if (looperParams.updaterealtime==1)
    mainticks{si}.params=updaterealtimeByFile(mainticks{si}.params);
else
    mainticks{si}.params=strategy_getdata(looperParams,mainticks{si}.params);
end
%;ticbupdatedata=toc

%;tic
 %;disp('calculations');
if (mainticks{si}.params.doBookOnly==0)
if (looperParams.backStudyPoints>0)
   mainticks{si}.params.TimeTables.Minute=mainticks{si}.params.TimeTables.Minute(1:(390-looperParams.backStudyPoints),:); 
end
    
mainticks{si}.calculations=strategy_breakout_t8(looperParams,mainticks{si}.params,commonticks);
    
%calculations=fetchOutputs(parf);
 %;disp('results');
result{si}=signals_next5_t1(mainticks{si}.params,mainticks{si}.calculations);

%% results
somethingtodo=alertSignals(mainticks{si}.params,mainticks{si}.calculations);
end

%;ticbcalcsandres=toc

if (seconds(datetime()-somethingtodo)<60 && (seconds(datetime()-lastalert))>30)
play(Audio); 
lastalert=datetime();
end

%;tic
 %;disp('graph');
if (looperParams.graph.show==2 || (looperParams.graph.show==1 && somethingtodo))
%graphStrategy_t2(bbFig,panel{si},mainticks{si}.params,calculations,result);

if (numel(KEY_IS_PRESSED)==1 && KEY_IS_PRESSED==('a'+si-1) && ~looperParams.runOnce)
send(threadPlot_special,{si,mainticks{si}.params,mainticks{si}.calculations,result{si}});  
else
if (looperParams.graph.isfull)

%send(threadPlot_single,{si,mainticks{si}.params,mainticks{si}.calculations,result{si}});
graphStrategy_full_t7(mainticks{si}.params.layout,looperParams,mainticks{si}.params,mainticks{si}.calculations,result{si});
else
%send(threadPlot,{si,mainticks{si}.params,mainticks{si}.calculations,result{si}});
graphStrategy_t7(mainticks{si}.params.layout,looperParams,mainticks{si}.params,mainticks{si}.calculations,result{si});
end
end

%drawnow;
%;ticbgraph=toc
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

if (looperParams.backStudyPoints>0)
looperParams.backStudyPoints=looperParams.backStudyPoints-1;
if (looperParams.backStudyPoints==0)
    break;
end
pause;
end
end



