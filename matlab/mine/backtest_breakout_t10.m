%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show

try
 opengl hardware;
%% prepare 
%;tic
somethingtodo=datetime('2019-01-01');
 ncommon=numel(commonticks);
ncontracts=numel(looperEngine.contracts);
nrunningcontracts=numel(looperEngine.runIndices);

global PRESSEDKEY;
PRESSEDKEY = {};

WarnWave = [sin(1:.3:300), sin(1:.5:300)];%, sin(1:.4:300)];
Audio = audioplayer(WarnWave, 44100);
if (looperEngine.graph.show>0)
   
if (looperEngine.graph.isfull==1)
for si=1:nrunningcontracts
bbFig{si}=figure('units','normalized','outerposition',looperEngine.graph.figureSize);
panel{si}=uipanel('Title',looperEngine.contracts{si}.Symbol,'Position',[0 0 1 1]);
set(bbFig{si}, 'WindowKeyPressFcn', @myKeyPressFcn)
set(bbFig{si}, 'WindowKeyReleaseFcn', @myKeyReleaseFcn)
end
elseif (looperEngine.graph.isfull==2)
    bbFig{1}=figure('units','normalized','outerposition',looperEngine.graph.figureSize);
panel{1}=uipanel('Title',looperEngine.contracts{1}.Symbol,'Position',[0 0 1 1]);
set(bbFig{1}, 'WindowKeyPressFcn', @myKeyPressFcn)
set(bbFig{1}, 'WindowKeyReleaseFcn', @myKeyReleaseFcn)   
else
bbFig{1}=figure('units','normalized','outerposition',looperEngine.graph.figureSize);
set(bbFig{1}, 'WindowKeyPressFcn', @myKeyPressFcn)
set(bbFig{1}, 'WindowKeyReleaseFcn', @myKeyReleaseFcn)

end

 set(gcf,'Renderer','OpenGL');
end

sir=min(2,nrunningcontracts);
sis=ceil(nrunningcontracts/sir);
w=1;
h=1;

crumb=[];
rq=[];

 if (mainticks{si}.params.doBookOnly==0)
for si=1:ncontracts
    mainticks{si}.params=loadprofile_PMATP1(mainticks{si}.params,looperEngine);
    mainticks{si}.params=loadprofile_PAPP1(mainticks{si}.params,looperEngine);
end

for si=1:ncommon
    commonticks{si}.params=loadprofile_PMATP1(commonticks{si}.params,looperEngine);
    commonticks{si}.params=loadprofile_PAPP1(commonticks{si}.params,looperEngine);
end
 end
%parpool('local');


for ri=1:nrunningcontracts   
    lastclose{ri}=-1;
     lastshowlimit{ri}=-1;
     lastdatasize{ri}=-1;
    sc=floor((ri-1)/sir);
    sr=(ri-1)-sc*sir;
    sr=-ri+(sc+1)*sir;
    if (looperEngine.graph.isfull)
        
    else
        if (looperEngine.graph.show>0)
           si=looperEngine.runIndices(ri);
           panelPosition{ri}=[w*sc/sis h*sr/sir w*1/sis h/sir];
           panel{ri}=uipanel('Title',[looperEngine.contracts{si}.FileSymbol '(' num2str(ri) ')'],'Position',panelPosition{ri});
        end
    end
end

%init graph
disp('initializing...');
for  si=1:ncontracts
disp(mainticks{si}.params.contract.Symbol);

