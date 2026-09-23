function marketdata=marketbooklevels(marketdata)
try
nbooks=size(marketdata.Book,3);

marketdata.BookLevels=zeros(nbooks,2);
for i=1:nbooks
[book,bid,ask]=rawbook2ordersbook(marketdata.Book(:,:,i));
midpoint=(bid+ask)/2;
book=cleanbook(book,midpoint);
marketdata.BookLevels(i,:)=closebooklevels(book);


end

% this clean up won't work because sporadic data's median become zero and
% data are all lost
%midpoint=movmedian((squeeze(marketdata.Book(1,3,:))+squeeze(marketdata.Book(1,7,:)))/2,[5 0]);
%marketdata.BookLevels(marketdata.BookLevels>midpoint*1.3 | marketdata.BookLevels<midpoint*0.7)=nan;
catch exception
   dumpReport('error.log', exception) 
end
end