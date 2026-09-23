marketdata=cell(1,1000);
samplecnt=0;
booksamplecnt=0;
symbol='SPY';
filename=[symbol '_book_history.txt'];

ttt='-{%s}-';
%filetext = fileread('fileread.m');
fid = fopen(filename);
 while(1)
     tline = fgetl(fid);
     if (~ischar(tline))
         break;
     end
     if (numel(tline)>5)
     if (tline(2)=='{' && tline(end-1)=='}')
   datestring=tline(3:12);
   timestring=tline(14:21);
    dt=datetime([datestring ' ' timestring]);
    samplecnt=samplecnt+1
    marketdata{samplecnt}.Date=dt;
    marketdata{samplecnt}.Book=zeros(120,8);
    booksamplecnt=0;
     else
         C = strsplit(tline);
        C = cellfun(@str2double,C);
        if (numel(C)==9) %there is an unused delimitted
        C = C(1:8);
        booksamplecnt=booksamplecnt+1;
        marketdata{samplecnt}.Book(booksamplecnt,:)=C;
        end
     end
     end
     
     
 end
fclose(fid);


close=300;

for i=1:size(marketdata)
   marketdata{i}.OrdersBook=cleanbook(rawbook2ordersbook(marktedata{i}.Book),close);
    
end
