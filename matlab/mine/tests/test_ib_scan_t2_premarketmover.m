run('config\looperparams_study_premarket_t10_ID3');
looperEngine.IB.Engine=ibEngineInit(looperEngine.directories.ibapi);
looperEngine.IB.Engine.events= setIbWrapperEvents(looperEngine.IB.Engine.ibWrapper);

 %% connect
  looperEngine.IB.Engine.ibWrapper.ibClient.ClientId=floor(rand*10+1);
 isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);

 fn=['..\scan log-' datestr(datetime,'yyyy-mm-dd HH-MM-SS')];
fileID = fopen([fn '.log'],'w');

scantypes={'PM1','PM2','PM3','PM4','PM5','PM6'};
 
if (isconnected)

    ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop loop', ...
                         'Callback', 'delete(gcbf)');
   
 scandata=cell(0);
 allscandata=cell(0);
 allsymbols=cell(0);           
 scancnt=0;            
while (1)
    scancnt=scancnt+1;
    allscans='';
for j=1:numel(scantypes)
configFn=['ibscan_params_' scantypes{j}];
eval(configFn);
disp(configFn);
%% scan
run_ib_scan;
%% write
fprintf(fileID,[datestr(datetime(),'yyyy-mm-dd HH-MM-SS') ':' scantypes{j} ':%s\n'],scancsv_in);
pause(0.25);

%% get new ones
scansymbols=split(scancsv_in,',');
scandata{scancnt,j}.newsymbols=setdiff(scansymbols,allsymbols);
scandata{scancnt,j}.scancsv=scancsv_in;
scandata{scancnt,j}.datetime=datetime();

%% gen all scans
 allscans=[allscans scancsv_in];
end
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

 fprintf(fileID,[datestr(datetime(),'yyyy-mm-dd HH-MM-SS') ':' 'DUP' ':%s\n'],allscandata{scancnt}.dupscan);
 fprintf(fileID,[datestr(datetime(),'yyyy-mm-dd HH-MM-SS') ':' 'NEW' ':%s\n'],allscandata{scancnt}.newscan);
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
 disp('waiting 3 seconds...');
 pause(3);
end


fclose(fileID);

%% disconnect  
                  
looperEngine.IB.Engine.ibWrapper.Disconnect();
else
    disp('did not connect');
end
     