FileSymbol='BA';
[book,bid,ask,date]=readbookBn2(FileSymbol);
if (~isempty(book))
	midpoint=(bid+ask)/2;
book=cleanbook(book,midpoint);
profile(book(:,1),book(:,2));
end