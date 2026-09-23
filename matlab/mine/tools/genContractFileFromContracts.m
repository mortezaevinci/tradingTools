function []=genContractFileFromContracts(filename,contracts)
if (isempty(contracts))
return;
end
try

fileID = fopen(filename,'w');
fprintf(fileID,'%s\n',"ibcontractmanager.DataProvider.Historical={'ib'};ibcontractmanager.DataProvider.RealTime={'ib'};");
fprintf(fileID,'%s\n',"contracts={");
firstdone=0;

nc=numel(contracts);

cnt=1;
for i=1:nc
    sym=contracts{i}.Symbol;
    fsym=contracts{i}.FileSymbol;
    if (~isempty(sym))
  
         if (firstdone==1)
           fprintf(fileID,'%s\n',",...");
         end
       
         gcstring=sprintf("genContract([],'%s','%s')",sym,fsym);
       fprintf(fileID,'%s',gcstring);
       firstdone=1;
        
   cnt=cnt+1;
    end
end

fprintf(fileID,'\n%s\n',"};");
fclose(fileID);
catch exception
    
     dumpReport('error.log', exception) 
end
end