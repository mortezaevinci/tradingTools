function book=readbooks(symbol)

book=[];
try
    
filename=['Z:\My files\Project trading\traderdata\book\' filefriendlysymbol(symbol) '_book_realtime.txt'];
if (exist(filename)>0)
    
fields_per_line = 8;  %for example
fmt = repmat('%s',1,fields_per_line);
fid = fopen(filename, 'rt');
filebycolumn = textscan(fid, fmt, 'Delimiter', '\t');
fclose(fid);
bookdata = horzcat(filebycolumn{:});

buybookc=bookdata(end:-1:1,2:3);
sellbookc=bookdata(1:end,6:7);

buybook=cell2mat(cellfun(@str2num,buybookc,'un',0));
sellbook=cell2mat(cellfun(@str2num,sellbookc,'un',0));

book=[buybook;sellbook];
end
catch exception
getReport(exception,'extended','hyperlinks','off');
book=[];
end
end
