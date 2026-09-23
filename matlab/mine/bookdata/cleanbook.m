function book=cleanbook(book,close)
indx=find(book(:,2) > close*.7 & book(:,2) < close*1.3);
book=book(indx,:);

%also reduce very big numbers, so that others are visible

shares=book(:,1);
ave=sum(shares)/numel(shares);
thresh=ave*20;

book(shares>thresh,1)=book(shares>thresh,1)/20;


end