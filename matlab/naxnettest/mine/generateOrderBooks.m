function marketdata=generateOrderBooks(marketdata)

marketdata.OrdersBook=[marketdata.Book(end:-1:1,2:3,:);marketdata.Book(1:end,6:7,:)]; %buy book and sell book
marketdata.OrdersBook(marketdata.OrdersBook(:,1)==0,:)=[];
end