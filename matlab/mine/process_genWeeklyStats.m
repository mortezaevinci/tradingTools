%looperEngine.symbols={'AAL','AAPL','AMD','AMZN','BAC','BA','BYND','DIS','FB','MSFT','NVDA','NFLX','WMT','SHOP','TSLA','SPY'};
looperparams_realtime_t9_ID3;


ncontracts=numel(looperEngine.contracts);

for i=1:ncontracts
contract=looperEngine.contracts{i};

lastcapturedate='2020-06-19';

filename=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(contract.FileSymbol) '\' filefriendlysymbol(contract.FileSymbol) ' daily 1y ' lastcapturedate '.mat'];

%1=sunday
weeklies_intraday_cnt=zeros(1,7);
weeklies_intraday_diff=zeros(1,7);
weeklies_aftermarket_diff=zeros(1,7);
weeklies_aftermarket_cnt=zeros(1,7);
lastopen=nan;
if (exist(filename))
   load(filename); 
    
   tt=table2timetable(td);
   tt=tt(1:end,:); % could look at a specific area instead-
   for i=1:size(tt,1)
      r=tt(i,:);
      d=r.Close-r.Open;
      dt=r.Date;
      wd=weekday(dt);
      weeklies_intraday_cnt(wd)=weeklies_intraday_cnt(wd)+1;
      weeklies_intraday_diff(wd)=weeklies_intraday_diff(wd)+d;
      if (~isnan(lastopen))
      weeklies_aftermarket_cnt(wd)=weeklies_aftermarket_cnt(wd)+1;
      weeklies_aftermarket_diff(wd)=weeklies_aftermarket_diff(wd)+r.Open-lastopen;
      end
      
      lastopen=r.Open;
   end
   %for wd=1:7
    weeklies_intraday_diff=weeklies_intraday_diff./weeklies_intraday_cnt;
    weeklies_aftermarket_diff=weeklies_aftermarket_diff./weeklies_aftermarket_cnt;   %end
end
disp(contract.Symbol);
weeklies_intraday_diff(2:6)
disp('fri-mon mon-tue tue-wed wed-thu thu-fri');
weeklies_aftermarket_diff(2:6)

end