if (looperEngine.net.use==1)
    mainticks{si}.params.net.use=1;
    
    netfilename=[looperEngine.directories.nets 'netP1 ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) ' ID' num2str(looperEngine.net.setupId) '.mat'];
    if (exist(netfilename))
        load(netfilename);
        mainticks{si}.params.net.netP1=netP1;  
    end
end
end

if (looperEngine.graph.show==2 || (looperEngine.graph.show==1))

if (looperEngine.graph.isfull==1)
    for  ri=1:nrunningcontracts
si=looperEngine.runIndices(ri);
looperEngine.layout{ri}=graphStrategy_full_t10_init(panel{ri},looperEngine,mainticks{si}.params,mainticks{si}.result);
looperEngine.layout{ri}.extended=0;
    end
elseif (looperEngine.graph.isfull==2)
looperEngine.layout{1}=graphStrategy_full_t10_init(panel{1},looperEngine,mainticks{si}.params,mainticks{si}.result);
looperEngine.layout{1}.extended=1;
else
    for  ri=1:nrunningcontracts
si=looperEngine.runIndices(ri);
    if (mainticks{si}.params.doBookOnly==0)
looperEngine.layout{ri}=graphStrategy_t10_init(panel{ri},looperEngine,mainticks{si}.params,mainticks{si}.result);
    else
looperEngine.layout{ri}=graphStrategy_t10_bookonly_init(panel{ri},looperEngine,mainticks{si}.params,mainticks{si}.result);
    end
looperEngine.layout{ri}.extended=0;
    end
end
end

%;ticinitgraphs=toc
[sucess,mainticks,commonticks]=initGetdata_t8(looperEngine,mainticks,commonticks);

%% first ib engine
if (looperEngine.IB.run==1)
ibEngine(mainticks,commonticks,looperEngine);
end

%wait for bookviewer for at least 105 seconds
bookseconds=seconds(datetime()-looperEngine.book.Engine.startTime);
if (bookseconds<15)
pause(15-bookseconds);
end

disp('ready to go...');
hoursopen=datetime().Hour+datetime().Minute/60;

if (looperEngine.ui.continueAfterInit==0 && hoursopen<9.51)
pause;
end

%;tic
global initgetdatadone;
%parfeval(@initGetdata_t8,3,looperEngine,params,commonticks);
[sucess,mainticks,commonticks]=initGetdata_t8(looperEngine,mainticks,commonticks);

newsymbol='';
selectedchannel=0;
selectedchannelupdated=1;
selectedchannel_char='';
pressed_scape=0;



%% keep loop

while(initgetdatadone==0)
pause(.5);
end

%;ticinitdata=toc

disp('Go!');

%% evaluate symbols
lastalert=datetime();

looperEngine.backupShowLimit=looperEngine.graph.showlimit;

drawdatetime=datetime();
while(1)

try
    
  
    
   if (pressed_scape)
       break;
   end
   process_pressedkey_out;
   if (pressed_scape)
       break;
   end
    

if (mainticks{si}.params.doBookOnly==0 && looperEngine.IB.run==1)
    %;tic
    ibEngine(mainticks,commonticks,looperEngine); 
    %;ticibengine=toc
end
%% loop

 %% evaluate commonticks
 if (mainticks{si}.params.doBookOnly==0)
 %;tic

    for si2=1:ncommon
        try
        if (looperEngine.data.updaterealtime==1)
       % commonticks{si2}.params=updaterealtimeByRealTimeBars(commonticks{si2}.params);
        commonticks{si2}.params=updaterealtimeByFile(looperEngine,commonticks{si2}.params);
       % commonticks{si2}.params=updaterealtimeByHistoricalDataUpdate(commonticks{si2}.params);
        commonticks{si2}.params=updaterealtimeSecondaries(looperEngine,commonticks{si2}.params);
        else
        commonticks{si2}.params=strategy_getdata(looperEngine,commonticks{si2}.params);
        end

        %commonticks{si2}.calculations=strategy_breakout_t10(looperEngine,commonticks{si2}.params,[]);
        commonticks{si2}=strategy_pack1_t10(looperEngine,commonticks{si2},[]);
        catch exception
   dumpReport('error.log', exception) 
    
end
    end
 %;ticbcommon=toc
 end

for ri=1:nrunningcontracts
    tic
    try
        
    if (seconds(datetime()-drawdatetime)>=5)
        drawnow;
        drawdatetime=datetime();
    end
        
    si=looperEngine.runIndices(ri);
    
       if (pressed_scape)
       break;
   end
   process_pressedkey_out;
   if (pressed_scape)
       break;
   end
   
   process_pressedkey_other;
   
   if (pressed_leftarrow)
       looperEngine.graph.showlimit=looperEngine.graph.showlimit+looperEngine.graph.showlimitstep;
       if (looperEngine.graph.showlimit>looperEngine.graph.showlimitmax)
           looperEngine.graph.showlimit=looperEngine.graph.showlimitmax;
       end
   end
   
   if (pressed_rightarrow)
       looperEngine.graph.showlimit=looperEngine.graph.showlimit-looperEngine.graph.showlimitstep;
       if (looperEngine.graph.showlimit<0)
           looperEngine.graph.showlimit=0;
       end
   end



%% update real-time could be lower, if orb level was done a bit differently
if (mainticks{si}.params.doBookOnly==0)
%;tic
if (looperEngine.data.updaterealtime==1 && looperEngine.ui.backStudyPoints==0)
    %mainticks{si}.params=updaterealtimeByRealTimeBars(mainticks{si}.params);
    
    mainticks{si}.params=updaterealtimeByFile(looperEngine,mainticks{si}.params);
%    mainticks{si}.params=updaterealtimeByHistoricalDataUpdate(mainticks{si}.params);
    mainticks{si}.params=updaterealtimeSecondaries(looperEngine,mainticks{si}.params);
else
    mainticks{si}.params=strategy_getdata(looperEngine,mainticks{si}.params);
end
    
if (looperEngine.ui.backStudyPoints>0)
   mainticks{si}.params.TimeTables.Minute=mainticks{si}.params.TimeTables.Minute(1:(390-looperEngine.ui.backStudyPoints),:); 
end
%;ticbupdatedata=toc
end

if (pressed_newsymbol)
    if (selectedchannel>0)
    selectedri=selectedchannel;
    for si_=1:ncontracts
        if (strcmpi(looperEngine.contracts{si_}.Symbol,newsymbol))
            % symbol found in initialized list
            looperEngine.runIndices(selectedri)=si_;
            newsymbol='';
            set(panel{selectedri},'Title',[looperEngine.contracts{si_}.FileSymbol '(' num2str(selectedri) ')']);
            break;
        end
    end
    end
    pressed_newsymbol=0;
end

manage_selectedchannel;

if (selectedchannel~=ri  && selectedchannel>0)
   %drawnow limitrate;
   continue; 
end

    disp(mainticks{si}.params.contract.Symbol);

if (mainticks{si}.params.doBookOnly==0)

try %in case no data was available
% don't do anything if, there is no new data
newdatasize=numel(mainticks{si}.params.TimeTables.Minute.Date);
newlastclose=mainticks{si}.params.TimeTables.Minute.Close(end);
if ((newlastclose==lastclose{si} && newdatasize==lastdatasize{si}) && lastshowlimit{si}==looperEngine.graph.showlimit)
%    drawnow limitrate;
    continue;
else
    lastshowlimit{si}=looperEngine.graph.showlimit;
    lastclose{si}=newlastclose;
    lastdatasize{si}=newdatasize;
end
catch
    
end
end

disp('Processing...');

try
%;tic

 %;disp('calculations');

if (looperEngine.process.useBookLevels>0)
datestring=datestr(datetime(looperEngine.date),'yyyy-mm-dd');
filename=[looperEngine.directories.book filefriendlysymbol(mainticks{si}.params.contract.Symbol) '_book_history ' datestring '.bn2'];
mainticks{si}.params.marketdata=getProcessedMarketdata2(filename,datestring);
if (~isempty(mainticks{si}.params.marketdata))
mainticks{si}.params.marketdata=marketbooklevels(mainticks{si}.params.marketdata);
end
end

if (mainticks{si}.params.doBookOnly==1)
pause(.1);
end

if (mainticks{si}.params.doBookOnly==0)
    
mainticks{si}=strategy_pack1_t10(looperEngine,mainticks{si},commonticks);

if (mainticks{si}.calculations.started==0 && looperEngine.data.updaterealtime==1)
    disp('pausing 1 sec');
    %pause(1); %just to give room to UI to interact when there is no data
%    drawnow;
end
%;ticbooksAndStrategy=toc
%;tic
%calculations=fetchOutputs(parf);
 %;disp('results');
mainticks{si}.result=signals_next5_t1(mainticks{si}.params,mainticks{si}.calculations);

%% results
somethingtodo=alertSignals(mainticks{si}.params,mainticks{si}.calculations);

%;ticbcalcsandres=toc
%;tic
somealertchanged=seconds(datetime()-somethingtodo)<60 && (seconds(datetime()-lastalert))>30;
try

if (somealertchanged)
play(Audio); 
lastalert=datetime();
end
%ticalert=toc

catch exception
   dumpReport('error.log', exception) 
end

end

catch exception
   dumpReport('error.log', exception) 
end

try
    ticprocess=toc;
tic
disp('Graphing...');

if (looperEngine.graph.show==2 || (looperEngine.graph.show==1 && somealertchanged))
%graphStrategy_t2(bbFig,panel{si},mainticks{si}.params,calculations,mainticks{si}.result);

temptitle=[mainticks{si}.params.contract.Symbol ' gap:' num2str(mainticks{si}.calculations.premarketmoveperc*100) '%,$' num2str(mainticks{si}.calculations.premarketmove)];
if (looperEngine.graph.isfull==1)

%send(threadPlot_single,{si,mainticks{si}.params,mainticks{si}.calculations,mainticks{si}.result);
set(panel{ri},'Title',temptitle,'Position',[0 0 1 1]);
graphStrategy_full_t10(looperEngine.layout{ri},looperEngine,mainticks{si}.params,mainticks{si}.calculations,mainticks{si}.result);
elseif (looperEngine.graph.isfull==2)
set(panel{1},'Title',temptitle);
graphStrategy_full_t10(looperEngine.layout{1},looperEngine,mainticks{si}.params,mainticks{si}.calculations,mainticks{si}.result);

    if (looperEngine.graph.saveFigures)
       disp('saving figures...');
       symname=looperEngine.contracts{si}.FileSymbol;
       saveas(bbFig{1},[looperEngine.directories.figures 'fig_' filefriendlysymbol(symname) ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.svg']);
       savefig(bbFig{1},[looperEngine.directories.figures '_fig_' filefriendlysymbol(symname) ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.fig']);
    end

else
%send(threadPlot,{si,mainticks{si}.params,mainticks{si}.calculations,result{si}});
looperEngine.layout{ri}=graphStrategy_t10(looperEngine.layout{ri},looperEngine,mainticks{si}.params,mainticks{si}.calculations,mainticks{si}.result);
end
ticbgraph=toc;
disp(['elapsed: ' num2str(ticprocess) '+' num2str(ticbgraph)]);

if (looperEngine.graph.pauseAfterGraph==1)
    pause
end
end

catch exception
   dumpReport('error.log', exception) 
end

catch exception
   dumpReport('error.log', exception) 
end

end

%;tic
backtest_breakout_t10_savefigures;
%;ticsavefig=toc

if (looperEngine.ui.runOnce==1) 
    break;
end

if (looperEngine.ui.backStudyPoints>0)
    
    cntup=1;
        if (~isempty(PRESSEDKEY))
            if (strcmp(PRESSEDKEY,'hyphen'))
               cntup=cntup-1;
               if (cntup<1)
                   cntup=1;
               end
            end
             if (strcmp(PRESSEDKEY,'equal'))
               cntup=cntup+1;
                if (cntup>10)
                     cntup=cntup+1;
                end
                if (cntup>25)
                     cntup=cntup+3;
                end
               if (cntup>50)
                   cntup=50;
               end
            end
  
    end
    
looperEngine.ui.backStudyPoints=looperEngine.ui.backStudyPoints-cntup;
if (looperEngine.ui.backStudyPoints<=0)
    break;
end
pause(.2);
end

catch exception
   dumpReport('error.log', exception) 
    
end



end %while



catch exception
   dumpReport('error.log', exception) 
    
end