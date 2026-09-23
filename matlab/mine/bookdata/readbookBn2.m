function [book,bid,ask,date]=readbookBn2(looperEngine,FileSymbol)
midpoint=0;
book=[];
bid=0;
ask=0;
date=datetime();
try
    
filename=[looperEngine.directories.book filefriendlysymbol(FileSymbol) '_book_realtime.bn2'];
if (exist(filename)>0)
    
marketdata=loadRawbookFromBinFile2(filename);
rawbookdata=marketdata.Book(:,:,end);
date=marketdata.Date(end);

[book,bid,ask]=rawbook2ordersbook(rawbookdata);
end
catch exception
dumpReport('error.log', exception);
book=[];
end
end
