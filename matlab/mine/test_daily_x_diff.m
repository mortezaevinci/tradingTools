base{1}=['Z:\My files\Project trading\traderdata\data\'];
base{2}=['Z:\My files\Project trading\traderdata\data_other\IB\'];

datatype{1}='daily 1y';
datatype{2}='dailyx1y';

contracts_penniesm2_trade;

date='2020-12-23';

nc=numel(contracts);

for c=1:nc
   fsym=contracts{c}.FileSymbol;
   fnexist=1;
   for i=1:2
      fn{i}=[base{i} '\' fsym '\' fsym ' ' datatype{i} ' ' date '.mat']; 
      if (~exist(fn{i}))
          fnexist=0;
      else
          load(fn{i});
          ttd{i}=table2timetable(td);
          tr0{i}=ttd{i}.Date(1);
          tr1{i}=ttd{i}.Date(end);
      end
   end
   
   if (fnexist)
      try
      tr0_=iif(tr0{1}>tr0{2},tr0{1},tr0{2});
      tr1_=iif(tr1{1}<tr1{2},tr1{1},tr1{2});
      tr=timerange(tr0_,tr1_);
      
      for i=1:2
      ttr{i}=ttd{i}(tr,:);
      highs{i}=max(ttr{i}.High,shiftpad(ttr{i}.High,1));
      lows{i}=max(ttr{i}.Low,shiftpad(ttr{i}.Low,1));
      end
      
      xpercent=(abs(highs{2}-lows{2})-abs(highs{1}-lows{1}))./highs{1};
      [mxp,mindex]=max(xpercent);
      if (mxp>1)
      disp([fsym ' max RTH diff=' num2str(mxp) '% happening at ' datestr(tdiff.Date(mindex))]);
      end
       catch exception
           
       end
   end
  
end
