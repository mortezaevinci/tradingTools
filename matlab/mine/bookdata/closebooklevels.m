function booklevels=closebooklevels(book)
booklevels=[nan nan];

mbook1=mean(book(:,1))*5;
bookmidindex=round(size(book,1)/2);
if (bookmidindex==0)
    return;
end
highlevelind1=bookmidindex-1+find(book(bookmidindex:end,1)>mbook1);
highlevelind2=find(book(1:bookmidindex-1,1)>mbook1);

%midpointvalue=book(bookmidindex,2);
%highlim=midpointvalue*1.3;
%lowlim=midpointvalue*0.7;
try
    
if (isempty(highlevelind1))
  %booklevels(2)=nan;
else
booklevels(2)=book(highlevelind1(1),2);
end

if (isempty(highlevelind2))
  %  booklevels(1)=nan;
else
booklevels(1)=book(highlevelind2(end),2);
end

catch
 disp('closebooklevels error');
end



end