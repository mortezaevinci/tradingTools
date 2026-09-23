basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1280;

setupname='tickslaste';

%contracts_ib_majormajor;
contracts_ib_dupermajor;

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
%contracts={genContract(ibcontractmanager,'AAPL')};

port=[4004 4002 7497];
operation = 1; % 0=hisotrical data, 1=historical ticks accumulate day

numofticks = 1000;
ignoreSize = false;

whattoshow="TRADES";
interruptname = 'historicaltickslast';
ibDataHandlerName = 'ibDataHandler.historicalTickBidAsk';
RTHonly=0; % during market time

latestday=90;

beginning=1;

if (beginning ==1 && datetime('now','TimeZone','America/New_York').Hour>=20) %after 8 o'clock, get today's data as well.
    beginning=0;
end

oldtonew=0;
dateslist=listDatesFromLast(oldtonew,beginning,latestday);

fndataid='tickslast';
timetablename={'tickslast'};

errorTimeout=25;
intrpTimeout=120;

shutdownddt0=0.25;
shutdownddt1=0.5; %to not shutdown, make dd1 smaller than dd0

maxRequestPerConnection=5;