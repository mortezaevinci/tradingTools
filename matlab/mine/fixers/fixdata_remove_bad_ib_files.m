%compare ib and yahoo volume

contracts_ib;



for c=1:51%numel(contracts)
        try
symbol=contracts{c}.FileSymbol;

d1=['Z:\My files\Project trading\traderdata\data\' symbol '\' symbol ' daily 1y 2020-07-10.mat'];
load(d1);
ttd=table2timetable(td);
for i=0:180
    try
dd=datetime()-days(i);
ds=datestr(dd,'yyyy-mm-dd');
dd=datetime([ds ' 00:00:00']);
if (isbusday(dd))

tr=timerange(dd-hour(1),dd+hours(16));
daily=ttd(tr,:);

d2=['Z:\My files\Project trading\traderdata\data_other\IB\' symbol '\' symbol ' minute ' ds '.mat'];

load(d2);
t2=mean(tm.Open(1));

t1=daily.Open;

%disp(['date' ds ' ib open=' num2str(t2) ' daily open=' num2str(daily.Open)]);

if (t1/t2>1.01 || t1/t2<0.99)
    
   disp(['removed : ' d2]);
   delete(d2);
end
end
    catch exception
     %  disp(exception.message);
    end
end
  catch exception
     %  disp(exception.message);
    end
end