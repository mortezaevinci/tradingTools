function marketdata=loadRawbookFromBinFile(filename)
marketdata.Book=zeros(120,8,1000);
%marketdata.Date=zeros(1000,1);
samplecnt=0;
booksamplecnt=0;

asmp = NET.addAssembly('C:\Program Files\Polyspace\R2019b\bin\win64\MarketData.dll');
asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;

bf=System.Runtime.Serialization.Formatters.Binary.BinaryFormatter; 
inputstream=System.IO.FileStream(filename,System.IO.FileMode.Open,System.IO.FileAccess.Read,System.IO.FileShare.Read);

rbc=1;
while (inputstream.Length>0)
    try
   
v1=System.Object;
v1=bf.Deserialize(inputstream);

sdt=v1.dateTimeString.char;
sdt=sdt(1:end-6);
marketdata.Date(rbc)=datetime(sdt);
%marketdata.Book(:,:,rbc).components=zeros(120,8);

        marketdata.Book(:,:,rbc)=v1.components.single';
  
    catch exception
        getReport(exception,'extended','hyperlinks','off')
        break;
    end
    
    sumsums=sum(sum(squeeze(marketdata.Book(:,1:4,rbc))));
    sumsumb=sum(sum(squeeze(marketdata.Book(:,5:8,rbc))));
    if (sumsums==0 || sumsumb==0)
        
    else
     rbc=rbc+1;
    end
     
end
rbc=rbc-1;
inputstream.Close;

marketdata.Book=marketdata.Book(1:120,1:8,1:rbc);
marketdata.Date=marketdata.Date(1:rbc);

end