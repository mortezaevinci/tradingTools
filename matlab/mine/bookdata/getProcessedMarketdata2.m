function marketdata=getProcessedMarketdata2(filename,datestring)
try
    
marketdata=loadRawbookFromBinFile2(filename);

if (isempty(marketdata))
    return;
end
catch exception
   dumpReport('error.log', exception) 
end

try

marketdata=lastIntraMinutes(marketdata);
%inds=find ( marketdata.Date>datetime([datestring ' 09:29:00']) & marketdata.Date<datetime([datestring ' 16:00:00']));
%marketdata.Date=marketdata.Date(inds);
%marketdata.Book=marketdata.Book(:,:,inds);
catch exception
   dumpReport('error.log', exception) 
end

try
%**** THIS IS INEFFICIENT, The array one is done instead.
% IT IS PROBABLY BETTER TO USE THE ACTUAL BOOK INSTEAD IN ALL SECTIONS AND
% DO NOT GENERATE THIS IN THE FIRST PLACE
% for i=1:size(marketdata.Book)
%    marketdata.OrdersBook{i}=rawbook2ordersbook(marketdata.Book(:,:,i)); 
%    %This is really only for viewing data, not for NN
%    %marketdata.OrdersBook{i}=cleanbook(marketdata.OrdersBook{i},close);
% end
marketdata=generateOrderBooks(marketdata);

catch exception
   dumpReport('error.log', exception) 
end

%% 
try

marketdata=generatePercentileBook(marketdata);
catch exception
   dumpReport('error.log', exception) 
end

% DEVELOP ONE FOR SHOWING BOOK IN PERCENTILE SEGMENTS OF PRICE SO THAT ALL
% ARE IN HARMONEY AND THEY CAN BE AVERAGED AND COMPARED DIRECTLY

%do only 29th

try
marketdata.scores=scoreMarketdata(marketdata);
catch exception
   dumpReport('error.log', exception) 
end

end