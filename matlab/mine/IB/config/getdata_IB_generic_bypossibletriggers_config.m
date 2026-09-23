basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1200;

setupname='by possibletriggers';

port=[4002 4004 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "1 D"; % //S,D,W,M,Y
    barsize = "1 min";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=0; % during market time
    
    latestday=2;
    beginning=1;
    oldtonew=1;
    dateslist=listDatesFromLast(oldtonew,beginning,latestday);

    fndataid='minute';
    timetablename={'tmfull'};

        errorTimeout=15;
    intrpTimeout=5;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    maxRequestPerConnection=48;