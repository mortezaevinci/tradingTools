loadcsv=0;
dates0={'2020-08-11','2020-08-12','2020-08-13','2020-08-14','2020-08-17','2020-08-18','2020-08-19','2020-08-20','2020-08-21','2020-08-24','2020-08-25','2020-08-26','2020-08-27'};

if (loadcsv==1)
for i=1:numel(dates0)
date0=dates0{i};
weekday0=weekday(datetime(date0))-1;
dd=datestr(datetime(date0),'yyyymmdd');
csvfile=['C:\temp\_results\investment_notes\marketchameleon\OptionTradeScreenerResults_' dd '.csv'];
chamm{i}=readtable(csvfile);
end
end

ddate0='2020-09-24';
symbol='AAPL';
chartfile=['Z:\My files\Project trading\traderdata\data\' symbol '\' symbol ' daily 1y ' ddate0 '.mat'];
load(chartfile);

%*************
split=4;
%*************

td.Open=td.Open*split;
td.Close=td.Close*split;
td.High=td.High*split;
td.Low=td.Low*split;

figure
cndl5(td);
hold on;

for i=1:numel(dates0)
    date0=dates0{i}
str1=[date0 ' '];
strc=repmat(str1,size(chamm{i},1),1);
datetimes{i}=datetime([strc datestr(chamm{i}.Time,'hh:MM:ss')]);

maxdaystoexpiry=1000; %7 for weekly, 30 for monthly, 1000 for all
mindaystoexpiry=6;
minnotional=100;

c_symbol=strcmp(chamm{i}.Symbol,symbol)==1;
c_buyside=strcmp(chamm{i}.Side,'Ask')==1 | strcmp(chamm{i}.Side,'Above')==1;%| strcmp(chamm{i}.Side,'Mid')==1;
c_call=strcmp(chamm{i}.Type,'CALL');
c_daystoexpire=(chamm{i}.DaysToExp+weekday0-1)<maxdaystoexpiry & (chamm{i}.DaysToExp+weekday0-1)>mindaystoexpiry; %will give weeklies
c_sellside=strcmp(chamm{i}.Side,'Bid')==1 | strcmp(chamm{i}.Side,'Below')==1;%| strcmp(chamm{i}.Side,'Mid')==1;
c_put=strcmp(chamm{i}.Type,'PUT');
c_notional=chamm{i}.Trade__nbsp_Notional>minnotional;

useind{1}=find(c_notional & c_symbol & c_buyside & c_call & c_daystoexpire); %bull
useind{2}=find(c_notional & c_symbol & c_sellside & c_put & c_daystoexpire);%bull
useind{3}=find(c_notional & c_symbol & c_sellside & c_call & c_daystoexpire);%bear
useind{4}=find(c_notional & c_symbol & c_buyside & c_put & c_daystoexpire);%bear
useind{5}=find(c_notional & c_symbol & ~c_sellside & ~c_buyside & c_put & c_daystoexpire);%bull
useind{6}=find(c_notional & c_symbol & ~c_sellside & ~c_buyside & c_call & c_daystoexpire);%bear

symbolind=find(c_symbol);

maxnote=max(chamm{i}(symbolind,:).Trade__nbsp_Notional)/100;

cls={[0 1 0],[0 1 0],[1 0 0],[1 0 0],[0.8 0 0.8],[0 0.7 0.7]};
ss=['o','d','o','d','d','o'];
for ui=1:6
    dt=datetimes{i}(1);
    strike=mean(chamm{i}(useind{ui},:).Strike);
    notional=sum(chamm{i}.Trade__nbsp_Notional(useind{ui}));
cl=cls{ui};
scatter(dt,strike,notional/maxnote,ss(ui),'MarkerEdgeColor',cl);
end

end