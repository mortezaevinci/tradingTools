basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1030;

setupname='intraday';

contracts_main;
contracts_ib_major;

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
%contracts={genContract(ibcontractmanager,'AAPL')};

port=[4002];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "1 D"; % //S,D,W,M,Y
    barsize = "1 min";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=0; % during market time
    
    latestday=800;

    beginning=1;
    
if (beginning ==1 && datetime('now','TimeZone','America/New_York').Hour>=20) %after 8 o'clock, get today's data as well.
        beginning=0;
    end

    oldtonew=1;
    dateslist=listDatesFromLast(oldtonew,beginning,latestday);

    fndataid='minute';
    timetablename={'tmfull'};

        errorTimeout=15;
    intrpTimeout=5;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;