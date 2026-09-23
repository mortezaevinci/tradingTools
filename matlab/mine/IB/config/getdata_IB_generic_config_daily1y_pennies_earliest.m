basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1110;

setupname='daily1y_pennies';

contracts_penniesm2;

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
% contracts={genContract(ibcontractmanager,'AAPL')};

port=[4004 4002 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "1 Y"; % //S,D,W,M,Y
    barsize = "1 day";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=1; % during market time
    
    latestday=90;

    beginning=1;
    
if (beginning ==1 && datetime('now','TimeZone','America/New_York').Hour>=20) %after 8 o'clock, get today's data as well.
        beginning=0;
    end

    oldtonew=0;
    dateslist=listDatesFromLast(oldtonew,beginning,latestday);

    fndataid='daily 1y';
    timetablename={'td'};

    errorTimeout=15;
    intrpTimeout=5;
    
    shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;