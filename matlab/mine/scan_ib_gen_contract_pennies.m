ibscans=cell(0);
scnt=1;

run('config\looperparams_study_premarket_t10_ID3');
looperEngine.IB.Engine=ibEngineInit(looperEngine.directories.ibapi);
looperEngine.IB.Engine.events= setIbWrapperEvents(looperEngine.IB.Engine.ibWrapper);

 %% connect
 looperEngine.IB.Engine.ibWrapper.ibClient.ClientId=floor(rand*10+1);
 isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);

 
 
 
prices=.5:.01:30;

if (isconnected)
     

for k=1:numel(prices)-1
    
    
if (~isconnected)
 isconnected=ibConnect(looperEngine.IB.Engine.ibWrapper,looperEngine.IB.port);
end
    
    prices(k)
    scanParamsMain=genScanParamsMain(5,10000,prices(k),prices(k+1));
    scanParams=scanParamsMain;
    [subscription,tvs]=ibGenScanSubscription(scanParams);
%% scan
run_ib_scan;

%grab ibscan
ibscans{scnt}.ibscan=ibscan;
scnt=scnt+1;

pause(0.05);


end%k

%% iterate through all, and save all symbols in my contract file format
tempfn='contracts\contracts_pennies.m';
fileID = fopen(tempfn,'w');
fprintf(fileID,'%s\n',"ibcontractmanager.DataProvider.Historical={'ib'};ibcontractmanager.DataProvider.RealTime={'ib'};");
fprintf(fileID,'%s\n',"contracts={");

firstdone=0;
for i=1:scnt-1
   nn=numel(ibscans{i}.ibscan);
   for j=1:nn
       
       if (firstdone==1)
           fprintf(fileID,'%s\n',",...");
       end
       sym=ibscans{i}.ibscan{j}.contract.Symbol;
       fsym=filefriendlysymbol(sym);
       sec=ibscans{i}.ibscan{j}.contract.SecType;
       ext=ibscans{i}.ibscan{j}.contract.Exchange;
       pex=ibscans{i}.ibscan{j}.contract.PrimaryExch;
       
       %gcstring=sprintf("genContract([],'%s','%s','%s','%s','%s')",sym,fsym,sec,ext,pex);
       gcstring=sprintf("genContract([],'%s','%s')",sym,fsym);
       fprintf(fileID,'%s',gcstring);
       firstdone=1;
   end
   end

fprintf(fileID,'\n%s\n',"};");
fclose(fileID);
%% disconnect  
                  
looperEngine.IB.Engine.ibWrapper.Disconnect();
else
    disp('did not connect');
end
     