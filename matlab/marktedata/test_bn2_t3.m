book=zeros(120,8,2000);
%dt=datetime()+zeros(1,2000);
posixtime=zeros(2000,1);
filename=['Q:\My files\Project Trading\traderdata\book\AAL_book_history 2020-06-11.bn2'];
marketdata=loadRawbookFromBinFile2(filename);