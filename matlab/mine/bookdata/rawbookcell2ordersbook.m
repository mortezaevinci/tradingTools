function book=rawbook2ordersbook(rawbook)


buybookc=rawbook(end:-1:1,2:3);
sellbookc=rawbook(1:end,6:7);

buybook=cell2mat(cellfun(@str2num,buybookc,'un',0));
sellbook=cell2mat(cellfun(@str2num,sellbookc,'un',0));

book=[buybook;sellbook];

end