function [book,midpoint]=readbook(looperEngine,FileSymbol)
midpoint=0;
book=[];
try
    
filename=[looperEngine.directories.book filefriendlysymbol(FileSymbol) '_book_realtime.txt'];
if (exist(filename)>0)
    
fields_per_line = 8;  %for example
fmt = repmat('%s',1,fields_per_line);
fid = fopen(filename, 'rt');
filebycolumn = textscan(fid, fmt, 'Delimiter', '\t');
fclose(fid);
rawbookdata = horzcat(filebycolumn{:});

[book,midpoint]=rawbook2ordersbook(rawbookdata);
end
catch exception
dumpReport('error.log', exception);
book=[];
end
end
