date0='2020-08-26';

if (~exist('loadcsvday') || strcmp(loadcsvday,date0)==0)
weekday0=weekday(datetime(date0))-1;
dd=datestr(datetime(date0),'yyyymmdd');
csvfile=['C:\temp\_results\tradingtools\investment_notes\marketchameleon\OptionTradeScreenerResults_' dd '.csv'];
chamm1day=readtable(csvfile);

loadcsvday=date0;
end

symbol='AAPL';
chartfile=['Z:\My files\Project trading\traderdata\data\' symbol '\' symbol ' minute ' date0 '.mat'];
load(chartfile);



str1=[date0 ' '];
strc=repmat(str1,size(chamm1day,1),1);
datetimes1day=datetime([strc datestr(chamm1day.Time,'hh:MM:ss')]);

maxdaystoexpiry=1000; %6 for weekly, 30 for monthly, 1000 for all
minnotional=10000;

c_symbol=strcmp(chamm1day.Symbol,symbol)==1;
c_buyside=strcmp(chamm1day.Side,'Ask')==1 | strcmp(chamm1day.Side,'Above')==1;%| strcmp(chamm1day.Side,'Mid')==1;
c_call=strcmp(chamm1day.Type,'CALL');
c_daystoexpire=(chamm1day.DaysToExp+weekday0-1)<maxdaystoexpiry; %will give weeklies
c_sellside=strcmp(chamm1day.Side,'Bid')==1 | strcmp(chamm1day.Side,'Below')==1;%| strcmp(chamm1day.Side,'Mid')==1;
c_put=strcmp(chamm1day.Type,'PUT');
c_notional=chamm1day.Trade__nbsp_Notional>minnotional;

useind{1}=find(c_notional & c_symbol & c_buyside & c_call & c_daystoexpire); %bull
useind{2}=find(c_notional & c_symbol & c_sellside & c_put & c_daystoexpire);%bull
useind{3}=find(c_notional & c_symbol & c_sellside & c_call & c_daystoexpire);%bear
useind{4}=find(c_notional & c_symbol & c_buyside & c_put & c_daystoexpire);%bear
useind{5}=find(c_notional & c_symbol & ~c_sellside & ~c_buyside & c_put & c_daystoexpire);%bull
useind{6}=find(c_notional & c_symbol & ~c_sellside & ~c_buyside & c_call & c_daystoexpire);%bear

figure
cndl5(tm);
hold on;

symbolind=find(c_symbol);

maxnote=max(chamm1day(symbolind,:).Trade__nbsp_Notional)/500;

ui=1;s='o';cl=[0 1 0];scatter(datetimes1day(useind{ui}),chamm1day(useind{ui},:).Strike,(chamm1day.Trade__nbsp_Notional(useind{ui})/maxnote),s,'MarkerEdgeColor',cl);
ui=2;s='d';cl=[0 1 0];scatter(datetimes1day(useind{ui}),chamm1day(useind{ui},:).Strike,(chamm1day.Trade__nbsp_Notional(useind{ui})/maxnote),s,'MarkerEdgeColor',cl);
ui=3;s='o';cl=[1 0 0];scatter(datetimes1day(useind{ui}),chamm1day(useind{ui},:).Strike,(chamm1day.Trade__nbsp_Notional(useind{ui})/maxnote),s,'MarkerEdgeColor',cl);
ui=4;s='d';cl=[1 0 0];scatter(datetimes1day(useind{ui}),chamm1day(useind{ui},:).Strike,(chamm1day.Trade__nbsp_Notional(useind{ui})/maxnote),s,'MarkerEdgeColor',cl);
ui=5;s='d';cl=[.8 0 .8];scatter(datetimes1day(useind{ui}),chamm1day(useind{ui},:).Strike,(chamm1day.Trade__nbsp_Notional(useind{ui})/maxnote),s,'MarkerEdgeColor',cl);
ui=6;s='o';cl=[0 .8 .8];scatter(datetimes1day(useind{ui}),chamm1day(useind{ui},:).Strike,(chamm1day.Trade__nbsp_Notional(useind{ui})/maxnote),s,'MarkerEdgeColor',cl);


