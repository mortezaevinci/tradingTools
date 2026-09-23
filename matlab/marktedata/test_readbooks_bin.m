close=10;
datestring='2020-06-02';

symbol='TSLA';
filename=['Z:\My files\Project trading\traderdata\book\' filefriendlysymbol(symbol) '_book_history ' datestring '.bin'];

% symbol='SPY';
% filename=['Q:\My files\Project trading\repo\csharp\bookViewRunner\SPY_book_history_2020-05-29.bin'];
marketdata=loadRawbookFromBinFile(filename);


save(['Z:\My files\Project trading\traderdata\markettest\sample ' filefriendlysymbol(symbol) datestr(datetime(),"yyyy-mm-dd") ' raw.mat'],'marketdata');


%average intraminute data
%*** THIS DOES NOT WORK BECAUSE THE PRICE DATA ARE STILL NOT THE SAME
%marketdata=averageIntraMinutes(marketdata);

%THIS FOR NOW OVERWRITES THE MARKETDATA SO IT HAS TO BE DONE FIRST
marketdata=lastIntraMinutes(marketdata);


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


save(['Z:\My files\Project trading\traderdata\markettest\sample ' filefriendlysymbol(symbol) datestr(datetime(),"yyyy-mm-dd") '.mat'],'marketdata');


% DEVELOP ONE FOR SHOWING BOOK IN PERCENTILE SEGMENTS OF PRICE SO THAT ALL
% ARE IN HARMONEY AND THEY CAN BE AVERAGED AND COMPARED DIRECTLY

%do only 29th

inds=find ( marketdata.Date>datetime([datestring ' 09:29:00']) & marketdata.Date<datetime([datestring ' 16:00:00']));
dd=marketdata.Date(inds);

scores=scoreMarketdata(marketdata);

save(['processed sample ' filefriendlysymbol(symbol) datestr(datetime(),"yyyy-mm-dd") '.mat'],'marketdata');

plot(marketdata.Date(inds),-scores.dist.relativeSumClose(inds));
figure
plot(marketdata.Date(inds),scores.dist.relativeSumTotal(inds));
figure
plot(marketdata.Date(inds),scores.dist.relativeSumMid{1}(inds));
figure
plot(marketdata.Date(inds),scores.dist.relativeSumMid{2}(inds));
figure
plot(marketdata.Date(inds),scores.dist.relativeSumMid{3}(inds));


figure


figure
plot(marketdata.Date(inds),scores.shares.relativeTotal(inds));
figure
plot(marketdata.Date(inds),scores.shares.relativeTotalClose(inds));
yb=-119:120;
bbt=[squeeze(marketdata.Book(120:-1:1,8,inds));squeeze(marketdata.Book(1:120,4,inds))];
figure
h=imagesc(1:numel(marketdata.Date(inds)),yb,bbt);
hold on;
plot([1 numel(marketdata.Date(inds))],[0 0],'w');

bbts=[squeeze(marketdata.Book(120:-1:1,6,inds));squeeze(marketdata.Book(1:120,2,inds))];
figure
h=imagesc(1:numel(marketdata.Date(inds)),yb,bbts);
hold on;
plot([1 numel(marketdata.Date(inds))],[0 0],'w');

npb=size(marketdata.PercentileBook,1);

%% have not figured the signs and buy/sell side yet
y=[-marketdata.PercentileCalcs.percentsover(npb:-1:2);marketdata.PercentileCalcs.percentsover];
bbt=[squeeze(marketdata.PercentileBook(npb:-1:1,3,inds));squeeze(marketdata.PercentileBook(1:npb,1,inds))];
figure
h=imagesc(1:numel(marketdata.Date(inds)),y,bbt);

%hold on;
%plot([1 numel(marketdata.Date(inds))],[0 0],'w');

 %f=figure
 
 %y=120:-1:-119;
 %surface(marketdata.Date((end-3000):end),y,bbt(:,(end-3000):end));

 %figure
% 
% 
% 
% y=120:-1:-119;
% bbs=[squeeze(marketdata.Book(120:-1:1,6,:));squeeze(marketdata.Book(1:120,2,:))];
% surface(marketdata.Date,y,bbs);
% 
% figure
% 
% y=120:-1:-119;
% bbp=[squeeze(marketdata.Book(120:-1:1,7,:));squeeze(marketdata.Book(1:120,3,:))];
% bbmv=bbp.*bbs;
% surface(marketdata.Date,y,bbmv);
% 


