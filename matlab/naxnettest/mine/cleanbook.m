function book=cleanbook(book,close)
price=book(:,2);
indx=find(price> close*.7 & price<close*1.3);
book=book(indx,:);

%also reduce very big numbers, so that others are visible

shares=book(:,1);
ave=sum(shares)/numel(shares);
thresh=ave*20;

book(shares>thresh,:)=book(shares>thresh,:)/20;

end