
marketdata.Book=zeros(120,8,1000);
samplecnt=0;
booksamplecnt=0;
symbol='SPY';
filename=['Z:\My files\Project trading\traderdata\book\' filefriendlysymbol(symbol) '_book_history.txt'];

filetext = fileread(filename);
tlines=strsplit(filetext,'\r\n');


%gues size
n=numel(tlines)/60;% 2 times more than 120

for i=1:size(tlines,2)
     tline =tlines{i};
    
     if (numel(tline)>5)
     if (tline(2)=='{' && tline(end-1)=='}')
   datestring=tline(3:12);
   timestring=tline(14:21);
    dt=datetime([datestring ' ' timestring]);
    samplecnt=samplecnt+1
    marketdata.Date(samplecnt)=dt;
    booksamplecnt=0;
     else
         C = strsplit(tline,'\t');
        C = cellfun(@str2double,C);
        if (numel(C)==9) %there is an unused delimitted
        C = C(1:8);
        booksamplecnt=booksamplecnt+1;
        marketdata.Book(booksamplecnt,:,samplecnt)=C;
        end
     end
     end
     
     
end

 marketdata.Book=marketdata.Book(1:120,1:8,1:numel(marketdata.Date));

close=303;

for i=1:size(marketdata)
   marketdata.OrdersBook{i}=cleanbook(rawbook2ordersbook(marketdata.Book(:,:,i)),close);
    
end

save(['Z:\My files\Project trading\traderdata\markettest\sample ' filefriendlysymbol(symbol) datestr(datetime(),"yyyy-mm-dd") '.mat'],'marketdata');

y=-119:120;
priceask=squeeze(marketdata.Book(120:-1:1,7,:));
pricebuy=squeeze(marketdata.Book(1:120,4,:));

bbt=[squeeze(marketdata.Book(120:-1:1,8,:));squeeze(marketdata.Book(1:120,4,:))];
h=imagesc(1:numel(marketdata.Date),y,bbt);
hold on;
plot([1 numel(marketdata.Date)],[0 0],'w');


FD.time=marketdata.Date;
FD.tempfrac=bbt;
FD.mean=zeros(size(marketdata.Date));
FD.temp=y;
PlotFlirData(FD);


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
