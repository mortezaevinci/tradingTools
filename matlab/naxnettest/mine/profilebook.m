symbol='BA';
book=readbook(symbol);
if (~isempty(book))
book=cleanbook(book,55);
profile(book(:,1),book(:,2));
end