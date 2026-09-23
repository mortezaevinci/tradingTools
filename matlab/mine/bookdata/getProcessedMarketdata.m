function marketdata=getProcessedMarketdata(filename,datestring)

marketdata=loadRawbookFromBinFile(filename);


%average intraminute data
%*** THIS DOES NOT WORK BECAUSE THE PRICE DATA ARE STILL NOT THE SAME
%marketdata=averageIntraMinutes(marketdata);

%THIS FOR NOW OVERWRITES THE MARKETDATA SO IT HAS TO BE DONE FIRST
marketdata=lastIntraMinutes(marketdata);

inds=find ( marketdata.Date>datetime([datestring ' 09:29:00']) & marketdata.Date<datetime([datestring ' 16:00:00']));
dd=marketdata.Date(inds);
marketdata.Date=marketdata.Date(inds);
marketdata.Book=marketdata.Book(:,:,inds);


marketdata=generatePercentileBook(marketdata);

%**** THIS IS INEFFICIENT, The array one is done instead.
% IT IS PROBABLY BETTER TO USE THE ACTUAL BOOK INSTEAD IN ALL SECTIONS AND
% DO NOT GENERATE THIS IN THE FIRST PLACE
% for i=1:size(marketdata.Book)
%    marketdata.OrdersBook{i}=rawbook2ordersbook(marketdata.Book(:,:,i)); 
%    %This is really only for viewing data, not for NN
%    %marketdata.OrdersBook{i}=cleanbook(marketdata.OrdersBook{i},close);
% end
marketdata=generateOrderBooks(marketdata);

% DEVELOP ONE FOR SHOWING BOOK IN PERCENTILE SEGMENTS OF PRICE SO THAT ALL
% ARE IN HARMONEY AND THEY CAN BE AVERAGED AND COMPARED DIRECTLY

%do only 29th

marketdata.scores=scoreMarketdata(marketdata);


end