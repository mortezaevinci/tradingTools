basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1140;

setupname='5sec';

contracts_ib;
contracts_ib_major;

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
contracts={genContract(ibcontractmanager,'AAPL')};

port=[4004 4002 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "1 D"; % //S,D,W,M,Y
    barsize = "5 secs";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=1; % during market time
    
    latestday=75;

    beginning=10;
if (beginning ==1 && datetime('now','TimeZone','America/New_York').Hour>=20) %after 8 o'clock, get today's data as well.
        beginning=0;
    end

    oldtonew=1;
    dateslist=listDatesFromLast(oldtonew,beginning,latestday);
    fndataid='5sec';
    timetablename={'tm'};

        errorTimeout=45;
    intrpTimeout=10;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;