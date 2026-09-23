basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1090;

setupname='dailymax_pennies';

contracts_penniesm2;

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
% contracts={genContract(ibcontractmanager,'AAPL')};

port=[4004 4002 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "20 Y"; % //S,D,W,M,Y
    barsize = "1 day";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=1; % during market time
    
    latestday=2;

    beginning=1;


    oldtonew=0;
    dateslist=listDatesFromLast(oldtonew,beginning,latestday);

    fndataid='daily max';
    timetablename={'td'};

    errorTimeout=50;
    intrpTimeout=10;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;