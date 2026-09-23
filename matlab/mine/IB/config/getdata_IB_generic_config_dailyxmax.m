basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1050;

setupname='dailyxmax';

contracts_penniesm2;c1=contracts;
contracts_ib;c2=contracts;
contracts_nasdaq;c3=contracts;
contracts={c1{:},c2{:},c3{:}};
contracts=uniqueContracts(contracts,'FileSymbol');

port=[4002 4004 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "20 Y"; % //S,D,W,M,Y
    barsize = "1 day";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=0; % during market time
    
    latestday=2;
    beginning=1;

    oldtonew=0;
    dateslist=listDatesFromLast(oldtonew,beginning,latestday);

    fndataid='dailyxmax';
    timetablename={'td'};

    errorTimeout=50;
    intrpTimeout=10;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;