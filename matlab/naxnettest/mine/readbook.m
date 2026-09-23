function book=readbook(symbol)

book=[];
try
    
filename=['Z:\My files\Project trading\traderdata\book\' filefriendlysymbol(symbol) '_book_realtime.txt'];
if (exist(filename)>0)
    
fields_per_line = 8;  %for example
fmt = repmat('%s',1,fields_per_line);
fid = fopen(filename, 'rt');
filebycolumn = textscan(fid, fmt, 'Delimiter', '\t');
fclose(fid);
rawbookdata = horzcat(filebycolumn{:});

book=rawbook2ordersbook(rawbookdata);
end
catch exception
getReport(exception,'extended','hyperlinks','off');
book=[];
end
end
