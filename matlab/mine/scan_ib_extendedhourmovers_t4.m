basescan='Z:\My files\Project Trading\traderdata\scan\extendedhourmovers\';


WarnWave = 0.3*[sin(1:.1:300), sin(1:.2:300)];%, sin(1:.4:300)];
Audio = audioplayer(WarnWave, 44100);

run('config\looperparams_study_premarket_t10_ID3');
looperEngine.IB.Engine=ibEngineInit(looperEngine.directories.ibapi);
looperEngine.IB.Engine.events= setIbWrapperEvents(looperEngine.IB.Engine.ibWrapper);

 %% connect
 looperEngine.IB.Engine.ibWrapper.ibClient.ClientId=floor(rand*10+1);
 isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);

 fn=[basescan 'scan log-' datestr(datetime,'yyyy-mm-dd HH-MM-SS')];
fileID = fopen([fn '.log'],'w');

mcap=30;
if (datetime()<datetime('09:00:00') )
    minvol=200000;basedate
    setscanParams_gainers;
else (datetime()<datetime('16:00:00') )
    minvol=200000;
    setscanParamsAfterhours_gainers;
end

prices=0.5:5:30;


if (isconnected)

    ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');
   
 scandata=cell(0);
 allscandata=cell(0);
 allsymbols=cell(0);           
 scancnt=0;            
while (1)
isconnected=looperEngine.IB.Engine.ibWrapper.ibClient.ClientSocket.IsConnected();
if (~isconnected)
 isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);
end

    scancnt=scancnt+1;
    allscans='';
for j=1:numel(scantemp)
scancsv=[];
for k=1:numel(prices)-1
    scanParamsMain=genScanParamsMain(mcap,minvol,prices(k),prices(k+1));
    scanParams={scanParamsMain{:},scantemp{j}.scanSecondaryParams{:}};
    [subscription,tvs]=ibGenScanSubscription(scanParams);
%% scan
run_ib_scan;
scancsv=[scancsv scancsv_in];
pause(0.05);
end%k

%% write
fprintf(fileID,[datestr(datetime(),'yyyy-mm-dd HH-MM-SS') ':' 'S' num2str(j) ':%s\n'],scancsv);


%% get new ones
scansymbols=split(scancsv,',');
scandata{scancnt,j}.newsymbols=setdiff(scansymbols,allsymbols);
scandata{scancnt,j}.scancsv=scancsv;
scandata{scancnt,j}.datetime=datetime();



%% gen all scans
 allscans=[allscans scancsv];
end%j
%% general calc
 allscandata{scancnt}.allscansymbols=split(allscans,',');
 allscandata{scancnt}.allnewsymbols=setdiff(allscandata{scancnt}.allscansymbols,allsymbols);
 allscandata{scancnt}.datetime=datetime();
 
 allsymbols=unique({allsymbols{:}, allscandata{scancnt}.allscansymbols{:}});
  
 allscandata{scancnt}.duplicate_symbols=detectRepeatedSymbols(allscandata{scancnt}.allscansymbols);
 allscandata{scancnt}.dupscan=cell2mat(join(allscandata{scancnt}.duplicate_symbols,',')); 
 if (scancnt==1)
 allscandata{scancnt}.newscan='';
 else
 allscandata{scancnt}.newscan=cell2mat(join(allscandata{scancnt}.allnewsymbols,',')); 
 end
 try
 if (~isempty( allscandata{scancnt}.dupscan))
 fprintf(fileID,[datestr(datetime(),'yyyy-mm-dd HH-MM-SS') ':' 'DUP' ':%s\n'],allscandata{scancnt}.dupscan);
 end
 if (~isempty( allscandata{scancnt}.newscan))
 fprintf(fileID,[datestr(datetime(),'yyyy-mm-dd HH-MM-SS') ':' 'NEW' ':%s\n'],allscandata{scancnt}.newscan);
 %play(Audio);
 end
 allscandata{scancnt}.newscan
 catch
 
 end
 
 if ~ishandle(ButtonHandle)
    disp('Loop stopped by user');
    break;
 end
 
 %% write mat file
 save([fn '.mat'],'scandata','allscandata');
 
  if ((datetime()>datetime('09:00:00') && datetime()<datetime('12:00:00')) || datetime()>datetime('20:00:00'))
     break;
 end
 
 %% wait
 slp=1;
 disp(['waiting ' num2str(slp) ' seconds...']);
 pause(slp);
end


fclose(fileID);

%% disconnect  
                  
looperEngine.IB.Engine.ibWrapper.Disconnect();
else
    disp('did not connect');
end
     