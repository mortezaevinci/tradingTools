symbolclose=300;
datestring='2020-06-12';

symbol='aapl';
filename=['Z:\My files\Project trading\traderdata\book\' filefriendlysymbol(symbol) '_book_history ' datestring '.bn2'];

% symbol='SPY';
% filename=['Q:\My files\Project trading\repo\csharp\bookViewRunner\SPY_book_history_2020-05-29.bin'];


marketdata=getProcessedMarketdata2(filename,datestring);


save(['processed sample ' filefriendlysymbol(symbol) datestr(datetime(),"yyyy-mm-dd") '.mat'],'marketdata');

figure
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



%one sample
[book,midpoint]=rawbook2ordersbook(marketdata.Book(:,:,111));
book=cleanbook(book,midpoint);
booklelvels=closebooklevels(book);
barh(book(:,2),book(:,1),'k');



% all book levels
marketdata=marketbooklevels(marketdata);


%%load sample close data
filenametm=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) ' minute ' datestring '.mat'];
load(filenametm);


%%must verfiy that book levels are reasonable by minute data, because
%%apparenly sometimes the changing symbol of bookviewer doesn't work, and
%% it will make us have wrong data

marketdata.BookLevels(marketdata.BookLevels>tm.Close*1.3 | marketdata.BookLevels<tm.Close*0.7)=nan;



figure
plot(shiftpad(marketdata.BookLevels(:,1),0));
hold on
plot(shiftpad(marketdata.BookLevels(:,2),0));
hold on
plot(tm.Close);