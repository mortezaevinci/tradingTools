close=10;
datestring='2020-06-12';

symbol='AAL';
filename=['Z:\My files\Project trading\traderdata\book\' filefriendlysymbol(symbol) '_book_history ' datestring '.bin'];

% symbol='SPY';
% filename=['Q:\My files\Project trading\repo\csharp\bookViewRunner\SPY_book_history_2020-05-29.bin'];

marketdata=getProcessedMarketdata(filename,datestring);

save(['processed sample ' filefriendlysymbol(symbol) datestr(datetime(),"yyyy-mm-dd") '.mat'],'marketdata');

plot(marketdata.Date,-marketdata.scores.dist.relativeSumClose);
figure
plot(marketdata.Date,marketdata.scores.dist.relativeSumTotal);
figure
plot(marketdata.Date,marketdata.scores.dist.relativeSumMid{1});
figure
plot(marketdata.Date,marketdata.scores.dist.relativeSumMid{2});
figure
plot(marketdata.Date,marketdata.scores.dist.relativeSumMid{3});

figure
plot(marketdata.Date,marketdata.scores.shares.relativeTotal);
figure
plot(marketdata.Date,marketdata.scores.shares.relativeTotalClose);
yb=-119:120;
bbt=[squeeze(marketdata.Book(120:-1:1,8,:));squeeze(marketdata.Book(1:120,4,:))];
figure
h=imagesc(1:numel(marketdata.Date),yb,bbt);
hold on;
plot([1 numel(marketdata.Date)],[0 0],'w');

bbts=[squeeze(marketdata.Book(120:-1:1,6,:));squeeze(marketdata.Book(1:120,2,:))];
figure
h=imagesc(1:numel(marketdata.Date),yb,bbts);
hold on;
plot([1 numel(marketdata.Date)],[0 0],'w');

npb=size(marketdata.PercentileBook,1);

%% have not figured the signs and buy/sell side yet
y=[-marketdata.PercentileCalcs.percentsover(npb:-1:2);marketdata.PercentileCalcs.percentsover];
bbt=[squeeze(marketdata.PercentileBook(npb:-1:1,3,:));squeeze(marketdata.PercentileBook(1:npb,1,:))];
figure
h=imagesc(1:numel(marketdata.Date),y,bbt);

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


