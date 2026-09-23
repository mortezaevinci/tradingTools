basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1120;

setupname='test';

contracts={genContract(ibcontractmanager,'AAL')};

port=[4002 4004 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "1 Y"; % //S,D,W,M,Y
    barsize = "1 day";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=1; % during market time
    
    latestday=1500;

    beginning=1490;

    oldtonew=1;
    dateslist=listDatesFromLast(oldtonew,beginning,latestday);
    fndataid='daily 1y';
    timetablename={'td'};

    errorTimeout=15;
    intrpTimeout=5;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;