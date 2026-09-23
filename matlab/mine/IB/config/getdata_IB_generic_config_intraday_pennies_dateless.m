basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1020;

setupname='intraday_pennies';

contracts_penniesm2;

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
% contracts={genContract(ibcontractmanager,'AAPL')};

port=[4002 4004 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "1 D"; % //S,D,W,M,Y
    barsize = "1 min";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=0; % during market time
    
    

    fndataid='minute';
    timetablename={'tmfull'};

        errorTimeout=5;
    intrpTimeout=3;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;