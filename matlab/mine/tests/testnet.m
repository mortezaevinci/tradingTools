

asmp = NET.addAssembly('C:\Program Files\Polyspace\R2019b\bin\win64\MarkteData.dll');
asm1 = NET.addAssembly('System.IO');
asm2 = NET.addAssembly('System.Runtime.Serialization');

import System.IO.*;
import MHA.*;

bf=System.Runtime.Serialization.Formatters.Binary.BinaryFormatter; 
inputstream=System.IO.FileStream('z:\My files\Project Trading\matlab\traderdata\book\AAL_book_history.bin',System.IO.FileMode.Open,System.IO.FileAccess.Read,System.IO.FileShare.Read);

rbc=1;
while (inputstream.Length>0)
    try
    rbc=rbc+1
objectype=MarketDataDefinition;
v1=System.Object;
v1=bf.Deserialize(inputstream)

sdt=v1.dateTimeString.char;
sdt=sdt(1:end-6);
rawbook{rbc}.dt=datetime(sdt);
rawbook{rbc}.components=zeros(120,8);

        rawbook{rbc}.components=v1.components.single';
  
    catch
        break;
    end
end
inputstream.Close;