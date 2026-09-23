function book=rawbook2ordersbook(rawbook)


buybook=rawbook(end:-1:1,2:3);
sellbook=rawbook(1:end,6:7);
if (iscell(buybook))
buybook=cell2mat(cellfun(@str2num,buybook,'un',0));
sellbook=cell2mat(cellfun(@str2num,sellbook,'un',0));
end
book=[buybook;sellbook];
book(book(:,1)==0,:)=[];
end