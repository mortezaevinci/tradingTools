symbolclose=300;
datestring='2020-06-12';

symbol='AAPL';


filename=['Z:\My files\Project trading\traderdata\book\' filefriendlysymbol(symbol) '_book_history ' datestring '.bn2'];
marketdata=getProcessedMarketdata2(filename,datestring);
marketdata=marketbooklevels(marketdata);
%marketdata.BookLevels(marketdata.BookLevels>tm.Close*1.3 | marketdata.BookLevels<tm.Close*0.7)=nan;

